from flask import Flask, jsonify
import vManageAlarms
import vManageHealth
import CatalystCenterHealth
import CatalystCenterAppHealth
import vManageNWPI_readTrace
import CatalystCenterAlarms

app = Flask(__name__)

@app.route('/data', methods=['GET'])
def get_data():
    """Return data about the devices. A sample return data for this function is provided in demodbdata.py
    parameters: None
    returns: JSON
    """
    data = { 
        "vManageHealth": vManageHealth.get_data(),
        "DnacHealth" : CatalystCenterHealth.get_data(),
        "vManageNWPI_readTrace" : vManageNWPI_readTrace.get_data(),
        "DnacAppHealth": CatalystCenterAppHealth.get_data(),
        "vManageAlarms": vManageAlarms.get_data(),
        "DnacAlarms": CatalystCenterAlarms.get_data()
        }
    
    return jsonify({'data': data})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5556, debug=True)
