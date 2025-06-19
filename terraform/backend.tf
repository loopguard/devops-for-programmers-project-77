terraform {
  backend "s3" {
    endpoint   = "https://storage.yandexcloud.net"
    bucket     = "sudosu-state-bucket"
    region     = "ru-central1"
    key        = "redmine/terraform.tfstate"
    access_key = var.s3_access_key
    secret_key = var.s3_secret_key
    skip_region_validation = true
    skip_credentials_validation = true
  }
}
