# NixOS Cloud Desktop

Build an NixOS AMI with Packer and deploy an EC2 instance with Terraform.

## Packer

```bash
packer init .
packer build .
```

### Notes

Packer key pair generation has some [issues](https://github.com/hashicorp/packer/issues/8609), so you may need to manually create an ED25519 key pair on AWS and save the private key to `./packer/packer-key.pem`

## Terraform

```bash
terraform init
terraform apply
```
