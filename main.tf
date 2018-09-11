# Remember: Variables not obviously populated here are automagically coming from 
# the terraform.tfvars file

variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "instance_ami" {}
variable "test_domain" {}
variable "prod_domain" {}
variable "deployers_group_arn" {}
variable "deployer_username" {}
variable "deployer_key" {}
variable "s3_prefix" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region  = "${var.region}"
}


/***
*    EC2 Servers
***/

module "ec2_deploy" {
  source  = "./modules/ec2_deploy"
  instance_ami = "${var.instance_ami}"
  deployer_username = "${var.deployer_username}"
  deployer_key = "${var.deployer_key}"
}


/***
*   S3 buckets (folders)
***/

# code staging folder - private
resource "aws_s3_bucket" "staging" {
  bucket = "${var.s3_prefix}-staging"
  acl    = "private"
}

# test site files
resource "aws_s3_bucket" "test-site" {
  bucket = "${var.s3_prefix}-test-site"
  acl    = "private"
}

# prod site files
resource "aws_s3_bucket" "prod-site" {
  bucket = "${var.s3_prefix}-prod-site"
  acl    = "private"
}

# logs go here. I intend to have a folder for test site logs, prod site logs, 
# and deploy script logs
resource "aws_s3_bucket" "logs" {
  bucket = "${var.s3_prefix}-logs"
  acl    = "private"
}


