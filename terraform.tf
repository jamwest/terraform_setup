terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  ### Comment out this block on first run
  backend "s3" {
    bucket = "jamwest-terraform"
    key = "terraform_setup/terraform.tfstate"
    region = "ap-southeast-2"
    dynamodb_table = "terraform_state_lock"
  }
  
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "${var.account_name}-terraform"
}

resource "aws_s3_bucket_versioning" "enable_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "enable_server_side_encryption" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform_state_lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "terraform_s3_state_bucket" {
  value = aws_s3_bucket.terraform_state_bucket.id
}

output "terraform_dynamodb_state_lock_table" {
  value = aws_dynamodb_table.terraform_state_lock.id
}