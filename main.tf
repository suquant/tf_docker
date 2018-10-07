variable "count" {}

variable "connections" {
  type = "list"
}

variable "docker_version" {
  default = "17.03"
}

variable "docker_opts" {
  type = "list"
  default = []
}


resource "null_resource" "docker" {
  count = "${var.count}"

  connection {
    host  = "${element(var.connections, count.index)}"
    user  = "root"
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "modprobe br_netfilter && echo br_netfilter > /etc/modules-load.d/br_netfilter.conf",
      "[ -d /etc/systemd/system/docker.service.d ] || mkdir -p /etc/systemd/system/docker.service.d",
    ]
  }

  provisioner "file" {
    destination = "/etc/systemd/system/docker.service.d/10-docker-opts.conf"
    content     = "${data.template_file.docker_opts.rendered}"
  }

  provisioner "file" {
    destination = "/etc/apt/preferences.d/docker"
    content     = "${data.template_file.apt_preference.rendered}"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -",
      "echo \"deb [arch=amd64] https://download.docker.com/linux/$$(. /etc/os-release; echo \"$ID\") $$(lsb_release -cs) stable\" > /etc/apt/sources.list.d/docker-ce.list",
      "apt update",
      "DEBIAN_FRONTEND=noninteractive apt install -yq docker-ce",
      "systemctl daemon-reload",
      "systemctl restart docker.service"
    ]
  }
}

data "template_file" "apt_preference" {
  template = "${file("${path.module}/templates/apt-preference.conf")}"

  vars {
    version = "${var.docker_version}"
  }
}

data "template_file" "docker_opts" {
  template = "${file("${path.module}/templates/docker-opts.conf")}"

  vars {
    opts = "${join(" ", var.docker_opts)}"
  }
}

output "public_ips" {
  value = ["${var.connections}"]

  depends_on = ["null_resource.docker"]
}

output "iptables_filter_chains" {
  value = ["DOCKER", "DOCKER-ISOLATION"]

  depends_on = ["null_resource.docker"]
}

output "iptables_nat_chains" {
  value = ["DOCKER", "DOCKER-ISOLATION"]

  depends_on = ["null_resource.docker"]
}