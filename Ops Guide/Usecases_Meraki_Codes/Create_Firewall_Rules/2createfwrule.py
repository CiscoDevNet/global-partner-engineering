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

y = requests.request("GET", url, headers=headers)
z = y.json()
i = 0

for r in input_list:
    for out in z:    
        if r[0] == out['name']:
            nw_id = ''
            org_id = out['id']
            
            url1 = base_url+'/organizations/'+org_id+'/networks'
            a = requests.request("GET", url1, headers=headers)
            b = str(a.text)
            c = json.loads(b)
    
            for nw in c:
                if nw['name'] == r[1]:
                    nw_id = nw['id']
                    break
    
    create_list[i] = [r[0],org_id,r[1],nw_id,r[2],r[3],r[4],r[5],r[6],r[7],r[8],r[9]]
    i = i+1

for key,value in create_list.items():
    if value[3] != '':
        url2 = base_url+'/networks/'+value[3]+'/appliance/firewall/l3FirewallRules'
        response = requests.request("GET", url2, headers=headers)
        x = json.loads(response.text)
        m = {'policy': value[4], 'protocol': value[5], 'srcCidr': value[6], 'destCidr': value[7], 'comment': value[8], 'srcPort': value[9], 'destPort': value[10], 'syslogEnabled': value[11]}
        y = x['rules']
        z = []
        for i in range(0,len(y)-1):
            z.append(y[i])
        z.append(m)
        payload1 = json.dumps({'rules':z})
        
        resp = requests.request("PUT", url2, headers=headers, data=payload1)
        if resp.status_code  == 200:
            print('\n-->Added Firewall rule in network '+value[2]+' under organization: '+value[0])
        else:
            print('\n-->Error while adding firewall rule in network :'+value[2]+' under organization: '+value[0])
            print(resp.text+'\n   Response Code : '+str(resp.status_code))
    else:
        print("\n-->Network "+value[2]+" not found in Organization "+value[0])