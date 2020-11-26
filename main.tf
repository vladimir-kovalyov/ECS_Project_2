
terraform {
    required_version = "~> 0.13.5"
}

##################################################################################
# MODULE - NETWORK
##################################################################################

module "network" {
  source = "./modules/network"

  vpc_cidr              = var.vpc_cidr
  for_tag_name          = var.for_tag_name
}

##################################################################################
# VARIABLES
##################################################################################

// variable "max_size" {}
// variable "min_size" {}
// variable "desired_capacity" {}
// variable "instance_type" {}
// variable "ecs_aws_ami" {}