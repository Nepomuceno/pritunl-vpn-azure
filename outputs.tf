output "ssh_username" {
  value = local.vm_user
}

output "server_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "ssh_to_server" {
  value = "ssh ${local.vm_user}@${azurerm_public_ip.main.ip_address}"
}

output "pritunl_admin_console" {
  value = "https://${azurerm_public_ip.main.fqdn}"
}