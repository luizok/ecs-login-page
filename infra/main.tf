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

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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
