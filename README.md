# Docker service module for terraform

## Interfaces

### Input variables

* count - count of connections
* connections - public ips where applied
* docker_version - version (default: 17.03)
* docker_opts - docker daemon extra options (example: ["--iptables=false", "--ip-masq=false"]) (default: [])

### Output variables

* public_ips - public ips
* iptables_filter_chains - iptables filter chains created by docker
* iptables_nat_chains - iptables nat chains created by docker


## Example

```
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
  source = "git::https://github.com/suquant/tf_hcloud.git?ref=v1.1.0"

  count = "${var.hosts}"
}

module "docker" {
  source = "git::https://github.com/suquant/tf_docker.git?ref=v1.0.1"

  count       = "${var.hosts}"
  connections = "${module.provider.public_ips}"

  docker_opts = ["${var.docker_opts}"]
}

```
