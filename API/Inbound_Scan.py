import requests
from Token_SSCC_Permit_Num import data, data_SSCC
#from Add_Shipment_File_From_CT import add_shipment_file_fetch_file_name

url = {
    'content_type' :'application/json'
    }
def select_env_adhoc(env, parent):
    if env == 'test':
        url.update({
            'url_inbound_adhoc' : "https://wes-api.test.originsysglobal.com/api/AdHocInbound/Scan?culture=en",
            "url_inbound_adhoc_without_supplier" : 'https://wes-api.test.originsysglobal.com/api/v1/AdhocNoSupplier/scan/'+parent+'?culture=en'
                                                    
        })
    elif env == 'stage':
        url.update({
            'url_inbound_adhoc': 'https://atp.staging.api.aws.originsysglobal.com/api/AdHocInbound/Scan?culture=en',
            "url_inbound_adhoc_without_supplier" : 'https://atp.staging.api.aws.originsysglobal.com/api/v1/AdhocNoSupplier/scan/'+parent+'?culture=en'
        })
    return url
def select_env_order(env,username,parent,doc_num):
    if env == 'test':
        url.update({
            'url_inbound_order' : 'https://wes-api.test.originsysglobal.com/api/v1/inbound/orders/'+username[:13]+'-1-'+doc_num+'/scan/'+parent+'?lineId=&culture=en'
        })
    elif env == 'stage':
        url.update({
            'url_inbound_order': 'https://atp.staging.api.aws.originsysglobal.com/api/v1/inbound/orders/'+username[:13]+'-1-'+doc_num+'/scan/'+parent+'?lineId=&culture=en'
        })
    return url
def select_env_order_multi_SKU(env,username,parent,doc_num,id):
    if env == 'test':
        url.update({
            'url_inbound_order_multi_SKU' : 'https://wes-api.test.originsysglobal.com/api/v1/inbound/orders/'+username[:13]+'-1-'+doc_num+'/scan/'+parent+'?lineId='+id+'&culture=en'
        })
    elif env == 'stage':
        url.update({
            'url_inbound_order_multi_SKU': 'https://atp.staging.api.aws.originsysglobal.com/api/v1/inbound/orders/'+username[:13]+'-1-'+doc_num+'/scan/'+parent+'?lineId='+id+'&culture=en'
        })
    return url
def select_env_order_to_remove(env,username,parent,doc_num):
    if env == 'test':
        url.update({
            'url_inbound_order_multi_SKU' : 'https://wes-api.test.originsysglobal.com/api/v1/inbound/orders/'+username[:13]+'-1-'+doc_num+'/remove/'+parent+'culture=en'
        })
    elif env == 'stage':
        url.update({
            'url_inbound_order_multi_SKU': 'https://atp.staging.api.aws.originsysglobal.com/api/v1/inbound/orders/'+username[:13]+'-1-'+doc_num+'/remove/'+parent+'culture=en'
        })
    return url

def inbound_adhoc_scan(env,supplier,parent):
    select_env_adhoc(env, parent)
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

def inbound_adhoc_without_supplier_scan(env,parent):
    select_env_adhoc(env, parent)
    payload = {
        "userName": None,
        "password": None
    }
    headers = {
        'Content-Type' : url['content_type'],
        'Authorization' : data['token from login']
    }
    response = requests.post(url['url_inbound_adhoc_without_supplier'], json=payload, headers=headers, timeout=30)
    return response.json()['message']

def inbound_order_scan(env,username,parent,doc_num):
    select_env_order(env,username,parent,doc_num)
    
    headers = {
        'Content-Type' : url['content_type'],
        'Authorization' : data['token from login']
    }
    response = requests.post(url['url_inbound_order'],  headers=headers)
    return response.json()

def inbound_order_scan_multi_SKU(env,username,parent,doc_num):
    result=inbound_order_scan(env,username,parent,doc_num)
    id=result['data'][0]['id']
    select_env_order_multi_SKU(env,username,parent,doc_num,str(id))
    
    headers = {
        'Content-Type' : url['content_type'],
        'Authorization' : data['token from login']
    }
    response = requests.post(url['url_inbound_order_multi_SKU'],  headers=headers)
    return response.json()['message']

def inbound_order_scan_to_remove(env,username,parent,doc_num):
    select_env_order_to_remove(env,username,parent,doc_num)
    
    headers = {
        'Content-Type' : url['content_type'],
        'Authorization' : data['token from login']
    }
    response = requests.delete(url['url_inbound_order_multi_SKU'],  headers=headers)
    return response.json()['message']

#add_shipment_file_fetch_file_name('test', '6251151000003_admin', 'adminP@ssw0rd',2,3)
#print(data_SSCC)
#print(inbound_adhoc_without_supplier_scan('test',data_SSCC['SSCC0']))
    