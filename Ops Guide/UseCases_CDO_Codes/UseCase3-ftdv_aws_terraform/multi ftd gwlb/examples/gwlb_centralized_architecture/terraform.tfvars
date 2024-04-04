aws_access_key = ""
aws_secret_key = ""

region = "us-east-1"

ftd_01_hostname = ["AWS_FTDv0","AWS_FTDv1"]
cdo_api_token   = ""
cdo_base_url = "https://apj.cdo.cisco.com"


service_vpc_cidr   = "172.16.0.0/16"
service_vpc_name   = "service-vpc"
service_create_igw = "true"

mgmt_subnet_cidr    = ["172.16.11.0/24", "172.16.21.0/24"]
outside_subnet_cidr = ["172.16.12.0/24", "172.16.22.0/24"]
diag_subnet_cidr    = ["172.16.13.0/24", "172.16.23.0/24"]
inside_subnet_cidr = ["172.16.14.0/24", "172.16.24.0/24"]

ngw_subnet_cidr   = ["172.16.51.0/24", "172.16.61.0/24"]
gwlbe_subnet_cidr = ["172.16.52.0/24", "172.16.62.0/24"]
tgw_subnet_cidr   = ["172.16.53.0/24", "172.16.63.0/24"]

ftd_mgmt_ip    = ["172.16.11.11", "172.16.21.21"]
ftd_outside_ip = ["172.16.12.12", "172.16.22.22"]
ftd_diag_ip    = ["172.16.13.13", "172.16.23.23"]
ftd_inside_ip = ["172.16.14.14", "172.16.24.24"]
use_ftd_eip   = true

outside_subnet_name = ["outside1", "outside2"]
mgmt_subnet_name    = ["mgmt1", "mgmt2"]
diag_subnet_name    = ["diag1", "diag2"]
inside_subnet_name = ["inside1", "inside2"]

gwlbe_subnet_name = ["gwlb1", "gwlb2"]
ngw_subnet_name   = ["ngw1", "ngw2"]
tgw_subnet_name   = ["tgw1", "tgw2"]

spoke_vpc_cidr    = "10.0.0.0/16"
spoke_vpc_name    = "spoke-vpc"
spoke_create_igw  = "false"
spoke_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
spoke_subnet_name = ["spoke1", "spoke2"]

keyname                 = ""    #Create a keypair on AWS beforehand and mention here
instances_per_az        = 1
availability_zone_count = 2

gwlb_name = "GWLB"

outside_interface_sg = [
  {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "All Allowed"
  }
]

inside_interface_sg = [
  {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Access"
  }
]

mgmt_interface_sg = [
  {
    from_port   = 8305
    protocol    = "TCP"
    to_port     = 8305
    cidr_blocks = ["0.0.0.0/0"]
    description = "Mgmt Traffic from FMC"
  }
]