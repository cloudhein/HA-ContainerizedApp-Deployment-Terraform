output "vpc_id" {
  description = "ID of default VPC"
  value       = data.aws_vpc.default_vpc.id
  sensitive   = false
}

output "subnet_ids" {
  description = "IDs of default VPC subnets"
  value       = data.aws_subnets.default_vpc_subnets.ids
  sensitive   = false
}

#output "public_ip" {
#  description = "Public IP addresses of the instances"
#  value       = aws_instance.web[*].public_ip
#  sensitive   = false
#}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.app-lb.dns_name
  sensitive   = false
}