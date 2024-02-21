output "identity_principal_id" {
  value = azurerm_linux_virtual_machine.vm.identity.0.principal_id
}  

output "public_IP" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}