from flask import Flask,request
from flask_cors import CORS, cross_origin
import Teamswebhookreceiver

app = Flask(__name__)

cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

@app.route('/', methods=['POST'])
def entry():
    return Teamswebhookreceiver.runme(request=request)

@app.route('/getdata', methods=['GET'])
@cross_origin()
def directreply():
    return Teamswebhookreceiver.getreply(data=request.args["query"])