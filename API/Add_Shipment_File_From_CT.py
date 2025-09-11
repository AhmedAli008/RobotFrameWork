import requests
from Generate_Json_File import get_payload_to_add_file
from Token_SSCC_Permit_Num import data

data_to_add_file = {}
def get_env(env):
    if env == 'test':
        data_to_add_file.update({
        'url_to_get_token_from_ct' : "https://wes-identity.test.originsysglobal.com/api/Authentication/oauth/token",
        'url_to_add_file_from_ct' : "https://wes-api.test.originsysglobal.com/ShipmentFile/Add",
        'content_type' :'application/json',
        'clientid' : "21554-545gfdf12-hjhj21-213",
        'clientSecret' : "454545sgfgfg4512121a",
        'supplier_to_add_shipment_file' : "6294018311140"
        })

    elif env == 'stage':
        data_to_add_file.update({
            'url_to_get_token_from_ct': 'https://stg.identity.aws.originsysglobal.com/api/Authentication/oauth/token',
            'url_to_add_file_from_ct': 'https://atp.staging.api.aws.originsysglobal.com/ShipmentFile/Add',
            'content_type': 'application/json',
            'clientid': "452102yty-5421dqaew450-75454hgdf3-1000253ee",
            'clientSecret': "ix4iQXhrwABn9IqlZyTH0FzgjzfjVSLE545423weds",
            'supplier_to_add_shipment_file': "6294018311140"
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

def add_shipment_file_fetch_file_name(env, username, password):
    get_env(env)
    payload = get_payload_to_add_file(env, username, password)
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


#print(add_shipment_file_fetch_file_name('test', '6297001303009_admin', '6297001303009_P@ssw0rd'))
#print(data)