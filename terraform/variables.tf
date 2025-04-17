
variable "ssh_user" {
    type = string
    default = "USER NOT SET"
}

variable "lxd_name" {
    type = string
    default = "local"
}

variable "lxd_server" {
    type = string
    default = "unix://"
}

variable "lxd_token" {
    type = string
    default = null
}

variable "lxd_image" {
    type = string
    default = "ubuntu:22.04"
}
