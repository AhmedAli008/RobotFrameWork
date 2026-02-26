import requests
from Token_SSCC_Permit_Num import data

url= {}
def select_env(env, username, parent):

    if env == 'test':
        url.update({
            'url_to_unpack_by_parent' : 'https://wes-api.test.originsysglobal.com/Item/GetHighestParentDetails?culture=en',
            'url_to_unpack_by_child' : 'https://wes-api.test.originsysglobal.com/Item/GetContainerDetails?culture=en',
            'url_submit_unpack_by_parent' : 'https://wes-api.test.originsysglobal.com/Site/'+username[:13]+'/unpack?culture=en',
            'url_submit_unpack_by_child' : 'https://wes-api.test.originsysglobal.com/Site/'+username[:13]+'/UnpackParents?culture=en',
            'parent_to_scan' : parent
        })
    elif env == 'stage':
        url.update({
            'url_to_unpack_by_parent' : 'https://atp.staging.api.aws.originsysglobal.com/Item/GetHighestParentDetails?culture=en',
            'url_to_unpack_by_child' : 'https://atp.staging.api.aws.originsysglobal.com/Item/GetContainerDetails?culture=en',
            'url_submit_unpack_by_parent': 'https://atp.staging.api.aws.originsysglobal.com/Site/'+username[:13]+'/unpack?culture=en',
            'url_submit_unpack_by_child': 'https://atp.staging.api.aws.originsysglobal.com/Site/'+username[:13]+'/UnpackParents?culture=en',
            'parent_to_scan': parent
        })
    #return url

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

def unpack_by_parent_to_scan(env, username, parent):
    select_env(env, username, parent)
    payload = {
        'tenantId' : username[:13],
        'itemCode' : url['parent_to_scan']
    }
    headers = {
        'Content-Type' : 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.post(url['url_to_unpack_by_parent'], json=payload, headers=headers)
    return safe_get_message(response)

def unpack_by_child_to_scan(env, username, parent):
    select_env(env, username, parent)
    payload = {
        'tenantId' : username[:13],
        'itemCode' : url['parent_to_scan']
    }
    headers = {
        'Content-Type' : 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.post(url['url_to_unpack_by_child'], json=payload, headers=headers)
    return safe_get_message(response)

def submit_unpack_by_parent():
    payload = {
        'parentCode' : url['parent_to_scan']
    }
    headers = {
        'Content-Type': 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.post(url['url_submit_unpack_by_parent'], json=payload, headers=headers)
    return safe_get_message(response)

def submit_unpack_by_child():
    payload = {
        'childCode' : url['parent_to_scan']
    }
    headers = {
        'Content-Type': 'application/json',
        'Authorization': data['token from login']
    }
    response = requests.post(url['url_submit_unpack_by_child'], json=payload, headers=headers)
    return safe_get_message(response)

