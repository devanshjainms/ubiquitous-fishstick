"""Interface for the helper module. 
This module contains the interface for the helper module and azure functions.
"""

import ast
import os
import json
import logging
from dataclasses import asdict
from marshmallow_dataclass import class_schema
from helper.constants import SAP_CONFIG_KEY_VAULT_KEY, DOCUMENT_CONTENT_TYPE
from helper.models import PrintItemStatus
from helper.sap_client import SAPPrintClient
from helper.models import SAPSystem
from helper.key_vault import KeyVault
from helper.storage import StorageQueueClient, TableStorageClient
from helper.universal_print_client import (
    UniversalPrintUsingLogicApp,
    UniversalPrintClient,
)


class BackendPrint:
    def __init__(self, logger: logging, log_tag: str) -> None:
        self.logger = logger
        self.log_tag = log_tag
        self.sap_systems = []

    def _load_schema(self, sap_config: dict):
        """_summary_

        Args:
            sap_config (dict): _description_

        Raises:
            Exception: _description_

        Returns:
            SAPsystem: system properties
        """
        try:
            sap_system_schema = class_schema(SAPSystem)()
            return sap_system_schema.load(sap_config)
        except Exception as e:
            raise Exception(f"Error occurred SAP config: {e}")

    def _get_sap_config(self):
        """Get the SAP config from the key vault"""
        self.sap_systems = []
        sap_configs = KeyVault().get_sap_config_secrets()
        for sap_config in sap_configs:
            self.sap_systems.append(self._load_schema(json.loads(sap_config.value)))
        return self.sap_systems

    def _send_message_to_storage_queue(self, print_messages):
        """Send the print messages to the storage queue.

        Args:
            print_messages (list): List of print messages
        """
        try:
            for print_message in print_messages:
                StorageQueueClient().send_message(message=print_message)
        except Exception as e:
            return {
                "status": "error",
                "message": "Error occurred while sending message",
            }

    def _update_print_messages_status(
        self, print_messages, status=PrintItemStatus.IN_PROGRESS.value, error_message=""
    ):
        """Update the status of the print messages.

        Args:
            print_messages (list): List of print messages
        """
        try:
            for print_message in print_messages:
                TableStorageClient().put_entity(
                    table_name=os.environ["STORAGE_TABLE_NAME"],
                    entity={
                        "PartitionKey": print_message["sap_sid"],
                        "RowKey": print_message["print_item"]["queue_item_id"],
                        "Status": status,
                        "Message": error_message,
                    },
                )
        except Exception as e:
            return {
                "status": "error",
                "message": "Error occurred while sending message",
            }

    def validation_engine(self, sap_config: dict):
        """Validate the connection to the SAP system.
        Validate the queue names are present in the SAP system.
        If the validation pass, store the connection details in the Key Vault.

        Args:
            sap_config (dict): _description_

        Returns:
            _type_: _description_
        """
        try:
            sap_configuration_map = self._load_schema(sap_config)
            print_client = SAPPrintClient(sap_configuration_map)
            sap_queues = print_client.get_print_queues()
            for queue in sap_queues:
                if not print_client.find_print_queue(queue):
                    return {"status": "error", "message": "Incorrect queue information"}
            self.logger.info(
                f"[{self.log_tag}] SAP connection validated, saving to key vault"
            )
            KeyVault().set_kv_secrets(
                secret_key=SAP_CONFIG_KEY_VAULT_KEY
                % (
                    sap_configuration_map.sap_environment,
                    sap_configuration_map.sap_sid,
                ),
                secret_value=json.dumps(asdict(sap_configuration_map)),
            )
            return {"status": "success", "message": "SAP connection validated"}
        except Exception as e:
            self.logger.error(
                f"[{self.log_tag}] Error occurred while validating SAP connection: {e}"
            )
            return {"status": "error", "message": str(e)}

    def fetch_print_items_from_sap(self):
        """Get the print items from each SAP system.
        Create a json message for each print item.
        Move these messages to storage queue.
        """
        print_messages = []
        try:
            self._get_sap_config()
            self.logger.info(f"[{self.log_tag}] Fetched sap config from key vault")
            for sap_system in self.sap_systems:
                sap_client = SAPPrintClient(sap_system)
                if sap_system.sap_print_queues is not None:
                    for queue in sap_system.sap_print_queues:
                        print_items_from_queue = []

                        response = sap_client.get_print_items_from_queue(
                            queue_name=queue.queue_name
                        )
                        (
                            print_items_from_queue.extend(response)
                            if response is not None
                            else []
                        )

                        self.logger.info(
                            f"[{self.log_tag}] Fetched {len(print_items_from_queue)} items from the "
                            + f" SAP queue for {sap_system.sap_sid}"
                        )
                        for print_item in print_items_from_queue:
                            queue_item_params = json.loads(print_item["QItemParams"])
                            for document in json.loads(print_item["Documents"]):
                                print_messages.append(
                                    {
                                        "sap_sid": sap_system.sap_sid,
                                        "sap_environment": sap_system.sap_environment,
                                        "sap_print_queue_name": queue.queue_name,
                                        "print_item": {
                                            "document_blob": document["blob"],
                                            "document_name": document["document_name"],
                                            "document_file_size": document["filesize"],
                                            "printer_share_id": queue.print_share_id,
                                            "queue_item_id": print_item["QItemId"],
                                            "document_content_type": DOCUMENT_CONTENT_TYPE,
                                            "print_job_copies": queue_item_params[
                                                "print_job"
                                            ]["copies"],
                                        },
                                    }
                                )
            # send the print messages to the storage queue
            if print_messages:
                self._send_message_to_storage_queue(print_messages=print_messages)
                self._update_print_messages_status(
                    print_messages=print_messages, status=PrintItemStatus.NEW
                )

        except Exception as e:
            self.logger.error(
                f"[{self.log_tag}] Error occurred while fetching SAP config from the Key Vault: {e}"
            )
            return {"status": "error", "message": "Error occurred while fetching items"}

    def send_print_items_to_universal_print(self):
        """Get the print items from storage account queue.
        Temporary work around:
        Since the authorization using SPN is not available for the universal print,
        """
        messages = []
        try:
            messages = [
                ast.literal_eval(message.content)
                for message in StorageQueueClient().receive_messages()
            ]
            self.logger.info(
                f"[{self.log_tag}] Fetched items {len(messages)} from the storage account"
            )
            for message in messages:
                response = UniversalPrintUsingLogicApp.call_logic_app(
                    message["print_item"]
                )
                return response
        except json.JSONDecodeError as e:
            self.logger.error(
                f"[{self.log_tag}] Error occurred decoding fetched items: {e}"
            )
            return {
                "status": "error",
                "message": "Error occurred decoding fetched items",
            }
        except Exception as e:
            self._update_print_messages_status(
                print_messages=messages,
                status=PrintItemStatus.ERROR.value,
                error_message=str(e),
            )
            self.logger.error(
                f"[{self.log_tag}] Error occurred while sending print jobs  to the storage account: {e}"
            )
            return {"status": "error", "message": "Error occurred while fetching items"}

    def upload_document_to_universal_print(self, request_body):
        """Upload the document to the Universal Print using universal print client.

        Args:
            request_body (request): request body

        Returns:
            response object: response
        """
        try:
            return UniversalPrintClient().upload_document(request_body)
        except Exception as e:
            self.logger.error(
                f"[{self.log_tag}] Error occurred while uploading document to the universal print server: {e}"
            )
            return {"status": "error", "message": "Error occurred while fetching items"}
