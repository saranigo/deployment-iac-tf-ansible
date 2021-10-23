#Dynamically allocate the subnets with the availabilty zones
locals{
 az_name = "${data.aws_availability_zones.azs.names}"
 pub_sub_id = "${aws_subnet.private.*.id}"
}

#Create private subnet with slice for sublist
resource "aws_subnet" "private" {
  count = "${length(slice(local.az_name, 0 , 2))}"
  vpc_id     = aws_vpc.my_app.id
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8,count.index + length(local.az_name))}"
  availability_zone = "${local.az_name[count.index]}"

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}

#nat instance configured to access internet from private subnet
resource "aws_instance" "nat" {
  ami           = "${var.nat_amis[var.region]}"
  instance_type = "t3.micro"
  subnet_id = "${local.pub_sub_id[0]}"
  source_dest_check = false
  vpc_security_group_ids = ["${aws_security_group.nat_sg.id}"]
  tags = {
    Name = "JavaHomeNat"
  }
}

#Create Public route table for subnet
resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.my_app.id
   route {
    cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.nat.id
  }
  tags = {
    Name = "JavaHomeprivateroutetable"
  }
}

#Dynamically Subnet route table association
resource "aws_route_table_association" "private_rt_association" {
  count          = "${length(slice(local.az_name, 0 ,2))}"
  subnet_id      = "${local.pub_sub_id[count.index]}"
  route_table_id = aws_route_table.privatert.id
}

#configure outgoing security group
resource "aws_security_group" "nat_sg" {
  name        = "nat_sg"
  description = "Allow Traffic for private subnets"
  vpc_id      = aws_vpc.my_app.id

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  tags = {
    Name = "allow_tls"
  }
}
