"""Storage client to interact with the Azure Storage Account."""

from azure.storage.queue import QueueMessage
from helper.azure import AzureClient
from helper.constants import MAX_ITEMS_TO_FETCH


class StorageQueueClient(AzureClient):
    def send_message(self, message):
        """Send a message to the queue

        Args:
            message (string): message to send
        """
        try:
            return self.storage_queue_client.send_message(content=message)
        except Exception as e:
            raise Exception(f"Error occurred while sending message: {e}")

    def receive_messages(self) -> list[QueueMessage]:
        """Receive messages from the queue

        Returns:
            list[QueueMessage]: list of messages
        """
        try:
            return self.storage_queue_client.receive_messages(
                max_messages=MAX_ITEMS_TO_FETCH
            )
        except Exception as e:
            raise Exception(f"Error occurred while receiving messages: {e}")


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
