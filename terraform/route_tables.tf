# Create the Route Table for Region
resource "aws_route_table" "region_route_table" {
  vpc_id = aws_vpc.tf-vpc.id
  tags = {
    Name = "Region Route Table"
  }
}

# Create the Route Table for Wavelength Zone
resource "aws_route_table" "WLZ_route_table" {
  vpc_id = aws_vpc.tf-vpc.id
  tags = {
    Name = "Wavelength Zone Route Table"
  }
}

# Setup Region Route
resource "aws_route" "region_route" {
  route_table_id         = aws_route_table.region_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tf_internet_gw.id
}

# Associate Route Table with subnet
resource "aws_route_table_association" "region_route_association" {
  subnet_id      = aws_subnet.tf_region_subnet.id
  route_table_id = aws_route_table.region_route_table.id
}

# Associate Route Table with second subnet
resource "aws_route_table_association" "region_route_association_2" {
  subnet_id      = aws_subnet.tf_region_subnet_2.id
  route_table_id = aws_route_table.region_route_table.id
}


# Setup WLZ Route Table
resource "aws_route" "WLZ_route" {
  route_table_id         = aws_route_table.WLZ_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  carrier_gateway_id     = aws_ec2_carrier_gateway.tf_carrier_gateway.id
}

# Associate Route Table with subnet for WLZ
resource "aws_route_table_association" "WLZ_route_association" {
  subnet_id      = aws_subnet.tf_wl_subnet.id
  route_table_id = aws_route_table.WLZ_route_table.id
}
