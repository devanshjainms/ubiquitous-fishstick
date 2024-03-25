"""Unit tests for the backend_print module.
"""

import os
import unittest
from unittest.mock import patch, MagicMock
from helper.backend_print import BackendPrint


class TestBackendPrint(unittest.TestCase):
    def setUp(self):
        self.backend_print = BackendPrint(logger=MagicMock(), log_tag="Test")
        os.environ["MSI_CLIENT_ID"] = "client_id"
        os.environ["STORAGE_ACCESS_KEY"] = "key"
        os.environ["STORAGE_QUEUE_NAME"] = "queuename"

    @patch("helper.sap_client.SAPPrintClient.get_print_queues")
    @patch("helper.sap_client.SAPPrintClient.find_print_queue")
    @patch("helper.key_vault.AzureClient.__init__")
    @patch("helper.key_vault.KeyVault.set_kv_secrets")
    def test_validation_engine(
        self,
        mock_key_vault_client,
        mock_azure_client,
        mock_find_print_queue,
        mock_get_print_queues,
    ):
        mock_azure_client.return_value = None
        mock_find_print_queue.return_value = True
        mock_get_print_queues.return_value = ["queue1", "queue2"]
        mock_key_vault_client.return_value = True
        response = self.backend_print.validation_engine(
            {
                "sap_sid": "sid",
                "sap_user": "user",
                "sap_password": "password",
                "sap_hostname": "localhost",
                "sap_environment": "environment",
                "sap_print_queues": [
                    {"queue_name": "queue1", "print_share_id": "printer1"},
                    {"queue_name": "queue2", "print_share_id": "printer2"},
                ],
            }
        )
        self.assertEqual(
            response,
            {"status": "success", "message": "SAP connection validated"},
        )
