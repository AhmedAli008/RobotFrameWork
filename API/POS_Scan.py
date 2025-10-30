import requests
from Token_SSCC_Permit_Num import data, data_SSCC
#from Add_Shipment_File_From_CT import add_shipment_file_fetch_file_name

url= {}
def select_env(env, parent):

    if env == 'test':
        url.update({
            'url_to_POS' : 'https://wes-api.test.originsysglobal.com/api/v1/dispense/scan/'+parent+'?culture=en'
        })
    elif env == 'stage':
        url.update({
            'url_to_POS' : 'https://stg.identity.aws.originsysglobal.com/api/v1/dispense/scan/'+parent+'?culture=en'
        })
    #return url

def scan_POS(env, parent):
    select_env(env, parent)
    headers = {
        'Content-Type' : 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.post(url['url_to_POS'], headers=headers, timeout=30)
    return response.json()['message']

#print(add_shipment_file_fetch_file_name('test', '6251151000003_admin', 'adminP@ssw0rd', 2, 3))
#print(data_SSCC)
#print(scan_POS('test','00162511511254789932'))