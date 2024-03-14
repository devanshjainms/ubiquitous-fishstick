"""time trigger function to fetch print items from the
storge account queue and send them to the universal print
"""

import logging
import azure.functions as func
from helper.backend_print import BackendPrint


def main(mytimer: func.TimerRequest, context: func.Context) -> None:
    BackendPrint().send_print_items_to_universal_print()
