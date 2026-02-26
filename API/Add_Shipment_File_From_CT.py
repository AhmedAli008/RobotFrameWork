import requests
from Generate_Json_File import get_payload_to_add_file, get_payload_to_add_mixed_file
from Generate_Json_sGTIN import get_payload_to_add_file_sgtin
from Token_SSCC_Permit_Num import data

data_to_add_file = {}
def get_env(env):
    if env == 'test':
        data_to_add_file.update({
        'url_to_get_token_from_ct' : "https://wes-identity.test.originsysglobal.com/api/Authentication/oauth/token",
        'url_to_add_file_from_ct' : "https://wes-api.test.originsysglobal.com/ShipmentFile/Add",
        'content_type' :'application/json',
        'clientid' : "eed783ef-c458-4187-bfab-7635757c5e7d",
        'clientSecret' : "wes_whleOoVXVTAdfY0TRma2hD6XqfIrsqH6",
        'supplier_to_add_shipment_file' : "0000000000001"
        })

    elif env == 'stage':
        data_to_add_file.update({
            'url_to_get_token_from_ct': 'https://stg.identity.aws.originsysglobal.com/api/Authentication/oauth/token',
            'url_to_add_file_from_ct': 'https://atp.staging.api.aws.originsysglobal.com/ShipmentFile/Add',
            'content_type': 'application/json',
            'clientid': "2e84a065-14bd-4387-8b43-4fc24faab5a2",
            'clientSecret': "wes_Byl0X5o7tspEIsOPXdaS1aWnFqqlWPoa",
            'supplier_to_add_shipment_file': "6285125000027"
        })

def get_token_from_ct(env):
    payload = {
        'clientId' : data_to_add_file['clientid'],
        'clientSecret' : data_to_add_file['clientSecret'],
    }
    headers = {
        'Content-Type' : data_to_add_file['content_type']
    }
    response = requests.post(data_to_add_file['url_to_get_token_from_ct'], json=payload, headers=headers)
    token = "Bearer "+response.json()['data']['token']
    return token

def add_shipment_file_fetch_file_name(env, username, password, sscc_num, sgtin_num):
    get_env(env)
    payload = get_payload_to_add_file(env, username, password, sscc_num, sgtin_num)
    headers = {
        'Content-Type' : data_to_add_file['content_type'],
        'Authorization' : get_token_from_ct(env),
        'tenantid' : username[:13],
        'Supplier' : data_to_add_file['supplier_to_add_shipment_file']
    }
    data['supplier_to_add_shipment_file'] = data_to_add_file['supplier_to_add_shipment_file']
    response = requests.post(data_to_add_file['url_to_add_file_from_ct'], json=payload, headers=headers)
    #x = {'name':response.json()['data'][0]['name'],'data': payload}
    return response.json()['data'][0]['name']

def add_mixed_shipment_file_fetch_file_name(env, username, password, sscc_num, sgtin_num):
    get_env(env)
    payload = get_payload_to_add_mixed_file(env, username, password, sscc_num, sgtin_num)
    headers = {
        'Content-Type' : data_to_add_file['content_type'],
        'Authorization' : get_token_from_ct(env),
        'tenantid' : username[:13],
        'Supplier' : data_to_add_file['supplier_to_add_shipment_file']
    }
    data['supplier_to_add_shipment_file'] = data_to_add_file['supplier_to_add_shipment_file']
    response = requests.post(data_to_add_file['url_to_add_file_from_ct'], json=payload, headers=headers)
    #x = {'name':response.json()['data'][0]['name'],'data': payload}
    return response.json()['data'][0]['name']

def add_shipment_file_sgtin_fetch_file_name(env, username, password, num):
    get_env(env)
    payload = get_payload_to_add_file_sgtin(env, username, password, num)
    headers = {
        'Content-Type' : data_to_add_file['content_type'],
        'Authorization' : get_token_from_ct(env),
        'tenantid' : username[:13],
        'Supplier' : data_to_add_file['supplier_to_add_shipment_file']
    }
    data['supplier_to_add_shipment_file'] = data_to_add_file['supplier_to_add_shipment_file']
    response = requests.post(data_to_add_file['url_to_add_file_from_ct'], json=payload, headers=headers)
    #x = {'name':response.json()['data'][0]['name'],'data': payload}
    return response.json()['data'][0]['name']


#print(add_shipment_file_fetch_file_name('test', '6251151000003_admin', 'adminP@ssw0rd', 2, 3))
#print(data)