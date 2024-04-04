# python script.py <api_username> <api_password> <FMC_IP>

import argparse
import requests
import json
from datetime import datetime
import openpyxl
import sys
import os
import pandas as pd

def file_name():
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    filename = f"TID_output_{timestamp}.xlsx"
    return filename

def get_token(fmcIP, path, username, password):
    from requests.packages.urllib3.exceptions import InsecureRequestWarning
    requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

    try:
        r = requests.post(f"https://{fmcIP}/{path}", auth=(f"{username}", f"{password}"), verify=False)
    except requests.exceptions.HTTPError as errh:
        raise SystemExit(errh)
    except requests.exceptions.RequestException as err:
        raise SystemExit(err)

    required_headers = ('X-auth-access-token', 'X-auth-refresh-token', 'DOMAIN_UUID')
    result = {key: r.headers.get(key) for key in required_headers}
    return result

def toepoch(input_datetime):
    new_dt = input_datetime.replace('-',',')
    integers = [int(i) for i in new_dt.split(',')]
    epoch = datetime(integers[0],integers[1],integers[2],integers[3],integers[4]).timestamp()
    return (int(epoch))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("username", type=str, help ="API username")
    parser.add_argument("password", type=str, help="password of API user")
    parser.add_argument("ip_address", type=str, help="IP of FMC")
    args = parser.parse_args()

    u = args.username
    p = args.password
    ip = args.ip_address
    path = "/api/fmc_platform/v1/auth/generatetoken"

    header = get_token(ip, path, u, p)

    print('Enter from and to date & time in YYYY-MM-DD-HH-MM format(local system timezone 24hr format)')
    from_dt = input('Enter from Date-Time : ')
    to_dt = input('Enter to Date-Time : ')
    
    ep_from_dt = toepoch(from_dt)
    ep_to_dt = toepoch(to_dt)

    path = f"/api/fmc_tid/v1/domain/{header['DOMAIN_UUID']}/tid/incident?filter=updatedAt:{ep_from_dt}..{ep_to_dt}&sort=-updatedAt&limit=40&expanded=true"
    
    try:
        r = requests.get(f"https://{ip}/{path}", headers=header, verify=False)
    except requests.exceptions.HTTPError as errh:
        raise SystemExit(errh)
    except requests.exceptions.RequestException as err:
        raise SystemExit(err)
    
    
    response = r.json()
    data = response.get("items",[])
    
    df = pd.DataFrame(columns=['sourceName','updatedAt','actionTaken','destIpAddress','destPort','protocol','srcIpAddress','srcPort','value','elementName','indicatorName','id_name'])
    
    for i,y in enumerate(data):
        sourceName = data[i]["sourceName"]
        updatedAt = data[i]["updatedAt"]
        actionTaken = data[i]["actionTaken"]
        destIpAddress = data[i]["observations"][0].get("data",{}).get("miscData",{}).get("destIpAddress","")
        destPort = data[i]["observations"][0].get("data",{}).get("miscData",{}).get("destPort","")
        protocol = data[i]["observations"][0].get("data",{}).get("miscData",{}).get("protocol","")
        srcIpAddress = data[i]["observations"][0].get("data",{}).get("miscData",{}).get("srcIpAddress","")
        srcPort = data[i]["observations"][0].get("data",{}).get("miscData",{}).get("srcPort","")
        value = data[i]["observations"][0].get("data",{}).get("value","")
        elementName = data[i]["observations"][0].get("elementName","")
        indicatorName = data[i]["indicatorName"]
        id_name = data[i]["id"]
                         
        datetime_obj=datetime.fromtimestamp(updatedAt)
        datetime_string=datetime_obj.strftime("%d-%m-%Y %H:%M:%S")                 
        
        data1 = {
        "sourceName": [sourceName],
        "updatedAt": [datetime_string],
        "actionTaken": [actionTaken],
        "destIpAddress": [destIpAddress],
        "destPort" : [destPort],
        "protocol":[protocol],
        "srcIpAddress":[srcIpAddress],
        "srcPort" :[srcPort],
        "value": [value],
        "elementName":[elementName],
        "indicatorName":[indicatorName],
        "id_name":[id_name]
        }
        
        df = df._append(data1,ignore_index=True)    
        
# Write DataFrame to Excel file
outfile = file_name()
df.to_excel(outfile, index=False)
print('Output filename : ',outfile)