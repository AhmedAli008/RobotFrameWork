import requests
from Token_SSCC_Permit_Num import data
#from Add_Shipment_File_From_CT import add_shipment_file_fetch_file_name

url = {}
def select_env(env):
    if env == 'test':
        url.update({
            'url_inbound_adhoc' : "https://wes-api.test.originsysglobal.com/api/AdHocInbound/Scan?culture=en",
            'content_type' :'application/json'
        })
    elif env == 'stage':
        url.update({
            'url_inbound_adhoc': 'https://stg.identity.aws.originsysglobal.com/api/AdHocInbound/Scan?culture=en',
            'content_type': 'application/json'
        })
    return url

def inbound_adhoc_scan(env,parent):
    select_env(env)
    payload = {
        'SupplierId' : data['supplier_to_add_shipment_file'],
        'itemCodes' : [
            parent
        ]
    }
    headers = {
        'Content-Type' : url['content_type'],
        'Authorization' : data['token from login']
    }
    response = requests.post(url['url_inbound_adhoc'], json=payload, headers=headers)
    return response.json()['message']

#add_shipment_file_fetch_file_name('test', '6297001303009_admin', '6297001303009_P@ssw0rd')
#print(data)
#print(inbound_adhoc_scan('test',data['parent1_to_scan']))
