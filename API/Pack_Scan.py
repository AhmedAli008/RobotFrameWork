import requests
from Token_SSCC_Permit_Num import data

url= {}
def select_env(env, parent):

    if env == 'test':
        url.update({
            'url_to_pack_by_aggregation' : 'https://wes-api.test.originsysglobal.com/api/v1/pack-by-aggregation/scan/'+parent+'?culture=en',
            'url_submit_pack_by_aggregation' : 'https://wes-api.test.originsysglobal.com/api/v1/pack-by-aggregation/submit?culture=en'
        })
    elif env == 'stage':
        url.update({
            'url_to_pack_by_aggregation' : 'https://stg.identity.aws.originsysglobal.com/api/v1/pack-by-aggregation/scan/'+parent+'?culture=en',
            'url_submit_pack_by_aggregation': 'https://stg.identity.aws.originsysglobal.com/api/v1/pack-by-aggregation/submit?culture=en'
        })
    #return url

def pack_by_aggregation_to_scan(env, parent):
    select_env(env, parent)
    headers = {
        'Content-Type' : 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.post(url['url_to_pack_by_aggregation'], headers=headers)
    return response.json()['message']

def submit_pack_by_aggregation():
    payload = {}
    headers = {
        'Content-Type': 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.post(url['url_submit_pack_by_aggregation'], json=payload, headers=headers)
    return response.json()['data'][0]['barCode']



#add_shipment_file_fetch_file_name('test', '6251151000003_admin', 'adminP@ssw0rd')
#print(pack_by_aggregation_to_scan('test',data['parent1_to_scan']))
#sscc_agg = scan_to_verify_status('test', '00062511511461201794','6251151000003')
#print(sscc_agg)
#print(verify_sscc_after_aggregation('6251151000003','00'+sscc_agg))
#get_token_from_login('test', '6251151000003_admin', 'adminP@ssw0rd')
#print(submit_pack_by_aggregation())


