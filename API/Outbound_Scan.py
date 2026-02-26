import requests
from Token_SSCC_Permit_Num import data

outbound_supplier = '6294018311140'
url= {}
def select_env(env):
    if env == 'test':
        url.update({
            'url_outbound_adhoc': "https://wes-api.test.originsysglobal.com/api/adhocoutbound/scan?culture=en",
            'url_outbound_order': "https://wes-api.test.originsysglobal.com/Outbound/scan?culture=en",
            'content_type': 'application/json'
        })
    elif env == 'stage':
        url.update({
            'url_outbound_adhoc': 'https://atp.staging.api.aws.originsysglobal.com/api/adhocoutbound/scan?culture=en',
            'url_outbound_order': 'https://atp.staging.api.aws.originsysglobal.com/Outbound/scan?culture=en',
            'content_type': 'application/json'
        })
def safe_get_message(response):
    """Safely extract message from API response"""
    try:
        result = response.json()
        if 'message' in result:
            return result['message']
        elif 'error' in result:
            return f"Error: {result['error']}"
        else:
            return f"Response: {response.status_code}"
    except Exception as e:
        return f"Exception: {str(e)}"

def outbound_adhoc_scan(env, parent):
    select_env(env)
    payload = {
        'buyerId' : outbound_supplier,
        'itemCodes' : [
            parent
        ]
    }
    headers = {
        'Content-Type' : url['content_type'],
        'Authorization' : data['token from login']
    }
    response = requests.post(url['url_outbound_adhoc'], json=payload, headers=headers)
    return safe_get_message(response)

def outbound_order_scan(env, parent, doc_num):
    select_env(env)
    payload = {
        'documentType': '1',
        'documentNumber': doc_num,
        'itemCodes' : [
            parent
        ]
    }
    headers = {
        'Content-Type' : url['content_type'],
        'Authorization' : data['token from login']
    }
    response = requests.post(url['url_outbound_order'], json=payload, headers=headers)
    return safe_get_message(response)