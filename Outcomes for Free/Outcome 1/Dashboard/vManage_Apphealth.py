import vManage_auth
from pprint import pprint

def get_data():
    data = vManage_auth.get_data("/dataservice/statistics/perfmon/applications/sites/health")

    #result.append({"name":item2["name"],"events": "health: " +str(item2["health"])+ ", packetLossPercent: "+str(item2["packetLossPercent"]) + ", networkLatency: "+str(item2["networkLatency"])+ ", Jitter: "+ str(item2["jitter"]) , "url": Dnac_auth.BASE_URL + "/dna/assurance/application/details?id="+item2["name"]+"&siteId="+item, "health":"critical"})


    return data["data"]

if __name__ == "__main__":
    pprint(get_data())