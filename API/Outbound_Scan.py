import requests
from Token_SSCC_Permit_Num import data

outbound_adhoc_supplier = '6285125000027'
url= {}
def select_env(env):
    if env == 'test':
        url.update({
            'url_outbound_adhoc': "https://wes-api.test.originsysglobal.com/api/adhocoutbound/scan?culture=en",
            'content_type': 'application/json'
        })
    elif env == 'stage':
        url.update({
            'url_outbound_adhoc': 'https://stg.identity.aws.originsysglobal.com/api/adhocoutbound/scan?culture=en',
            'content_type': 'application/json'
        })
def outbound_adhoc_scan(env, parent):
    select_env(env)
    payload = {
        'buyerId' : outbound_adhoc_supplier,
        'itemCodes' : [
            parent
        ]
    }
    headers = {
        'Content-Type' : url['content_type'],
        'Authorization' : data['token from login']
    }
    response = requests.post(url['url_outbound_adhoc'], json=payload, headers=headers)
    return response.json()['message']