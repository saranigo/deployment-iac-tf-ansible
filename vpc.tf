resource "aws_vpc" "my_app" {
 cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Environment = "${terraform.workspace}"
    Name        = "JavaHomeVpc"
  }
}
