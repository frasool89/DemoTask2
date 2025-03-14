resource "aws_launch_configuration" "DemoTask" {
  name_prefix     = "${var.project_name}-asg"
  image_id        = "ami-08b5b3a93ed654d19"
  instance_type   = "t2.micro"
  #user_data       = filebase64("userdata.sh")
  security_groups = [var.ec2-sg-id]
  

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "DemoTask"
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.DemoTask.name
  vpc_zone_identifier  = [var.public_subnet_az1, var.public_subnet_az2]
  target_group_arns = [var.alb_target_group]
  #load_balancers  = [var.alb-id]
  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "DemoTask-ASG"
    propagate_at_launch = true
  }
}


#resource "aws_autoscaling_attachment" "DemoTask" {
  #autoscaling_group_name = aws_autoscaling_group.DemoTask.id
  #}