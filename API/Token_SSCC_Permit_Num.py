import requests

data = {}
data_SGTIN = {}
url= {}
def select_env(env):

    if env == 'test':
        url.update({
            'url_to_login' : 'https://wes-identity.test.originsysglobal.com/api/Authentication/GetToken?culture=en',
            'url_to_get_sscc' : "https://wes-api.test.originsysglobal.com/api/v1/SerialGenerator/generate-sscc",
            'url_to_get_permit_num' : 'https://wes-api.test.originsysglobal.com/PermitNumber/GetPermitNumbers?culture=en'
        })
    elif env == 'stage':
        url.update({
            'url_to_login' : 'https://stg.identity.aws.originsysglobal.com/api/Authentication/GetToken?culture=en',
            'url_to_get_sscc' : "https://atp.staging.api.aws.originsysglobal.com/api/v1/SerialGenerator/generate-sscc",
            'url_to_get_permit_num' : 'https://atp.staging.api.aws.originsysglobal.com/PermitNumber/GetPermitNumbers?culture=en'
        })
    #return url

def get_token_from_login(env, username, password):
    select_env(env)
    payload = {
        'userName' : username,
        'password' : password
    }
    headers = {
        'Content-Type' : 'application/json'
    }
    response = requests.post(url['url_to_login'], json=payload, headers=headers)
    token = "Bearer "+response.json()['data']['token']
    data['token from login']=token
    return token

def get_sscc(env, username, password):
    #get_token_from_login(env, username, password)
    payload = {
        'count' : 1
    }
    headers = {
        'Authorization' : data['token from login'],
        'Content-Type' : 'application/json'
    }
    response = requests.post(url['url_to_get_sscc'], json=payload, headers=headers)
    return response.json()['data']['serials'][0]['code']


def get_gtin_and_lot_from_permit_num(env, username, password):
    get_token_from_login(env, username, password)
    payload = {
        'tenantId' : username[:13]
    }
    headers = {
        'Content-Type' : 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.post(url['url_to_get_permit_num'], json=payload, headers=headers)
    data_permit = response.json()['data']
    result = [item for item in data_permit if item["permitNumber"] ==  "shp/MP/48913/2020"]
    data['permit_number']=result[0]['permitNumberLines']
    return result[0]['permitNumberLines']

#print(get_gtin_and_lot_from_permit_num('test','6251151000003_admin','adminP@ssw0rd'))
#print(data)