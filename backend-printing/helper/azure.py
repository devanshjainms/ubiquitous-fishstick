"""Azure client library to interact with the Azure services.
"""

import os
from azure.identity import ClientSecretCredential
from azure.keyvault.secrets import SecretClient
from azure.storage.queue import QueueClient
from azure.data.tables import TableServiceClient
from helper.constants import KEY_VAULT_URL


class AzureClient:
    def __init__(self):
        self._credential = ClientSecretCredential(
            client_id=os.environ["AZURE_CLIENT_ID"],
            client_secret=os.environ["AZURE_CLIENT_SECRET"],
            tenant_id=os.environ["AZURE_TENANT_ID"],
        )

        self.storage_queue_client = QueueClient.from_connection_string(
            conn_str=os.environ["STORAGE_ACCESS_KEY"],
            retry_total=3,
            queue_name=os.environ["STORAGE_QUEUE_NAME"],
            credential=self._credential,
        )

        self.key_vault_client = SecretClient(
            vault_url=KEY_VAULT_URL % os.environ["KEY_VAULT_NAME"],
            credential=self._credential,
        )

        self.table_service_client = TableServiceClient.from_connection_string(
            conn_str=os.environ["STORAGE_ACCESS_KEY"], retry_total=3
        ).get_table_client(table_name=os.environ["STORAGE_TABLE_NAME"])
