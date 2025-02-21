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

# TODO: count must dynamic based on the number of subnets
resource "aws_eip" "nateips" {
  count  = 3
  domain = "vpc"
}

resource "aws_nat_gateway" "ngws" {
  for_each = {
    for idx, subnet_id in keys(data.aws_subnet.public_subnets) :
    subnet_id => {
      nateip = aws_eip.nateips[idx].id
    }
  }
  allocation_id = each.value.nateip
  subnet_id     = each.key
  depends_on    = [data.aws_internet_gateway.igw]
}

resource "aws_subnet" "private_subnets" {
  for_each = {
    for idx, subnet_id in keys(data.aws_subnet.public_subnets) :
    subnet_id => {
      az = data.aws_subnet.public_subnets[subnet_id].availability_zone
      index  = idx
    }
  }
  vpc_id            = aws_default_vpc.default.id
  cidr_block        = local.private_cidr_blocks[each.value.index]
  availability_zone = each.value.az
  tags = {
    Name         = "${each.key} Related Private Subnet"
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

resource "aws_route_table" "privates" {
  for_each = aws_subnet.private_subnets
  vpc_id = aws_default_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngws[each.key].id
  }
}


resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.privates[each.key].id
}
