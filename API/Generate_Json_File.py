import random
import string
from Token_SSCC_Permit_Num import get_sscc, get_gtin_and_lot_from_permit_num, data, data_SGTIN, data_SSCC


def generate_gs1_serial(item):
    gtin = item.get ('GTIN')
    barcode = item.get('barcode')
    expiry = item.get('expiry').replace("-", "")[2:]
    batch_number = item.get('batch_number')
    return f"01{gtin}21{barcode}17{expiry}10{batch_number}"

def get_payload_to_add_file(env, username, password, sscc_num, sgtin_num):
    get_gtin_and_lot_from_permit_num(env, username, password)

    def generate_random_numeric(length):
        return ''.join(random.choices(string.digits, k=length))

    for index in range(sscc_num):
        data_SSCC[f'SSCC{index}'] = get_sscc(env, username, password)
        
    total_barcodes_needed = sscc_num*sgtin_num
    barcodes = set()
    while len(barcodes) < total_barcodes_needed:  # For 200 items, change to 200
        barcode = generate_random_numeric(13)
        if len(barcode) == 13:
            barcodes.add(barcode)
    barcode_list = list(barcodes)

    barcode_index = 0
    json_items = []
    for num in range(sscc_num):
        for index in range(sgtin_num):
            json_items.append({
            "barcode": barcode_list[barcode_index],
            "parent1": data_SSCC[f'SSCC{num}'][2:],
            "GTIN": data['GTIN'],#data['permit_number'][0]['itemTagId'][:14],
            "batch_number": data['Lot'],#data['permit_number'][0]['itemTagId'][15:],
            "expiry": "2026-03-13",
            "manufacturing_date": "2025-03-17"
            })
            barcode_index += 1
        

    
    num = 1
    for item in json_items:
        data_SGTIN[f'SGTIN{num}'] = generate_gs1_serial(item)
        num += 1

    payload = {
        "File": {
            "referenceId": "",
            "data": json_items
        },
        "OperationType": 3
    }

    return payload


#print(get_payload_to_add_file('test','6251151000003_admin','adminP@ssw0rd', 2, 3))
