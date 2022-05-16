# Get network info
data "http" "net_info" {
  url = "https://ipcalc.co/apicalc/${var.gw_ip}/${var.prefix}/"
}

#
data "vcd_nsxt_edgegateway" "orgEdge" {
  name = var.vcd_edge_name
}

# Создание маршрутизируемой сети
resource "vcd_network_routed_v2" "orgNet" {
  count = var.type == "routed" ? 1 : 0
  
  name            = var.net_name
  edge_gateway_id = data.vcd_nsxt_edgegateway.orgEdge.id
  gateway         = var.gw_ip
  prefix_length   = var.prefix
  dns1            = var.dns_settings.dns1
  dns2            = var.dns_settings.dns2
  dns_suffix      = var.dns_settings.suff

  static_ip_pool {
    start_address = var.pool_start != "" ? var.pool_start : local.start_address
    end_address   = var.pool_end != "" ? var.pool_end : local.end_address
  }
}

# Создание изолированной сети
resource "vcd_network_isolated_v2" "orgNet" {
  count = var.type == "isolated" ? 1 : 0

  name          = var.net_name
  gateway       = var.gw_ip
  prefix_length = var.prefix
  dns1          = var.dns_settings.dns1
  dns2          = var.dns_settings.dns2
  dns_suffix    = var.dns_settings.suff

  static_ip_pool {
    start_address = local.start_address
    end_address   = local.end_address
  }
}
