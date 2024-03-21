"""Http trigger that uploads a document to microsoft universal print
"""

import logging
import azure.functions as func
from helper.backend_print import BackendPrint


def main(req: func.HttpRequest) -> func.HttpResponse:
    """HTTP trigger that uploads a document to microsoft universal print

    Args:
        req (func.HttpRequest): Request object from the Logic App

    Returns:
        func.HttpResponse: Response object sent back to the logic app
    """
    logging.info("Python HTTP trigger function processed a request.")

    BackendPrint(
        logger=logging, log_tag="UploadDocumentToUP"
    ).upload_document_to_universal_print(
        request_body=req.get_json()
    )
