variable "token" {}
variable "hosts" {
  default = 1
}
variable "docker_opts" {
  type = "list"
  default = [
    "--iptables=false",
    "--ip-masq=false",
    "--storage-driver=overlay2",
    "--live-restore",
    "--log-level=warn",
    "--bip=169.254.123.1/24",
    "--log-driver=json-file",
    "--log-opt=max-size=10m",
    "--log-opt=max-file=5",
    "--insecure-registry 10.0.0.0/8"
  ]
}

provider "hcloud" {
  token = "${var.token}"
}

module "provider" {
  source = "git::https://github.com/suquant/tf_hcloud.git?ref=v1.1.0"

  count = "${var.hosts}"
}

module "docker" {
  source = ".."

  count       = "${var.hosts}"
  connections = "${module.provider.public_ips}"

  docker_opts = ["${var.docker_opts}"]
}
