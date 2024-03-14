"""SAP system configuration
"""

import json
from dataclasses import dataclass, field
from marshmallow_dataclass import dataclass
import requests
from requests.auth import HTTPBasicAuth
from requests.exceptions import RequestException
from requests.adapters import HTTPAdapter
from helper.models import SAPSystem
from helper.constants import (
    BASE_URL,
    GET_PRINT_QUEUES,
    GET_N_NEXT_PRINT_ITEMS,
    GET_NEXT_PRINT_ITEM,
    GET_NUMBER_OF_PRINT_ITEMS,
)


class SAPPrintClient:
    def __init__(self, sap_system_config: SAPSystem):
        """Constructor for SAPSystem

        Args:
            sap_sid (string): SAP system ID
            sap_user (string): SAP username that has access to the ODATA service
            sap_password (string): SAP password for the user
            sap_hostname (string): URL of the ODATA service
            sap_print_queues (list(PrintQueue), optional): List of print queues. Defaults to None.
        """
        self.sap_sid = sap_system_config.sap_sid
        self.sap_user = sap_system_config.sap_user
        self.sap_password = sap_system_config.sap_password
        self.sap_hostname = sap_system_config.sap_hostname
        self.sap_print_queues = sap_system_config.sap_print_queues
        self.api_url = BASE_URL % self.sap_hostname

    def _call_sap_api(self, url):
        """Call SAP ODATA APIs

        Args:
            url (strings): URL that contains the ODATA API name

        Returns:
            response: SAP ODATA API response
        """
        try:
            session = requests.Session()
            session.mount("https://", HTTPAdapter(max_retries=3))
            response_object = requests.get(
                headers={"Accept": "application/json"},
                url=url,
                auth=HTTPBasicAuth(self.sap_user, self.sap_password),
            )
            response_object.raise_for_status()
            return json.loads(response_object.text)
        except Exception as e:
            if e.response.status_code == 400:
                return ""
            raise Exception(f"Error occurred while calling SAP API: {e}")

    def _get_number_of_print_items(self, queue_name):
        """Get the number of print items in a queue

        Args:
            queue_name (string): queue name

        Returns:
            requests.Response: Response object from the request
        """
        try:
            response = self._call_sap_api(
                f"{self.api_url}{GET_NUMBER_OF_PRINT_ITEMS}?Qname='{queue_name}'"
            )
            return response["d"]["NrOfNewItems"] if response else 0
        except Exception as e:
            if e.response.status_code == 400:
                return None
            raise Exception(f"Error occurred while getting number of print items: {e}")

    def find_print_queue(self, queue_name):
        """Find a print queue by name

        Args:
            queue_name (string): queue name

        Returns:
            PrintQueue: print queue
        """
        if self.sap_print_queues is not None:
            for print_queue in self.sap_print_queues:
                if print_queue.queue_name == queue_name:
                    return True
        return False

    def get_print_queues(self):
        """Get the print queues of the user

        Returns:
            list[str]: list of print queues
        """
        try:
            response = self._call_sap_api(f"{self.api_url}{GET_PRINT_QUEUES}")
            return [result["Qname"] for result in response["d"]["results"]]
        except Exception as e:
            raise Exception(f"Error occurred while getting print queues: {e}")

    def get_print_items_from_queue(self, queue_name):
        """Get the print items from a queue

        Args:
            queue_name (string): queue name

        Returns:
            requests.Response: Response object from the request
        """
        try:
            number_of_print_items = self._get_number_of_print_items(queue_name)
            if number_of_print_items:
                print_items = self._call_sap_api(
                    f"{self.api_url}{GET_N_NEXT_PRINT_ITEMS}?Qname='{queue_name}'&NumberOfItems={number_of_print_items}"
                )
                return print_items["d"]["results"]
        except Exception as e:
            raise Exception(f"Error occurred while getting print items: {e}")
