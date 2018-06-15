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
    inline = <<EOF
${data.template_file.install.rendered}
EOF
  }
}

data "template_file" "apt_preference" {
  template = "${file("${path.module}/templates/apt-preference.conf")}"

  vars {
    version = "${var.docker_version}"
  }
}

data "template_file" "install" {
  template = "${file("${path.module}/templates/install.sh")}"

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