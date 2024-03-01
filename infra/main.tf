provider "aws" {
  default_tags {
    tags = {
      project = var.project_name
    }
  }
}

provider "archive" {}
provider "null" {}

terraform {
  backend "s3" {}
}

resource "aws_default_vpc" "default" {}
resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

data "archive_file" "build_code" {
  type        = "zip"
  source_dir  = "${path.module}/../app"
  output_path = "${path.module}/../out/app.zip"
  excludes    = ["**/node_modules/*"]
}
