import requests
from Token_SSCC_Permit_Num import data#, get_token_from_login, data_SGTIN
#from Generate_Json_File import get_payload_to_add_file

url= {}
def select_url(env, supplier, serial):
    if env == 'test':
        url.update({
            'url_scan_parent_blind_receive' : 'https://wes-api.test.originsysglobal.com/api/v1/inbound/blind-receive/'+supplier[:13]+'/aggregate/scan-parent/'+serial+'?culture=en',
            'url_scan_child_blind_receive' : 'https://wes-api.test.originsysglobal.com/api/v1/inbound/blind-receive/'+supplier[:13]+'/aggregate/scan-child/'+serial+'?culture=en'
        })
    elif env == 'stage':
        url.update({
            'url_scan_parent_blind_receive' : 'https://stg.identity.aws.originsysglobal.com/api/v1/inbound/blind-receive/'+supplier[:13]+'/aggregate/scan-parent/'+serial+'?culture=en',
            'url_scan_child_blind_receive' : 'https://atp.staging.api.aws.originsysglobal.com/api/v1/inbound/blind-receive/'+supplier[:13]+'/aggregate/scan-child/'+serial+'?culture=en'
        })
    #return url

def scan_parent_blind_receive(env, supplier, parent):
    select_url(env, supplier, parent)
    payload = {}
    headers = {
        'Authorization': data['token from login'],
        'Content-Type' : 'application/json'
    }
    response = requests.put(url['url_scan_parent_blind_receive'], json=payload, headers=headers)
    return response.json()['message']
def scan_child_blind_receive(env, supplier, child):
    select_url(env, supplier, child)
    payload = {}
    headers = {
        'Authorization': data['token from login'],
        'Content-Type' : 'application/json'
    }
    response = requests.post(url['url_scan_child_blind_receive'], json=payload, headers=headers)
    return response.json()['message']

#get_token_from_login('test','6251151000003_admin','adminP@ssw0rd')
#get_payload_to_add_file('test','6251151000003_admin','adminP@ssw0rd')
#print(data_SGTIN)
#print(scan_parent_blind_receive('test','6285125000027',data['parent1_to_scan']))
#print(scan_child_blind_receive('test','6285125000027',data_SGTIN['SGTIN1']))
