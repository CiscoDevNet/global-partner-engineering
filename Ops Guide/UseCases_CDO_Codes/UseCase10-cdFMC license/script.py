import requests
import json
import openpyxl
import sys
import os
from datetime import datetime
import pandas as pd

def file_name():
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    filename = f"device_lic_output_{timestamp}.xlsx"
    return filename

# Function to read data from a file
def read_file(file_path):
    with open(file_path, 'r') as file:
        return file.read().strip()

# Function to make a GET request and return JSON response
def make_get_request(url, headers=None):
    response = requests.get(url, headers=headers)
    return response.json()

# Read base URL and bearer token from files
base_url = read_file('baseUrl.txt')
bearer_token = read_file('bearer.txt')

# Get domainUUID
info_url = f"{base_url}/api/fmc_platform/v1/info/domain"
headers = {'Authorization': f'Bearer {bearer_token}'}
info_response = make_get_request(info_url, headers=headers)
domain_uuid = info_response['items'][0]['uuid']

# Get all devices
url_device_records = f'{base_url}/api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords'
headers_device_records = {
    'Authorization': f'Bearer {bearer_token}',
    'Content-Type': 'application/json',
    }

response_device_records = make_get_request(url_device_records, headers=headers_device_records)
device_data = response_device_records.get('items',[])

license_out = []

# Get license information
for i in range(0,len(device_data)):
    name = device_data[i]['name']
    objectid = device_data[i]['id']
    url_device_license = f'{base_url}/api/fmc_platform/v1/license/devicelicenses/{objectid}'
    license_response = make_get_request(url_device_license, headers=headers)
    license_data = license_response.get('licenseTypes',[])
    all_data = [name,objectid,', '.join(sorted(license_data))]
    license_out.append(all_data)

device_headers = ["Name", "ID", "Licenses"]

#Write data to excel file
df = pd.DataFrame(license_out)
excel_file_path = file_name()
df.to_excel(excel_file_path, index=False, header=device_headers)

print(f'Data has been written to {excel_file_path}')