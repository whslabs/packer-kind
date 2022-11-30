packer {
  required_plugins {
    # https://github.com/hashicorp/packer-plugin-ansible
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.0.3"
    }
    # https://github.com/hashicorp/packer-plugin-qemu
    qemu = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "kind" {
  accelerator          = "kvm"
  disk_size            = "50G"
  http_directory       = "preseed"
  iso_checksum         = "743ed06582dce4b714896b14fe7fd5eda66ab5203e3f94965b85924991a35d68"
  iso_url              = "https://deb.debian.org/debian/dists/bullseye/main/installer-amd64/current/images/netboot/mini.iso"
  memory               = 2048
  shutdown_command     = "sudo -S shutdown -P now"
  ssh_private_key_file = "packer"
  ssh_timeout          = "30m"
  ssh_username         = "packer"
  boot_command = [
    "<esc><wait>",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg SSH_PUBLIC_KEY_FILE=packer.pub<enter>"
  ]
  qemuargs = [
    ["-cpu", "host"],
  ]
}

build {
  sources = ["source.qemu.kind"]

  provisioner "ansible" {
    playbook_file = "ansible/playbook.yaml"
    use_proxy     = false
    user          = "packer"
  }
}
