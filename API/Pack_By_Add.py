import requests
from Token_SSCC_Permit_Num import data

url= {}
def select_env(env, username):
    if env == 'test':
        url.update({
            'url_to_pack_by_add' : 'https://wes-api.test.originsysglobal.com/item/getdetails?culture=en',
            'url_to_submit_pack_by_add' : 'https://wes-api.test.originsysglobal.com/site/'+username[:13]+'/aggregateByAdd?culture=en'
        })
    elif env == 'stage':
        url.update({
            'url_to_pack_by_add': 'https://stg.identity.aws.originsysglobal.com/item/getdetails?culture=en',
            'url_to_submit_pack_by_add': 'https://stg.identity.aws.originsysglobal.com/site/'+username[:13]+'/aggregateByAdd?culture=en'
        })

sscc_scan = []
def pack_by_add_to_scan(env, username, sscc_to_scan):
    select_env(env, username)
    sscc_scan.append(sscc_to_scan)
    payload = {
        "tenantId": username[:13],
        "itemCode": sscc_to_scan
    }
    headers = {
        'Content-Type': 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.post(url['url_to_pack_by_add'], json=payload, headers=headers)
    return response.json()['message']

def submit_pack_by_add():
    payload = {
        "containerSSCC": sscc_scan[0],
        "addedItemBarCodes": sscc_scan[1:]
    }
    headers = {
        'Content-Type': 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.post(url['url_to_submit_pack_by_add'], json=payload, headers=headers)
    return response.json()['data'][0]['barCode']

#get_token_from_login('test', '6251151000003_admin', 'adminP@ssw0rd')
#pack_by_add_to_scan('test', '6251151000003', '00062511519513568789')
#pack_by_add_to_scan('test', '6251151000003', '00062511511313216471')
#pack_by_add_to_scan('test', '6251151000003', '00062511511723509996')
#print(sscc_scan)
#print(submit_pack_by_add())












