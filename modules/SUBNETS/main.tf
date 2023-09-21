resource "aws_subnet" "pub_subnet_1" {
    vpc_id = var.vpc_id
    cidr_block = var.cidr_block[1]
    tags = {Name = "pub_subnet_1"
    env = "${terraform.workspace}"}
    availability_zone = var.availability_zone[0]
}
resource "aws_subnet" "pub_subnet_2" {
    vpc_id = var.vpc_id
    cidr_block = var.cidr_block[2]
    tags = {
        Name = "pub_subnet_2"
    env = "${terraform.workspace}"}
    availability_zone = var.availability_zone[1]
}
resource "aws_subnet" "pri_subnet_1" {
    vpc_id = var.vpc_id
    cidr_block = var.cidr_block[3]
    tags = {Name = "pri_subnet_1"
    env = "${terraform.workspace}"}
    availability_zone = var.availability_zone[0]
}
resource "aws_subnet" "pri_subnet_2" {
    vpc_id = var.vpc_id
    cidr_block = var.cidr_block[4]
    tags = {Name = "pri_subnet_2"
    env = "${terraform.workspace}"}
    availability_zone = var.availability_zone[1]
}

