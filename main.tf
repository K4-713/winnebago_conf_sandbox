# Remeber: Variables not obviously populated here are automagically coming from 
# the terraform.tfvars file

variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "instance_ami" {}


provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region  = "${var.region}"
}

resource "aws_instance" "example" {
  ami           = "${var.instance_ami}"
  instance_type = "t2.micro"
}