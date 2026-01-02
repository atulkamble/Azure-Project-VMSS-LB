# Resource Group Output
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Public IP Output
output "load_balancer_public_ip" {
  description = "Public IP address of the load balancer"
  value       = azurerm_public_ip.main.ip_address
}

output "load_balancer_fqdn" {
  description = "Fully qualified domain name of the load balancer"
  value       = azurerm_public_ip.main.fqdn
}

# Load Balancer Outputs
output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = azurerm_lb.main.id
}

output "load_balancer_name" {
  description = "Name of the load balancer"
  value       = azurerm_lb.main.name
}

# Virtual Network Outputs
output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = azurerm_subnet.internal.id
}

# VMSS Outputs
output "vmss_id" {
  description = "ID of the virtual machine scale set"
  value       = azurerm_linux_virtual_machine_scale_set.main.id
}

output "vmss_name" {
  description = "Name of the virtual machine scale set"
  value       = azurerm_linux_virtual_machine_scale_set.main.name
}

# Web Application URL
output "web_app_url" {
  description = "URL to access the web application"
  value       = "http://${azurerm_public_ip.main.ip_address}"
}

# SSH Command
output "ssh_connection_command" {
  description = "SSH connection command (Note: Direct SSH may not be possible due to load balancer configuration)"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

# Azure Portal Links
output "azure_portal_resource_group_url" {
  description = "Azure Portal URL for the resource group"
  value       = "https://portal.azure.com/#@/resource/subscriptions/{subscription-id}/resourceGroups/${azurerm_resource_group.main.name}"
}