"""Storage client to interact with the Azure Storage Account."""

import ast
from azure.storage.queue import QueueMessage
from helper.azure_client import AzureClient
from helper.constants import MAX_ITEMS_TO_FETCH, MESSAGE_EXPIRY_TIME


class StorageQueueClient(AzureClient):
    def send_message(self, message):
        """Send a message to the queue

        Args:
            message (string): message to send
        """
        try:
            return self.storage_queue_client.send_message(
                content=message, time_to_live=MESSAGE_EXPIRY_TIME
            )
        except Exception as e:
            raise Exception(f"Error occurred while sending message: {e}")

    def receive_messages(self) -> list[QueueMessage]:
        """Receive messages from the queue

        Returns:
            list[QueueMessage]: list of messages
        """
        try:
            raw_messages = self.storage_queue_client.receive_messages(
                max_messages=MAX_ITEMS_TO_FETCH
            )
            return [ast.literal_eval(message.content) for message in raw_messages]
        except Exception as e:
            raise Exception(f"Error occurred while receiving messages: {e}")

    def delete_message(self, message):
        """Delete a message from the queue

        Args:
            message (QueueMessage): message to delete
        """
        try:
            return self.storage_queue_client.delete_message(message)
        except Exception as e:
            raise Exception(f"Error occurred while deleting message: {e}")


class TableStorageClient(AzureClient):
    def put_entity(self, table_name, entity):
        """Put an entity to the table

        Args:
            table_name (string): table name
            entity (dict): entity to put
        """
        try:
            return self.table_service_client.upsert_entity(entity=entity)
        except Exception as e:
            raise Exception(f"Error occurred while putting entity: {e}")
