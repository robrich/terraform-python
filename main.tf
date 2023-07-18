provider "aws" {
  region = "us-east-1"
}

data "external" "archive_prepare" {
  program = ["python.exe", "${path.module}/hello.py"]
  #program = ["node.exe", "${path.module}/hello.js"]
  query = {
    id = "abc123"
  }
}

resource "aws_s3_bucket" "history" {
  bucket = data.external.archive_prepare.result.bucket
}
