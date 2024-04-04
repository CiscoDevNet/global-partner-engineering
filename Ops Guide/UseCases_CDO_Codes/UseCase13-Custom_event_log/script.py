import requests
import json
import sys
import os
from datetime import datetime
import pandas as pd

def listdevice(filename):
    with open(filename, 'r') as file:
        # Read all the lines of the file into a list
        lines = file.read().splitlines()
    return lines

def file_name(dn):
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    filename = f"Custom_Report_{dn}_{timestamp}.xlsx"
    return filename

# Function to read data from a file
def read_file(file_path):
    with open(file_path, 'r') as file:
        return file.read().strip()

# Function to make a GET request and return JSON response
def make_api_request(url, headers=None, params=None):
    response = requests.get(url, headers=headers, params=params)
    return response.json()

def main(name,fdt,tdt):
        
    url_device_records = f'{base_url}/swc/v1/historical?timeout=3&limit=10000'

    headers_device_records = {
            'Authorization': f'Bearer {bearer_token}',
            'Content-Type': 'application/json',
        }
   
    params_device_records = {
        'q': f'(timestamp:[{fdt}00000 TO {tdt}00000]) AND (SensorId:{name} OR Hostname:{name} OR DeviceIP:{name})',
    }
    response_device_records = make_api_request(url_device_records, headers=headers_device_records, params=params_device_records)
    
    device_data = response_device_records.get('results',[])
    return(device_data)


if __name__ == "__main__":
    
    print('Enter from and to date & time in YYYY-MM-DD-HH-MM format')
    from_dt = input('Enter from Date-Time : ')
    to_dt = input('Enter to Date-Time : ')
   
    format = "%Y-%m-%d-%H-%M"
    res = True
    
    try:
        res = bool(datetime.strptime(from_dt,format))
        res = bool(datetime.strptime(to_dt,format))
    except ValueError:
        res = False

    base_file = 'baseUrl.txt'
    token_file = 'bearer.txt'
    device_file = 'device_list.txt'
    
    base_url = read_file(base_file)
    bearer_token = read_file(token_file)
    device_list = listdevice(device_file)
    
   
    for device_name in device_list:
        report = main(device_name,from_dt.replace('-',''),to_dt.replace('-',''))
        
        #Write data to excel file
        df = pd.DataFrame(report)
        excel_file_path = file_name(device_name)
        df.to_excel(excel_file_path, index=False)
        print(f'Data for {device_name} has been written to {excel_file_path}')