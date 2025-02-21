resource "aws_default_vpc" "default" {}

data "aws_internet_gateway" "igw" {
  internet_gateway_id = var.internet_gateway_id
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

locals {
  private_cidr_blocks = [
    "172.31.48.0/20",
    "172.31.64.0/20",
    "172.31.80.0/20",
  ]
}

data "aws_subnet" "public_subnets" {
  for_each = toset(data.aws_subnets.public_subnets.ids)
  id       = each.value

  depends_on = [data.aws_subnets.public_subnets]
}

resource "aws_eip" "nateip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nateip.id
  subnet_id     = data.aws_subnets.public_subnets.ids[0]
  depends_on    = [data.aws_internet_gateway.igw]
}

resource "aws_subnet" "private_subnets" {
  for_each = {
    for idx, subnet_id in keys(data.aws_subnet.public_subnets) :
    subnet_id => {
      subnet = data.aws_subnet.public_subnets[subnet_id]
      index  = idx
    }
  }
  vpc_id            = aws_default_vpc.default.id
  cidr_block        = local.private_cidr_blocks[each.value.index]
  availability_zone = each.value.subnet.availability_zone
  tags = {
    Name = "${each.key} Related Private Subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_default_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  for_each       = data.aws_subnet.public_subnets
  subnet_id      = each.key
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_default_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
}


resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
