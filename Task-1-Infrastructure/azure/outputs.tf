output "azure_vm_public_ip" {
  description = "Public IP of Azure VM"
  value       = azurerm_public_ip.pip.ip_address
}
