# This script takes list of the devices in a file(device_list.txt), for which report the is to be fetched. 
# It also prompts for a time range for which report is to be fetched (in YYYY-MM-DD-HH-MM format in GMT in 24hr format). Make sure the 'To' date/time is not past the current date/time.
# It saves the output to an excel file in the same path as the script.
# Also as an input, we need two text files(baseURL.txt and bearer.txt) in the same path as the script, one containing the baseurl and other containing the bearer token
# Install the python dependencies before running the script