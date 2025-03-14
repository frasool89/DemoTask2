output "alb-sg-id" {
 value  =  aws_security_group.alb_security_group.id
}


output "ec2-sg-id" {
 value  =  aws_security_group.ec2_security_group.id
}