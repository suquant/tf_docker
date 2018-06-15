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