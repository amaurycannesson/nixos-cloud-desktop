packer {
  required_version = "~> 1.7.8"

  required_plugins {
    amazon = {
      version = "~> 1.0.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "nixos-base-ami" {
  filters = {
    architecture = "x86_64"
  }
  owners      = ["080433136561"]
  most_recent = true
}

source "amazon-ebs" "nixos-cloud-desktop" {
  ami_name      = "nixos-cloud-desktop"
  instance_type = "t2.medium"
  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/xvda"
    volume_size           = 24
    volume_type           = "gp2"
  }
  region                = "eu-west-2"
  source_ami            = data.amazon-ami.nixos-base-ami.id
  force_deregister      = true
  force_delete_snapshot = true
  ssh_username          = "root"
  ssh_keypair_name      = "packer-key"
  ssh_private_key_file  = "${path.root}/packer-key.pem"
  tags = {
    Name = "NixOS Cloud Desktop"
    Base_AMI_Name = "{{ .SourceAMIName }}"
  }
}

build {
  sources = ["source.amazon-ebs.nixos-cloud-desktop"]

  provisioner "file" {
    source      = "../nixos-config/"
    destination = "/etc/nixos"
  }

  provisioner "shell" {
    inline = ["nixos-rebuild switch", "nix-collect-garbage -d", "rm -rf /etc/ec2-metadata /etc/ssh/ssh_host_* /root/.ssh"]
  }
}
