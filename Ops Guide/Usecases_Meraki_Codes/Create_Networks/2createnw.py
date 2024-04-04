import requests
import openpyxl
import pandas as pd
import csv
import json

def read_file(filename):
    with open(filename, 'r') as file:
        return file.read().strip()

def listorg(filename):
    with open(filename, 'r') as file:
        # Read all the lines of the file into a list
        lines = file.read().splitlines()
    return lines

base_file = 'baseUrl.txt'
api_file = 'apitoken.txt'
input_file = 'input.xlsx'
  
base_url = read_file(base_file)
api_token = read_file(api_file)

url = base_url+'/organizations'

params ={}
headers = {
  'X-Cisco-Meraki-API-Key': api_token,
  'Content-Type': 'application/json'
}

#read file
read_file = pd.read_excel (input_file) 

df = pd.read_excel(input_file)
input_list = df.values.tolist()

#print(input_list[1][2])
#print(len(input_list))

create_list = {}
copy_nw_id = ''

y = requests.request("GET", url, headers=headers)
z = y.json()
i = 0

for r in input_list:
    for out in z:    
        if r[0] == out['name']:
            org_id = out['id']
            
            url1 = base_url+'/organizations/'+org_id+'/networks'
            a = requests.request("GET", url1, headers=headers)
            b = str(a.text)
            c = json.loads(b)
    
            for nw in c:
                if nw['name'] == r[4]:
                    copy_nw_id = nw['id']
                    break

    create_list[i] = [org_id,r[1],r[2],r[3],copy_nw_id,r[0]]
    i = i+1

for key,value in create_list.items():
    url2 = base_url+'/organizations/'+value[0]+'/networks'
    payload1 = json.dumps({'name': value[1],'productTypes': [value[2]],'tags': [],'timeZone': value[3],'copyFromNetworkId': value[4],'notes': None})
    response = requests.request("POST", url2, headers=headers, data=payload1)
    if response.status_code  == 201:
        print('Created network :'+value[1]+' under organization: '+value[5])
    else:
        print('Error while creating network :'+value[1]+' under organization: '+value[5])