
#create dynamodb
resource "aws_dynamodb_table" "statelock" {
  name = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    
    name = "LockID"
    type = "S"
  }
  
}

# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "demobucketfr89"
    
    
    key       = "Demotask.tfstate"
    region    = "us-east-1"
    encrypt = true
    #profile   = "terraform-user"
  }
}