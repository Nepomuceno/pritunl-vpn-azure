variable "name" {
    type = string
}

variable "location" {
    type = string
    default="uksouth"
}

variable "vmsize" {
    type = string
    default = "Standard_B1s"
}

variable "ssh_key_pub" {
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable "ssh_key_priv" {
    type = string
    default = "~/.ssh/id_rsa"
}