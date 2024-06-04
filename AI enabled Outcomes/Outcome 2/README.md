# Outcomes for Free - Outcome 2

This repository will hold the code for the outcome2

This is a Cross-Domain dashboard for displaying day 2 operations data from the Cisco Controllers.

_Note : The steps here are only for a lab environment. There may be additional considerations like security, performance, scalability, maintainability..etc needed before production use._

Recommended to use Python virtualenv for your python projects :
a) python3 -m venv my_env
b) source my_env/bin/activate

Main steps to run the repo in your local machine :

1) do a git clone of this repository
2) add in the correct .env file in the backend folder
3) For Frontend:
 a) execute "python dashboardControllerREST.py"
 b) go to the frontend folder and execute "npm install" and then "npm start"
4) For Backend:
  a) execute "python ControllerREST.py
  b) to do a dry run, without affecting the db : execute "python drydbPush.py" or to check db content : execute "python dbPull.py" or to update the db : execute "python dbPush.py"

