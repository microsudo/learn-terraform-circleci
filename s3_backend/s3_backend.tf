terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                  = "us-east-1"
  profile                 = "microstack-learner"
}
resource "random_uuid" "randomid" {}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${random_uuid.randomid.result}-backend"
  # Enable versioning so we can see the full revision history of our
  # state filesterraform update
  force_destroy = true
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}
