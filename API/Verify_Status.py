import requests
from Token_SSCC_Permit_Num import data
#from Add_Shipment_File_From_CT import add_shipment_file_fetch_file_name

url= {}
def select_env(env, parent, username):
    if env == 'test':
        url.update({
            'url_to_verify_status' : 'https://wes-api.test.originsysglobal.com/Site/'+username[:13]+'/Item/'+parent+'/Status?culture=en'
        })
    elif env == 'stage':
        url.update({
            'url_to_verify_status' : 'https://stg.identity.aws.originsysglobal.com/Site/'+username[:13]+'/Item/'+parent+'/Status?culture=en'
        })
    #return url

def scan_to_verify_status(env, parent, username):
    select_env(env, parent, username)
    headers = {
        'Content-Type' : 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.get(url['url_to_verify_status'], headers=headers)
    data_of_verify = response.json()['data'][0]['parent']
    return data_of_verify