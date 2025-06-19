output "public_ip" {
  value = yandex_compute_instance.redmine_vm.network_interface[0].nat_ip_address
}
