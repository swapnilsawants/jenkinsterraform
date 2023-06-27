terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
		}
	}
}
provider "aws" {
	region = "ap-south-1"
	profile = "default"
}
resource "aws_vpc" "fithealth2vpc" {
	cidr_block = "10.0.0.0/16"
	tags = {
		Name = "fithealth2vpc"
	}
}
resource "aws_subnet" "fithealth2subnet" {
	cidr_block = "10.0.1.0/24"
	vpc_id = aws_vpc.fithealth2vpc.id 
	tags = {
		Name = "fithealth2subnet"
	}
}
resource "aws_security_group" "fithealthec2sg" {
	vpc_id = aws_vpc.fithealth2vpc.id
	ingress {
		from_port = 22
		to_port = 22
		protocol = "ssh"
		cidr_blocks = ["10.0.0.0/16"]
		
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = -1
		cidr_blocks = ["0.0.0.0/0"]
	}
}
resource "aws_key_pair" "fithealth2kp" {
	key_nm = "jkp"
	public_key = ""
}
resource "aws_instance" "fithealth2ec2" {
	subnet_id = aws_subnet.fithealth2subnet.id
	vpc_security_group_ids = ["aws_security_group.fithealthec2sg.id"]
	instance_type = "t2.micro"
	ami = "ami-0f5ee92e2d63afc18"
	key_name = aws_key_pair.fithealth2kp.key_nm
}