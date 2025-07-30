terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# EC2 instance for a web server
resource "aws_instance" "web_server_production" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  key_name      = "my-key-pair"
  monitoring    = true

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
    encrypted   = true
  }
}

# EC2 instance for a API server
resource "aws_instance" "web_server_staging" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.small"
  key_name      = "my-key-pair"
  monitoring    = true

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    encrypted   = true
  }
}

# RDS instance for a production database
resource "aws_db_instance" "production_db" {
  identifier        = "production-db"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "production_db"
  username          = "admin"
  password          = "SecurePassword123!"

  tags = {
    Name        = "production-db"
    Environment = "production"
  }
}

# RDS instance for staging database
resource "aws_db_instance" "staging_db" {
  identifier        = "staging-db"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 10
  db_name           = "staging_db"
  username          = "admin"
  password          = "StagingPassword123!"

  tags = {
    Name        = "staging-db"
    Environment = "staging"
  }
} 