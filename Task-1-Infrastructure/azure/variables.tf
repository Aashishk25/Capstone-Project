variable "location" {
  default = "East US"
}

variable "vnet_cidr" {
  default = "10.101.0.0/16"
}

variable "subnet_cidr" {
  default = "10.101.1.0/24"
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "admin_username" {
  default = "azureuser"
}
