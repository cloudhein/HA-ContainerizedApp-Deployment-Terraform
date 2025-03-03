locals {
  instance_type = var.instance_config.instance_type
  instance_name = var.instance_config.instance_name
  environment   = var.instance_config.environment

  anywhere            = "0.0.0.0/0"
  ssh_port            = 22
  all_protocols_ports = "-1"
  tcp_protocol        = "tcp"
  icmp_protocol       = "icmp"
  http_port           = 80

  db_port = 5432

  app_port = 8080
}
