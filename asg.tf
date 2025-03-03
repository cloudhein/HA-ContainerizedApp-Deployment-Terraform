resource "aws_launch_template" "asg-containerized-app-template" {
  name          = "asg-containerized-app-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = local.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  user_data = base64encode(templatefile("${path.module}/config/run.sh.tftpl", {
    DB_USER     = var.rds_db_username
    DB_PASSWORD = var.rds_db_password
    DB_NAME     = var.rds_db_name
  }))
}


resource "aws_autoscaling_group" "asg-containerized-app" {
  name                      = "asg-containerized-app"
  vpc_zone_identifier       = data.aws_subnets.default_vpc_subnets.ids
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  force_delete              = true
  health_check_grace_period = var.asg_heath_check_grace_period

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.asg-containerized-app-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-containerized-app"
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }
}

# Attach the ASG to the ALB
resource "aws_autoscaling_attachment" "asg-alb-attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg-containerized-app.id
  lb_target_group_arn    = aws_lb_target_group.app_tg.arn
}

# Scale out policy based on CPU utilization 
resource "aws_autoscaling_policy" "asg-scale-out" {
  name        = "asg-scale-out"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_utilization_threshold_percentage
  }
  autoscaling_group_name = aws_autoscaling_group.asg-containerized-app.id
}