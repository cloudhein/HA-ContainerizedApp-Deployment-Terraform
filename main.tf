data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#resource "aws_instance" "web" {
#  count = var.create_instances ? var.instance_count : 0
#
#  ami                    = data.aws_ami.ubuntu.id
#  instance_type          = local.instance_type
#  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
#  subnet_id              = element(data.aws_subnets.default_vpc_subnets.ids, count.index) # create instances in different subnets
#
#  tags = {
#    Name        = "${local.instance_name}-${count.index + 1}"
#    Environment = local.environment
#  }
#
#
#  user_data = templatefile("${path.module}/config/run.sh.tftpl", {
#    DB_USER     = var.rds_db_username
#    DB_PASSWORD = var.rds_db_password
#    DB_NAME     = var.rds_db_name
#  })
#
#  user_data_replace_on_change = true
#}

# Create a Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow SSH and APP inbound and all outbound"
  vpc_id      = data.aws_vpc.default_vpc.id

  tags = {
    Name = "ec2_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_rules" {
  security_group_id = aws_security_group.ec2_sg.id

  cidr_ipv4   = local.anywhere
  from_port   = local.ssh_port
  ip_protocol = local.tcp_protocol
  to_port     = local.ssh_port
}

resource "aws_vpc_security_group_ingress_rule" "allow_app_rules" {
  security_group_id = aws_security_group.ec2_sg.id

  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = local.app_port
  ip_protocol                  = local.tcp_protocol
  to_port                      = local.app_port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = local.anywhere
  ip_protocol       = local.all_protocols_ports # semantically equivalent to all ports
}