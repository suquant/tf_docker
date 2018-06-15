variable "token" {}
variable "hosts" {
  default = 2
}
variable "docker_opts" {
  type = "list"
  default = ["--iptables=false", "--ip-masq=false"]
}

provider "hcloud" {
  token = "${var.token}"
}

module "provider" {
  source = "git::https://github.com/suquant/tf_hcloud.git?ref=v1.0.0"

  count = "${var.hosts}"
  token = "${var.token}"
}

module "docker" {
  source = ".."

  count       = "${var.hosts}"
  connections = "${module.provider.public_ips}"

  docker_opts = ["${var.docker_opts}"]
}
