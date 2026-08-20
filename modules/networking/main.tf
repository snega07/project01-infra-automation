locals {
  single_nat_key = var.single_nat ? var.single_nat_subnet_key : null
  nat_map        = var.enable_nat ? (var.single_nat ? toset([local.single_nat_key]) : toset(keys(var.private_subnet))) : toset([])
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = var.tags
}

resource "aws_subnet" "private" {
  for_each = var.private_subnet
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(var.tags, { Name = "Private_Subnet_${each.key}" })
}

resource "aws_subnet" "public" {
  for_each = var.public_subnet
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(var.tags, {Name = "Public_Subnet_${each.key}" })


}

resource "aws_subnet" "rds_subnet" {
  for_each = var.rds_subnet
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.az
  tags = merge(var.tags, { Name = "RDS_Subnet_${each.key}" })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = var.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = var.tags
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
  
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnet
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id

}

resource "aws_eip" "nat" {
  for_each = local.nat_map
  domain   = "vpc" 
  tags = merge(var.tags, { Name = "EIP for ${each.key}" })
}

resource "aws_nat_gateway" "nat_gw" {
  for_each = local.nat_map
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(var.tags, { Name = "NAT Gateway for ${each.key}" })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private" {
  for_each = var.enable_nat ? local.nat_map : toset(keys(var.private_subnet))
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.enable_nat ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gw[each.key].id
    }
  }

  tags = merge(var.tags, { Name = "Private Route Table for ${each.key}" })
}

resource "aws_route_table_association" "private" {
  for_each       = var.private_subnet
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[var.enable_nat && var.single_nat ? local.single_nat_key : each.key].id
}

