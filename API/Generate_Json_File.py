import random
import string
from Token_SSCC_Permit_Num import get_sscc, get_gtin_and_lot_from_permit_num, data, data_SGTIN


def generate_gs1_serial(item):
    gtin = item.get ('GTIN')
    barcode = item.get('barcode')
    expiry = item.get('expiry').replace("-", "")[2:]
    batch_number = item.get('batch_number')
    return f"01{gtin}21{barcode}17{expiry}10{batch_number}"

def get_payload_to_add_file(env, username, password):
    get_gtin_and_lot_from_permit_num(env, username, password)
    def generate_random_numeric(length):
        return ''.join(random.choices(string.digits, k=length))

    parent1_1 = get_sscc(env, username, password)
    parent1_2 = get_sscc(env, username, password)
    parent1_3 = get_sscc(env, username, password)
    data['parent1_to_scan']=parent1_1
    data['parent2_to_scan']=parent1_2
    data['parent3_to_scan']=parent1_3
    barcodes = set()
    while len(barcodes) < 6:  # For 200 items, change to 200
        barcode = generate_random_numeric(13)
        if len(barcode) == 13:
            barcodes.add(barcode)
    barcode_list = list(barcodes)

    json_items = []
    for index in range(2):  # For 100 items, change to range(100)
        json_items.append({
            "barcode": barcode_list[index],
            "parent1": parent1_1[2:],
            "GTIN": data['permit_number'][0]['itemTagId'][:14],
            "batch_number": data['permit_number'][0]['itemTagId'][15:],
            "expiry": "2026-03-13",
            "manufacturing_date": "2025-03-17"
        })
        #data['child'+str(index)+'tos_can']= '01'+str(json_items['GTIN'])+'21'+json_items['barcode']+'17'+json_items["expiry"]+'10'json_items["batch_number"]

    for index in range(2, 4):  # For the next 100 items, change to range(100, 200)
        json_items.append({
            "barcode": barcode_list[index],
            "parent1": parent1_2[2:],
            "GTIN": data['permit_number'][0]['itemTagId'][:14],
            "batch_number": data['permit_number'][0]['itemTagId'][15:],
            "expiry": "2026-03-13",
            "manufacturing_date": "2025-03-17"
        })
        #data['child'+str(index)+'tos_can']= f'01{json_items['GTIN']}21{json_items['barcode']}17{json_items["expiry"]}10{json_items["batch_number"]}'
    for index in range(4, 6):  # For the next 100 items, change to range(100, 200)
        json_items.append({
            "barcode": barcode_list[index],
            "parent1": parent1_3[2:],
            "GTIN": data['permit_number'][0]['itemTagId'][:14],
            "batch_number": data['permit_number'][0]['itemTagId'][15:],
            "expiry": "2026-03-13",
            "manufacturing_date": "2025-03-17"
        })

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


#get_payload_to_add_file('test','6251151000003_admin','adminP@ssw0rd')
#print(data)