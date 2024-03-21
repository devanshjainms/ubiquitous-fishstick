"""Azure Universal Print.
"""

import re
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
            range = [
                int(num)
                for num in re.findall(r"\d+", request_body["next_expected_range"])
            ]
            headers = {
                "Content-Type": "application/json",
                "Content-Range": f"bytes {str(range[0])}-{str(range[1])}/{str(request_body['document_file_size'])}",
                "Content-Length": str(request_body["document_file_size"]),
            }
            response = requests.put(
                url=request_body["upload_url"],
                headers=headers,
                data=request_body["document_blob"],
            )
            if response.status_code != 200:
                raise Exception(
                    f"Error occurred while uploading the document to the UP URL: {response}"
                )
            return response
        except Exception as e:
            raise Exception(
                f"Exception occurred while uploading the document to the UP URL: {e}"
            )


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
