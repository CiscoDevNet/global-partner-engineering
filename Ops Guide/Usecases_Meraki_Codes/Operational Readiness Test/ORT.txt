import requests
import os
from os import environ
import sys
import re
from getpass import getpass
import urllib3
from requests.auth import HTTPBasicAuth
urllib3.disable_warnings()

def read_file(filename):
    with open(filename, 'r') as file:
        return file.read().strip()

def get_org_list(api_key):
    '''
    Returns the organizations' list where admin has an access.
    '''

    url = "https://api.meraki.com/api/v1/organizations/"
    headers = {'X-Cisco-Meraki-API-Key': api_key, 'Content-Type': 'application/json'}
    r = requests.request('GET', url, headers=headers)
    if r.status_code == '401':
        print_user_text("Invalid API key.")
        sys.exit(1)
    rjson = r.json()
    return (rjson)

def get_inventory(api_key,organizationId):
    url="https://api.meraki.com/api/v1/organizations/{}/inventory/devices".format(organizationId)
    headers = {'X-Cisco-Meraki-API-Key': api_key, 'Content-Type': 'application/json'}
    r = requests.request('GET', url, headers=headers)
    if r.status_code == '401':
        print_user_text("Invalid API key.")
        sys.exit(1)
    rjson = r.json()
    return (rjson)

def get_networks(api_key,organizationId):
    url="https://api.meraki.com/api/v1/organizations/{}/networks".format(organizationId)
    headers = {'X-Cisco-Meraki-API-Key': api_key, 'Content-Type': 'application/json'}
    r = requests.request('GET', url, headers=headers)
    if r.status_code == '401':
        print_user_text("Invalid API key.")
        sys.exit(1)
    rjson = r.json()
    return (rjson)


def get_device_from_network(api_key,networkID):
    url="https://api.meraki.com/api/v1/networks/{}/devices".format(networkID)
    headers = {'X-Cisco-Meraki-API-Key': api_key, 'Content-Type': 'application/json'}
    r = requests.request('GET', url, headers=headers)
    if r.status_code == '401':
        print_user_text("Invalid API key.")
        sys.exit(1)
    rjson = r.json()
    return (rjson)

def get_device_statuses(api_key,organizationId):
    url="https://api.meraki.com/api/v1/organizations/{}/devices/statuses".format(organizationId)
    headers = {'X-Cisco-Meraki-API-Key': api_key, 'Content-Type': 'application/json'}
    r = requests.request('GET', url, headers=headers)
    if r.status_code == '401':
        print_user_text("Invalid API key.")
        sys.exit(1)
    rjson = r.json()
    return (rjson)

def main(token):
    api_key = token
    response = get_org_list(api_key)
    organizations = []
    networks = {}
    for i in response:
        print("Organization {} id {}".format([i["name"]], i["id"]))
        organizations.append(i["id"])
    organization = input("\nPlease provide Organization ID (number) for which you want to perform ORT:\n")
    if organization not in organizations:
        print("You have provided incorrect organization id")
        exit()


    #Get neworks from Org
    networks_in_org = get_networks(api_key,organization)
    #print(networks_in_org)
    for i in networks_in_org:
        networks[i["name"]] = i["id"]

    print("List of networks in organization:\n")
    
    for key,value in networks.items():
        print(key)
    
    network = input("\nPlease provide network name for which you want to perform ORT\n")
    print("\n")
    devices={}
    get_devices = get_device_from_network(api_key,networks[network])
    for i in get_devices:
        devices[i['name']] = {}
        devices[i['name']]['mac'] = i['mac']
        devices[i['name']]['mode'] = i['model']
        devices[i['name']]['serial'] = i['serial']
        devices[i['name']]['tags'] = i['tags']
    
    
    for i,j in devices.items():
        #print(i)
        #print(j['serial'])
        #print(organization)
        get_details = get_device_statuses(api_key,organization)
        #print(get_details)
        for k in get_details:
            if k['serial'] == j['serial']:
                devices[i]['status'] = k['status']
                devices[i]['productType'] = k['productType']
    
    #print(devices)
    
    
    
    print("----")
    print("Discovered following devices in network:")
    print(devices)
    
    
    print("---------")
    print("Script will check following:\n"
        "\n--Device reachable in Meraki Dashboard "
        "\n--Circuit IDs are tagged in Meraki Dashboard according to naming conventio"
        "\n--Device has no hardware alarms\n-----------\n")
    
    for i,j in devices.items():
        print("\nChecking {}\n".format(i))
    
        #STATUS CHECK
    
        if j['status'] == "online":
            print("device {} appears online in Meraki Dashboard\n".format(i))
            status_check = "OK"
        else:
            print("Device {} is not online in Meraki Dashboard\n".format(i))
            status_check = "NOT OK - device is not online in Meraki Dashboard [?]"
    
    
        #TAG check
    
    
        regexp = re.compile(r'3[cC]')
        tag = 0
        for k in j['tags']:
    
            if regexp.search(k) and j['productType'] == "appliance":
                #print('matched')
                tag =tag+1
            elif j['productType'] == "appliance":
                #print("nok")
                tag = tag+0
            else:
                #print("not appliance")
                tag = 1
        if tag > 0 and j['productType'] == "appliance":
            tag_match = "OK"
        elif tag > 0 and j['productType'] != "appliance":
            tag_match = "OK - Not applicable"
        elif tag == 0 and j['productType'] == "appliance":
            tag_match = "NOT OK, Appliance has no circuit tag provided"
        elif tag == 0 and j['productType'] != "appliance":
            tag_match = "OK - Not applicable"
    
    
        #Alerts check
        if j['status'] == "online":
            #print("device {} appears online in Meraki Dashboard\n".format(i))
            alarm_check = "OK"
        else:
            #print("Device {} is offline in Meraki Dashboard\n".format(i))
            alarm_check = "NOT OK - device has active alarms and has status {}".format(j['status'])
    
        print("\n------\n")
        print("ORT Result for '{}' - please paste to the ticket".format(i))
        print("{:<80} {:<10}\n".format('TASK', 'Result'))
        print("{:<80} {:<10}\n".format('Device reachable in Meraki Dashboard', status_check))
        print("{:<80} {:<10}\n".format('Circuit IDs are tagged in Meraki Dashboard according to naming convention', tag_match))
        print("{:<80} {:<10}\n".format('Device has no hardware alarms', alarm_check))
        print("\n------\n")


if __name__ == '__main__':
    
    api_file = 'apitoken.txt'
    api_token = read_file(api_file)
    
    main(api_token)
