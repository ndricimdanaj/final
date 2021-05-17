output "vm_id" {
  value = azurerm_linux_virtual_machine.linuxvm.id
}

output "vm_ip" {
  value = azurerm_linux_virtual_machine.linuxvm.public_ip_address
}

output "tls_private_key" { 
  value = tls_private_key.example_ssh.private_key_pem 
  sesitive = true
}

output "tls_private_key1" { 
  value = tls_private_key.example_ssh.private_key_pem 
  sesitive = true
}

output "tls_private_key2" { 
  value = tls_private_key.example_ssh.private_key_pem 
  sesitive = true
}



