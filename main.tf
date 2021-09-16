# Получить информацию сети
data "http" "net_info" {
  url = "https://ipcalc.co/apicalc/${var.gw_ip}/${var.prefix}/"
}

# Создание маршрутизируемой сети
resource "vcd_network_routed" "orgNet" {
  count = var.type == "routed" ? 1 : 0
  
  edge_gateway   = var.vcd_edge_name
  name           = var.net_name
  netmask        = local.netmask
  gateway        = var.gw_ip
  interface_type = var.interface_type
  dns1           = var.dns_settings.dns1
  dns2           = var.dns_settings.dns2
  dns_suffix     = var.dns_settings.suff

  static_ip_pool {
    start_address = local.start_address
    end_address   = local.end_address
  }
}

# Создание изолированной сети
resource "vcd_network_isolated" "orgNet" {
  count = var.type == "isolated" ? 1 : 0

  name       = var.net_name
  netmask    = local.netmask
  gateway    = var.gw_ip
  dns1       = var.dns_settings.dns1
  dns2       = var.dns_settings.dns2
  dns_suffix = var.dns_settings.suff

  static_ip_pool {
    start_address = local.start_address
    end_address   = local.end_address
  }
}
