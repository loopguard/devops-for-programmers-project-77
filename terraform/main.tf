resource "yandex_vpc_network" "default" {
  name = "my-network"
}

resource "yandex_vpc_subnet" "default" {
  name           = "my-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.2.0.0/24"]
}

resource "yandex_compute_instance" "vm" {
  count       = 2
  name        = "backend-${count.index}"
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8e7b5r26l7rul2d0i7" # Ubuntu 22.04 LTS
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_lb_target_group" "group" {
  name = "target-group"

  target {
    subnet_id = yandex_vpc_subnet.default.id
    address   = yandex_compute_instance.vm[0].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.default.id
    address   = yandex_compute_instance.vm[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "lb" {
  name = "external-lb"

  listener {
    name        = "http-listener"
    port        = 80
    target_port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.group.id

    healthcheck {
      name = "http-hc"
      tcp_options {
        port = 80
      }
    }
  }
}
