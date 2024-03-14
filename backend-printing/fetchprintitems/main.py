"""time trigger function to fetch print items from the SAP system and put them in the storage account queue
"""

import logging
import azure.functions as func
from helper.backend_print import BackendPrint

def main(mytimer: func.TimerRequest, context: func.Context) -> None:
    BackendPrint().fetch_print_items_from_sap()

