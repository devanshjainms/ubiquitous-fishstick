"""Azure Universal Print.
"""

import requests
import os


class UniversalPrintClient:
    def __init__(self) -> None:
        pass

    def upload_document(self, request_body: dict):
        """Upload the document to the Universal Print.

        Args:
            file_path (str): file path

        Returns:
            dict: response
        """
        try:
            range = request_body["next_expected_range"].split("-")
            headers = {
                "Content-Type": "application/json",
                "Content-Range": f"bytes {range[0]}-{range[1] - 1}/{range[1]}",
                "Content-Length": str(len(request_body["document_file_size"])),
            }
            response = requests.post(
                url=request_body["upload_url"],
                headers=headers,
                data=request_body["document_blob"],
            )
            if response.status_code != 200:
                raise Exception(
                    f"Error occurred while calling logic app: {response.text}"
                )
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
