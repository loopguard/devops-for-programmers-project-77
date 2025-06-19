data "local_file" "ssh_key" {
  filename = var.ssh_pub_key_path
}
