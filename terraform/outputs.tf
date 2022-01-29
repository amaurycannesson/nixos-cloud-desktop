output "rdp_url" {
  value = "rdp://${aws_instance.cloud_desktop.public_ip}"
}

output "ssh_cmd" {
  value = "ssh -i ~/.ssh/${var.cloud_desktop_key_name}.pem root@${aws_instance.cloud_desktop.public_ip}"
}
