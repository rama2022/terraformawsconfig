provider "aws" {
  access_key = "AWS_ACCESS_KEY_ID"
  secret_key = "AWS_SECRET_ACCESS_KEY"
  region     = "us-east-1"
}


resource "aws_vpc" "rama-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-vpc"
  }
}


resource "aws_subnet" "rama-public-subnet" {
    vpc_id = aws_vpc.rama-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {

        Name = "terraform-public-subnet"
    }

}

resource "aws_route_table" "rama-public-route" {
vpc_id = aws_vpc.rama-vpc.id
 tags = {
   Name = "terraform-public-route"
  }
} 


resource "aws_internet_gateway" "rama-igw" {
 vpc_id = aws_vpc.rama-vpc.id
 tags = {
        Name = "terraform-igw"
  }
} 



resource "aws_route" "rama-internet-access" {
  route_table_id = aws_route_table.rama-public-route.id
  destination_cidr_block = "0.0.0.0/0" 
  gateway_id = aws_internet_gateway.rama-igw.id

} 


resource "aws_route_table_association" "rama-subnet-association" {
  subnet_id = aws_subnet.rama-public-subnet.id
  route_table_id = aws_route_table.rama-public-route.id
} 


resource "aws_instance" "rama-ubuntu" {
  ami                    = "ami-085925f297f89fce1"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.rama-public-subnet.id
  key_name               = "terraform-key"

  tags = {
    Name = "rama-Ubuntu"
    }
}