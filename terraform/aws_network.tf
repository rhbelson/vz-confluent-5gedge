# Create the VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "wavelength-vpc"
  }
}

# Create subnet in parent region
resource "aws_subnet" "tf_region_subnet" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone_1
  tags = {
    Name = "wavelength-region-subnet"
  }
}

# Create second subnet in parent region
resource "aws_subnet" "tf_region_subnet_2" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone_2
  tags = {
    Name = "wavelength-region-subnet-2"
  }
}

# Create subnet in Wavelength Zone
resource "aws_subnet" "tf_wl_subnet" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.wavelength_zone
  tags = {
    Name = "wavelength-edge-subnet"
  }
}

# Create second subnet in Wavelength Zone
resource "aws_subnet" "tf_wl_subnet_2" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = var.wavelength_zone_2
  tags = {
    Name = "wavelength-edge-subnet-2"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "tf_internet_gw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf Internet Gateway"
  }
}

# Create Carrier Gateway
resource "aws_ec2_carrier_gateway" "tf_carrier_gateway" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf-carrier-gw"
  }
}

# resource "aws_vpc_endpoint" "ec2" {
#   vpc_id            = aws_vpc.tf_vpc.id
#   service_name      = "com.amazonaws.us-east-1.ec2"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.cluster_security_group.id,
#   ]
#   subnet_ids = [
#     aws_subnet.tf_region_subnet.id, aws_subnet.tf_region_subnet_2.id,
#   ]

#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "ecr-dkr" {
#   vpc_id            = aws_vpc.tf_vpc.id
#   service_name      = "com.amazonaws.us-east-1.ecr.dkr"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.cluster_security_group.id,
#   ]
#   subnet_ids = [
#     aws_subnet.tf_region_subnet.id, aws_subnet.tf_region_subnet_2.id,
#   ]

#   private_dns_enabled = true
# }

# resource "aws_vpc_endpoint" "ecr-api" {
#   vpc_id            = aws_vpc.tf_vpc.id
#   service_name      = "com.amazonaws.us-east-1.ecr.api"
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.cluster_security_group.id,
#   ]
#   subnet_ids = [
#     aws_subnet.tf_region_subnet.id, aws_subnet.tf_region_subnet_2.id,
#   ]

#   private_dns_enabled = true
# }