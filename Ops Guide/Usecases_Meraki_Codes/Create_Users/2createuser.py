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

create_list = {}
copy_nw_id = ''

y = requests.request("GET", url, headers=headers)
z = y.json()
i = 0

for r in input_list:
    for out in z:    
        if r[0] == out['name']:
            org_id = out['id']
    create_list[i] = [org_id,r[0],r[1],r[2],r[3]]
    i = i+1

for key,value in create_list.items():
    url2 = base_url+'/organizations/'+value[0]+'/admins'
    payload1 = json.dumps({'name': value[2],'email': value[3],'orgAccess': value[4],'tags': [],'networks': [],'authenticationMethod': 'Email'})
    response = requests.request("POST", url2, headers=headers, data=payload1)
    if response.status_code  == 201:
        print('\nCreated user '+value[2]+' under organization: '+value[1])
    else:
        print('\nError while creating user '+value[2]+' under organization: '+value[1])
        print(response.text)