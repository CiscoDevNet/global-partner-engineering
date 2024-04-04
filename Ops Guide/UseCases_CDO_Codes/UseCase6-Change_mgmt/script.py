import requests
import json
import sys
import os
from datetime import datetime
import pandas as pd

def file_name(dn):
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    filename = f"Report_{dn}_{timestamp}.xlsx"
    return filename

# Function to read data from a file
def read_file(file_path):
    with open(file_path, 'r') as file:
        return file.read().strip()

# Function to make a GET request and return JSON response
def make_api_request(url, headers=None, params=None):
    response = requests.get(url, headers=headers, params=params)
    return response.json()

def main(change_name):
        
    url_log = f'{base_url}/aegis/rest/changelogs/query'
    
    headers_records = {
            'Authorization': f'Bearer {bearer_token}',
            'Content-Type': 'application/json',
        }
   
    params_records = {
        'limit':'1000',
        'q': f'changeRequestNames.keyword:{change_name}'
    }
    chg_response = make_api_request(url_log, headers=headers_records, params=params_records)
    return(chg_response)

if __name__ == "__main__":
    
    chg_name = input('Enter change request name: ')

    base_file = 'baseUrl.txt'
    token_file = 'bearer.txt'
    
    base_url = read_file(base_file)
    bearer_token = read_file(token_file)

    report = main(chg_name)

    # Define the keys you want to write to the Excel file
    keys = ['name','createdDate','lastUpdatedDate','changeLogState','lastEventUser','lastEventDescription','extraInfo']

    # Create a new list of dictionaries with only the selected keys
    selected_report = [{k: d[k] for k in keys} for d in report]

    # Convert the list of dictionaries to a DataFrame
    df = pd.DataFrame(selected_report)

    # Write the DataFrame to an Excel file
    excel_file_path = file_name(chg_name)
    df.to_excel(excel_file_path, index=False)
    print(f'Data has been written to {excel_file_path}')