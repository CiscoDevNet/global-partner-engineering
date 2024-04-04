# Data Sources
data "fmc_port_objects" "http" {
    name = "HTTP"
}

data "fmc_port_objects" "https" {
    name = "HTTPS"
}

data "fmc_port_objects" "ssh" {
    name = "SSH"
}

data "fmc_ips_policies" "ips_policy" {
    name = "Security Over Connectivity"
}

data "fmc_security_zones" "inside" {
    name = "inside"
}

data "fmc_security_zones" "outside" {
    name = "outside"
}

# Get currently on-boarded device
data "fmc_devices" "ftd3" {
	name = "ftd3"
}


# Network Objects
resource "fmc_network_objects" "app_subnet" {
  name        = "${var.prefix}-app_subnet"
  value       = var.app_subnet
  description = "App Network"
}

# Host Objects
resource "fmc_host_objects" "app_server" {
    name        = "${var.prefix}-app_server"
    value       = var.app_server
    description = "App Server"
}

# IPS Policy
resource "fmc_ips_policies" "ips_policy" {
    name            = "${var.prefix}-ips_policy"
    inspection_mode = "DETECTION"
    basepolicy_id   = data.fmc_ips_policies.ips_policy.id
}

# Create new Access Control Policy
resource "fmc_access_policies" "new_access_policy" {
  name           = "FTDy-Access-Policy"
  default_action = "block"
}

# Access Control Policy Rules
resource "fmc_access_rules" "access_rule_1" {
    depends_on = [fmc_access_policies.new_access_policy]
    acp                = fmc_access_policies.new_access_policy.id
	section            = "mandatory"
    name               = "${var.prefix}_permit"
    action             = "allow"
    enabled            = true
    send_events_to_fmc = true
    log_files          = false
    log_begin          = true
    log_end            = true
	source_zones {
        source_zone {
            id   = data.fmc_security_zones.inside.id
            type = "SecurityZone"
        }
    }
    destination_zones {
        destination_zone {
            id   = data.fmc_security_zones.outside.id
            type = "SecurityZone"
        }
    }
	source_networks {
        source_network {
            id   = fmc_network_objects.app_subnet.id
            type = "Network"
        }
    }
	destination_ports {
        destination_port {
            id = data.fmc_port_objects.http.id
            type = "TCPPortObject"
        }
        destination_port {
            id = data.fmc_port_objects.https.id
            type = "TCPPortObject"
        }
    }
    ips_policy   = fmc_ips_policies.ips_policy.id
}

resource "fmc_access_rules" "access_rule_2" {
    depends_on = [fmc_access_policies.new_access_policy]
    acp                = fmc_access_policies.new_access_policy.id
    section            = "mandatory"
    name               = "${var.prefix}_access_to_app"
    action             = "allow"
    enabled            = true
    send_events_to_fmc = true
    log_files          = false
    log_begin          = true
    log_end            = true
    destination_networks {
        destination_network {
            id = fmc_host_objects.app_server.id
            type =  "Host"
        }
    }
    destination_ports {
        destination_port {
            id = data.fmc_port_objects.ssh.id
            type = "TCPPortObject"
        }
    }
    ips_policy   = fmc_ips_policies.ips_policy.id
}

# Assign the policy to device
resource "fmc_policy_devices_assignments" "policy_assignment" {
    depends_on = [
        fmc_access_rules.access_rule_1,
        fmc_access_rules.access_rule_2
    ]
	policy {
        id = fmc_access_policies.new_access_policy.id
        type = fmc_access_policies.new_access_policy.type
    }
    target_devices {
        id = data.fmc_devices.ftd3.id
        type = data.fmc_devices.ftd3.type
    }
}

# Deploy changes to device
resource "fmc_ftd_deploy" "ftd" {
    depends_on = [fmc_policy_devices_assignments.policy_assignment]
    device = data.fmc_devices.ftd3.id
    ignore_warning = true
    force_deploy = false
}