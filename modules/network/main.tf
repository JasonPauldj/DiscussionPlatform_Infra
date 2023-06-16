data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc-cidr-block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dp-vpc"
  }
}

resource "aws_subnet" "publicsubnets" {
  count                   = var.no-public-subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr-subnets[count.index]
  availability_zone_id    = data.aws_availability_zones.available.zone_ids[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "dp-public-subnet"
  }
}

resource "aws_subnet" "privatesubnets" {
  count                = var.no-private-subnets
  vpc_id               = aws_vpc.main.id
  cidr_block           = var.cidr-subnets[count.index + var.no-public-subnets]
  availability_zone_id = data.aws_availability_zones.available.zone_ids[count.index]

  tags = {
    Name = "dp-private-subnet"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-rt"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "pub-route" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "pub-sub-rt-assoc" {
  count          = var.no-public-subnets
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.publicsubnets[count.index].id
}

resource "aws_security_group" "dp-app-sg" {
  name        = "dp-app-sg"
  description = "This SG allows application to receive traffic on port 8080"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "App-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "lb-app-ingress" {
  security_group_id            = aws_security_group.dp-app-sg.id
  referenced_security_group_id = aws_security_group.lb-sg.id
  from_port                    = var.server-port
  to_port                      = var.server-port
  ip_protocol                  = "tcp"
  description                  = "Allows traffic to port 8080 from the load balancer sg"
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.dp-app-sg.id
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allows all outbound traffic"
}

resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "This SG allows MySQL db to receive traffic on port 3306"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "Db-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db-ingress" {
  security_group_id            = aws_security_group.db-sg.id
  referenced_security_group_id = aws_security_group.dp-app-sg.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  description                  = "Allows TCP traffic to port 3306"
}

resource "aws_security_group" "lb-sg" {
  name        = "lb-sg"
  description = "This SG allows LB to receive HTTP traffic on port 80"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "lb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "lb-ingress" {
  security_group_id = aws_security_group.lb-sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allows TCP traffic to port 80"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "lg-egress" {
  security_group_id = aws_security_group.lb-sg.id
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allows all outbound traffic"
}