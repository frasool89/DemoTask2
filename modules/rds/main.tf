# configured aws provider with proper credentials
provider "aws" {
  region  = "us-east-1"
  }


# create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "database security group"
  description = "enable mysql access on port 3306"
  vpc_id      = var.vpc_id

  ingress {
    description      = "mysql/aurora access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [var.ec2-sg-id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "database security group"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group"{
  name       = "rds_subnet_group"
  subnet_ids = [var.private_data_subnet_az1,var.private_data_subnet_az2]

  tags = {
    Name = "rds_subnet_group"
  }
}

# create the rds instance
resource "aws_db_instance" "db_instance" {
  engine                  = "mysql"
  engine_version          = "8.0.40"
  multi_az                = false
  identifier              = "demo-rds"
  username                = "frasool"
  password                = "faizan89"
  instance_class          = "db.t3.micro"
  allocated_storage       = 200
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.database_security_group.id]
  #availability_zone       = 
  db_name                 = "applicationdb"
  skip_final_snapshot     = "true"
}