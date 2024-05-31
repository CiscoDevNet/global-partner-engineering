"""
Copyright (c) 2024 Cisco and/or its affiliates.
This software is licensed to you under the terms of the Cisco Sample
Code License, Version 1.1 (the "License"). You may obtain a copy of the
License at
https://developer.cisco.com/docs/licenses
All use of the material herein must be in accordance with the terms of
the License. All rights not expressly granted by the License are
reserved. Unless required by applicable law or agreed to separately in
writing, software distributed under the License is distributed on an "AS
IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
or implied.
"""

__author__ = "Joel Jose <joeljos@cisco.com>"
__copyright__ = "Copyright (c) 2024 Cisco and/or its affiliates."
__license__ = "Cisco Sample Code License, Version 1.1"

import credentials
import GPT
import mongodb_auth
from openai import AzureOpenAI


def semanticcheck(query,cachedquery,client):
    messages = [
        {
            "role": "system",
            "content": "I am a helpful text classifier AI. I will help you determine if the queries are semantically exactly the same or not."
        },
        {
            "role": "user",
            "content": "Reply with only YES or NO. Given 2 queries asked by a customer, your task is to find out if they mean exactly the same. Following are the queries, seperated by semicolon : " + query + " ; " + cachedquery
        }
    ]

    chat_completion = client.chat.completions.create(
    model="azuregpt-4o", messages = messages, temperature = 0.1, max_tokens = 1000
    )
    #print(chat_completion.choices[0].message.content)
    if(chat_completion.choices[0].message.content == 'YES'):
        #print("Its True")
        return True
    else:
        #print("The query was semantically False")
        return False

def getdbdata(db):  
    all_data = []
    collection = db['maindb-semantic']
    all_data = all_data + list(collection.find({}, {'_id': False}))
    return all_data

def dbcheck(query, db, client):
    collection = db['maindb-semantic']
    all_data = getdbdata(db)
    #print("all_data :",all_data)
    if(all_data != []):
        #print("semantic:",all_data)
        #print("alldata: ",all_data)
        for d in all_data:
            if(query == d["query"]):
                return d["result"]
        for d in all_data:
            if(semanticcheck(query,d["query"],client)):
                qoutput = [{"query":query,"result":d["result"]}]
                #print("similar:",qoutput)
                mongodb_auth.addData(qoutput,collection)
                return d["result"]     
    return False

def queryme(query):
    OPENAI_API_KEY = credentials.openai_token
    client = AzureOpenAI(
    azure_endpoint = "https://openaigpts.openai.azure.com/", 
    api_key=credentials.azure_openai_token,  
    api_version="2024-02-15-preview"
    )
    db = mongodb_auth.authenticatedb()
    result = dbcheck(query,db,client)
    if(result is False):
        result = GPT.queryme(query,db)
        qoutput = [{"result":result , "query":query}]
        collection = db['maindb-semantic']
        mongodb_auth.addData(qoutput,collection)
        print("openai:")
        return result
    else :
        return result


def purgedb():
    db = mongodb_auth.authenticatedb()
    collection = db['maindb-semantic']
    print(mongodb_auth.purge_collection(collection))

if(__name__ == '__main__'):
    #purgedb()
    while(True):
        query = input("enter query : ")
        result = queryme(query=query)
        print(result)   