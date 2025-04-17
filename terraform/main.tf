terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
      version = "2.5.0"
    }
  }
}

provider "lxd" {
  # Configuration options
  # generate_client_certificates = true
  accept_remote_certificate    = true

  remote {
    name     = var.lxd_name
    address  = var.lxd_server
    token    = var.lxd_token
    default  = true
  }
}

resource "lxd_instance" "citrix-workplace" {
  name  = "citrix-workplace"
  image = var.lxd_image

  config = {
    "boot.autostart" = true
    "cloud-init.user-data" = templatefile("${path.module}/templates/cloud-init.tpl", {
       ssh_user = var.ssh_user,
       citrix_script  = data.local_file.citrix_script.content,
     })
  }
}

data "local_file" "citrix_script" {
  filename = "${path.module}/scripts/prepare-citrix.sh"
}
