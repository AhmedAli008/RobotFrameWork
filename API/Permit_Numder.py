import requests
import random
import string
from Token_SSCC_Permit_Num import data, get_token_from_login

url = {}


def select_env(env):

    if env == "test":
        url.update(
            {
                "url_to_get_permit_num": "https://wes-api.test.originsysglobal.com/PermitNumber/GetPermitNumbers?culture=en",
                "url_add_permit_number": "https://wes-api.test.originsysglobal.com/PermitNumber/AddPermitNumber?culture=en",
                "url_delete_permit_num": "https://wes-api.test.originsysglobal.com/PermitNumber/RemovePermitNumber?culture=en",
            }
        )
    elif env == "stage":
        url.update(
            {
                "url_to_get_permit_num": "https://atp.staging.api.aws.originsysglobal.com/PermitNumber/GetPermitNumbers?culture=en",
                "url_add_permit_number": "https://atp.staging.api.aws.originsysglobal.com/PermitNumber/AddPermitNumber?culture=en",
                "url_delete_permit_num": "https://atp.staging.api.aws.originsysglobal.com/PermitNumber/RemovePermitNumber?culture=en",
            }
        )


def permit_num(env, username, password):
    get_token_from_login(env, username, password)
    select_env(env)
    payload = {"tenantId": username[:13]}
    headers = {
        "Content-Type": "application/json",
        "Authorization": data["token from login"],
    }
    response = requests.post(
        url["url_to_get_permit_num"], json=payload, headers=headers
    )
    data_permit = response.json()["data"]
    result = [
        item for item in data_permit if item["permitNumber"] == "shp/MP/48913/2020"
    ]
    if result:
        permitId = result[0]["permitId"]
        delete_permit_number(username, permitId)
        add_permit_num(username)
    else:
        add_permit_num(username)


def rondom_value():
    value = "".join(random.choices(string.ascii_letters + string.digits, k=5))
    return value


def add_permit_num(username):
    user = username[:13]
    if user == '6251151000003':
        gtin1 = "06251151000157"
        gtin2 = "06251151000201"
    elif user == '6297001303009':
        gtin1 = "08430469004189"
        gtin2 = "08430469000075"

    payload = {
        "tenantId": username[:13],
        "PermitNumber": "shp/MP/48913/2020",
        "PermitNumberLines": [
            {"gtin": gtin1, "lot": rondom_value(), "quantity": "100"},
            {"gtin": gtin2, "lot": rondom_value(), "quantity": "100"},
        ],
    }
    headers = {
        "Content-Type": "application/json",
        "Authorization": data["token from login"],
    }
    response = requests.post(
        url["url_add_permit_number"], json=payload, headers=headers
    )
    result = response.json()["message"]
    return result


def delete_permit_number(username, id):
    payload = {
        "tenantId": username[:13],
        "permitNumber": "shp/MP/48913/2020",
        "permitId": id,
    }
    headers = {
        "Content-Type": "application/json",
        "Authorization": data["token from login"],
    }
    response = requests.post(
        url["url_delete_permit_num"], json=payload, headers=headers
    )
    result = response.json()["message"]
    return result


print(permit_num("test", "6251151000003_admin", "adminP@ssw0rd"))
