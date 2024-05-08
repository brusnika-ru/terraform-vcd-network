data "vcd_vdc_group" "orgGroup" {
  count = var.dcg != false ? 1 : 0 
  name  = var.vcd_group_name
}

data "vcd_nsxt_edgegateway" "orgEdgeWithDCG" {
  count    = var.dcg != false ? 1 : 0 
  name     = var.vcd_edge_name
  owner_id = data.vcd_vdc_group.orgGroup[0].id
}

data "vcd_nsxt_edgegateway" "orgEdge" {
  count    = var.dcg == false ? 1 : 0 
  name     = var.vcd_edge_name
}

# Создание маршрутизируемой сети
resource "vcd_network_routed_v2" "orgNet" {
  count = var.type == "routed" ? 1 : 0
  
  name            = var.net_name
  edge_gateway_id = var.dcg != false ? data.vcd_nsxt_edgegateway.orgEdgeWithDCG[0].id : data.vcd_nsxt_edgegateway.orgEdge[0].id
  gateway         = var.gw_ip
  prefix_length   = var.prefix
  dns1            = var.dns_settings.dns1
  dns2            = var.dns_settings.dns2
  dns_suffix      = var.dns_settings.suff

  dynamic "static_ip_pool" {
    for_each = var.static_pools
    content {
      start_address = static_ip_pool.value["start_address"]
      end_address   = static_ip_pool.value["end_address"]
    }
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

  dynamic "static_ip_pool" {
    for_each = var.static_pools
    content {
      start_address = static_ip_pool.value["start_address"]
      end_address   = static_ip_pool.value["end_address"]
    }
  }
}
