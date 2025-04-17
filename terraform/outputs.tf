output "citrix-workplace-ipv4" {
  value = lxd_instance.citrix-workplace.ipv4_address
  description = "The IPv4 address of the LXD citrix-workplace server instance."
}

output "connection-help" {
  value = "To connect run: \n$ ssh -Y ubuntu@${lxd_instance.citrix-workplace.ipv4_address} \nThen check with `cloud-init status --wait` . If done start /opt/Citrix/ICAClient/selfservice ."
}
