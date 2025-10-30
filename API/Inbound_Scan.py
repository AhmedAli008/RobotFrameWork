import requests
from Token_SSCC_Permit_Num import data
#from Add_Shipment_File_From_CT import add_shipment_file_fetch_file_name

url = {
    'content_type' :'application/json'
    }
def select_env_adhoc(env):
    if env == 'test':
        url.update({
            'url_inbound_adhoc' : "https://wes-api.test.originsysglobal.com/api/AdHocInbound/Scan?culture=en"
        })
    elif env == 'stage':
        url.update({
            'url_inbound_adhoc': 'https://stg.identity.aws.originsysglobal.com/api/AdHocInbound/Scan?culture=en'
        })
    return url
def select_env_order(env,username,parent,doc_num):
    if env == 'test':
        url.update({
            'url_inbound_order' : 'https://wes-api.test.originsysglobal.com/api/v1/inbound/orders/'+username[:13]+'-1-'+doc_num+'/scan/'+parent+'?culture=en'
        })
    elif env == 'stage':
        url.update({
            'url_inbound_order': 'https://stg.identity.aws.originsysglobal.com/api/v1/inbound/orders/'+username[:13]+'-1-'+doc_num+'/scan/'+parent+'?culture=en'
        })
    return url

def inbound_adhoc_scan(env,supplier,parent):
    select_env_adhoc(env)
    payload = {
        'SupplierId' : supplier,
        'itemCodes' : [
            parent
        ]
    }
    headers = {
        'Content-Type' : url['content_type'],
        'Authorization' : data['token from login']
    }
    response = requests.post(url['url_inbound_adhoc'], json=payload, headers=headers, timeout=30)
    return response.json()['message']

def inbound_order_scan(env,username,parent,doc_num):
    select_env_order(env,username,parent,doc_num)
    
    headers = {
        'Content-Type' : url['content_type'],
        'Authorization' : data['token from login']
    }
    response = requests.post(url['url_inbound_order'],  headers=headers)
    return response.json()['message']

#add_shipment_file_fetch_file_name('test', '6251151000003_admin', 'adminP@ssw0rd')
#print(data)
#print(inbound_order_scan('test','6251151000003_admin',data['parent1_to_scan'],'JzaOAl7w'))
