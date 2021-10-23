resource "aws_s3_bucket" "my_bucket" {
  bucket = "$var.myapp_s3_bucket"
  acl    = "private"

  tags = {
    Name        = "jenkins-dev"
    Environment = "${terraform.workspace}"
  }
}
