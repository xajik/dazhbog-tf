resource "aws_security_group" "default_sg" {
  name        = "default_security_group"
  description = "Default security group that allows inbound and outbound traffic"
  vpc_id      = aws_vpc.shared_vpc.id

  ingress {
    description      = "Allow HTTP Traffic in VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = local.cloudflare_ipv4_cidr_blocks
    ipv6_cidr_blocks = local.cloudflare_ipv6_cidr_blocks
  }

  ingress {
    description      = "Allow HTTPS Traffic in VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = local.cloudflare_ipv4_cidr_blocks
    ipv6_cidr_blocks = local.cloudflare_ipv6_cidr_blocks
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet_a.cidr_block, aws_subnet.public_subnet_b.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block_internet]
  }
}
