import random
import string
import json
from Token_SSCC_Permit_Num import get_sscc, get_gtin_and_lot_from_permit_num, data, data_SGTIN

def generate_gs1_serial(item):
    gtin = item.get ('GTIN')
    barcode = item.get('barcode')
    expiry = item.get('expiry').replace("-", "")[2:]
    batch_number = item.get('batch_number')
    return f"01{gtin}21{barcode}17{expiry}10{batch_number}"

def get_payload_to_add_file_sgtin(env, username, password, num):
    get_gtin_and_lot_from_permit_num(env, username, password)
    def generate_random_numeric(length):
        return ''.join(random.choices(string.digits, k=length))

    barcodes = set()
    num = int(num)
    while len(barcodes) < num:  # For 200 items, change to 200
        barcode = generate_random_numeric(13)
        if len(barcode) == 13:
            barcodes.add(barcode)
    barcode_list = list(barcodes)

    json_items = []
    for index in range(num):  # For 100 items, change to range(100)
        json_items.append({
            "barcode": barcode_list[index],
            "GTIN": data['GTIN'],#data['permit_number'][0]['itemTagId'][:14],
            "batch_number": data['Lot'],#data['permit_number'][0]['itemTagId'][15:],
            "expiry": "2029-03-13",
            "manufacturing_date": "2025-03-17"
        })

    number = 1
    data_SGTIN.clear()
    for item in json_items:
        data_SGTIN[f'SGTIN{number}'] = generate_gs1_serial(item)
        number += 1

    #with open('data.json', 'w') as json_file:
        #json.dump(data_SGTIN, json_file, indent=4)

    payload = {
        "File": {
            "referenceId": "",
            "data": json_items
        },
        "OperationType": 3
    }

    return payload