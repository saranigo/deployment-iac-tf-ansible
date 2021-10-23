#Dynamically allocate the subnets with the availabilty zones
locals{
 az_names = "${data.aws_availability_zones.azs.names}"
 pub_sub_ids = "${aws_subnet.public.*.id}"
}

#Create a subnet and assign a public ip address to the instance
resource "aws_subnet" "public" {
  count = "${length(local.az_names)}"
  vpc_id     = aws_vpc.my_app.id
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8,count.index)}"
  availability_zone = "${data.aws_availability_zones.azs.names[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

#Create Internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_app.id

  tags = {
    Name = "JavaHomeIgw"
  }
}


#Create Public route table for subnet
resource "aws_route_table" "prt" {
  vpc_id = aws_vpc.my_app.id
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "JavaHomeroutetable"
  }
}

#Dynamically Subnet route table association
resource "aws_route_table_association" "pub_sub_association" {
  count          = "${length(local.az_names)}"
  subnet_id      = "${local.pub_sub_ids[count.index]}"
  route_table_id = aws_route_table.prt.id
}
