import requests

def make_api_request(method,url,headers,payload=None):
    response = requests.request(method, url, headers=headers, data=payload)
    return response

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
org_input_file = 'createorglist.txt'
    
base_url = read_file(base_file)
api_token = read_file(api_file)
org_list = listorg(org_input_file)

payload = {}
headers = {
  'X-Cisco-Meraki-API-Key': api_token
}

for org_name in org_list:
    m = 'POST'
    url = base_url+'/organizations'
    payload = {
        "name": org_name
    }
    try:
        x = make_api_request(m,url,headers,payload)
        print("Created org "+org_name+"\n")
    except:
        print("Error creating "+org_name+"\n")

    

