#from openai import OpenAI
import credentials
from openai import AzureOpenAI


OPENAI_API_KEY = credentials.openai_token
# Set up the OpenAI client
#client = OpenAI(api_key=OPENAI_API_KEY)

client = AzureOpenAI(
  azure_endpoint = "https://openaigpts.openai.azure.com/", 
  api_key=credentials.azure_openai_token,  
  api_version="2024-02-15-preview"
)


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


def queryme(data,db):
    all_data = {}
    for collection_name in db.list_collection_names():
        collection = db[collection_name]
        all_data[collection_name] = list(collection.find({}, {'_id': False}))
    all_data = transformdata(all_data)
    # Create a chat completion
    query = data
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


    # Create a chat completion
    chat_completion = client.chat.completions.create(
        #model="gpt-3.5-turbo", messages = messages, temperature = 0
        #model="gpt-4-turbo-preview", messages = messages, temperature = 0, max_tokens = 1000,
        model="azuregpt35turbo", messages = messages, temperature = 0.1, max_tokens = 1000


    )

    # Print the assistant's message
    #print(messages[1],"\n", chat_completion.choices[0].message.content)
    #print("\n", chat_completion.choices[0].message.content)
    return chat_completion.choices[0].message.content
