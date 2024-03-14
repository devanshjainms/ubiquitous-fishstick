"""Azure Universal Print.
"""

import requests
import os


class UniversalPrintClient:
    def __init__(self) -> None:
        pass

    def upload_document(self, upload_url: str):
        """Upload the document to the Universal Print.

        Args:
            file_path (str): file path

        Returns:
            dict: response
        """
        try:
            headers = {
                "Content-Type": "application/json",
                "Authorization": f"Bearer {os.environ('UNIVERSAL_PRINT_TOKEN')}",
            }
            response = requests.post(url=upload_url, headers=headers)
            return response.json()
        except Exception as e:
            return {"status": "error", "message": str(e)}


class UniversalPrintUsingLogicApp:
    def __init__(self) -> None:
        pass

    def call_logic_app(print_items) -> dict:
        """Call the logic app to print the items.

        Args:
            print_item: print item json message

        Returns:
            dict: response
        """
        try:
            headers = {"Content-Type": "application/json"}
            response = requests.post(
                url=os.environ["LOGIC_APP_URL"],
                headers=headers,
                json=print_items,
            )
            return response.json()
        except Exception as e:
            raise Exception(f"Error occurred while calling logic app: {e}")
