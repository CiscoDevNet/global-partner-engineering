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

#from openai import OpenAI
import credentials
from openai import AzureOpenAI


def transformdata(all_data):
    all_data = str(all_data)
    # change comma to space
    all_data = all_data.replace(',', ' ')
    #remove doublespaces
    all_data = all_data.replace('  ', ' ')
    # change : to space
    all_data = all_data.replace(':', ' ')
    #remove doublespaces
    all_data = all_data.replace('  ', ' ')
    #correct the https by adding back colon
    all_data = all_data.replace('https ', 'https:')
    # Remove quotes
    all_data = all_data.replace("'", '')
    # Remove brackets
    all_data = all_data.replace("[", '')
    # Remove brackets
    all_data = all_data.replace("]", '')
    # Remove brackets
    all_data = all_data.replace("{", '')
    # Remove double brackets
    all_data = all_data.replace('}}', '}')
    # change brackets to comma (this is the only logical seperator between list of items)
    all_data = all_data.replace("}", ',')
    # Remove space after comma
    all_data = all_data.replace(", ", ',')
    # Remove the last trailing comma
    all_data = all_data.rstrip(',')
    return all_data


def queryme(query,db):
    db_data = {}
    all_data = []
    for dbentry in db:
        for collection_name in dbentry.list_collection_names():
            if(collection_name == 'maindb-semantic'):
                continue
            collection = dbentry[collection_name]
            db_data[collection_name] = list(collection.find({}, {'_id': False}))
    all_data.append(db_data)
    all_data = transformdata(all_data)
        # Create a chat completion
    messages = [
        {
            "role": "system",
            "content": all_data + ". If the query cannot be answered with the dashboard data, politely mention that its not possible to answer with the dashboard data. Do not deviate from the dashboard data context and do not reply to any other unrelated queries."
        },
        {
            "role": "user",
            "content": query
        }
    ]

    # find the prompt token length
    prompt_length = int((len(str(messages))/4))
    print("prompt token length is: ", prompt_length)

    print("sending the prompt to the azuregtp4-o model")
    client = AzureOpenAI(
    azure_endpoint = "https://openaigpts.openai.azure.com/", 
    api_key=credentials.azure_openai_token,  
    api_version="2024-02-15-preview"
    )
    
    # Create a chat completion
    chat_completion = client.chat.completions.create(
        model="azuregpt-4o", messages = messages, temperature = 0.1, max_tokens = 1000
    )

    # Print the assistant's message
    return chat_completion.choices[0].message.content
