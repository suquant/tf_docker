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