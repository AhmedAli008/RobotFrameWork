import requests
from Token_SSCC_Permit_Num import data

url= {}
def select_env(env, username):

    if env == 'test':
        url.update({
            'url_to_decommission' : 'https://wes-api.test.originsysglobal.com/Decommission/Site/'+username[:13]+'/ScanSerialized?culture=en'
        })
    elif env == 'stage':
        url.update({
            'url_to_decommission' : 'https://stg.identity.aws.originsysglobal.com/Decommission/Site/'+username[:13]+'/ScanSerialized?culture=en'
        })
    #return url

def decommission_to_scan(env, username, parent):
    select_env(env, username)
    payload = {
        "itemCodes": [parent],
        "tenantId": username[:13]
    }
    headers = {
        'Content-Type' : 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.post(url['url_to_decommission'], json=payload, headers=headers)
    return response.json()




#add_shipment_file_fetch_file_name('test', '6251151000003_admin', 'adminP@ssw0rd')
#print(pack_by_aggregation_to_scan('test',data['parent1_to_scan']))
#sscc_agg = scan_to_verify_status('test', '00062511511461201794','6251151000003')
#print(sscc_agg)
#print(verify_sscc_after_aggregation('6251151000003','00'+sscc_agg))
#get_token_from_login('test', '6251151000003_admin', 'adminP@ssw0rd')
#print(decommission_to_scan('test','6251151000003_admin','00962511510000010425'))
#print(decommission_to_scan('test','6251151000003_admin','00962511510000010432'))
#print(decommission_to_scan('test','6251151000003_admin','00962511510000010449'))


