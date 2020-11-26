variable "region" {
    default = "eu-west-1"
}

variable "ami" {
    default = "ami-014ce76919b528bff"
}
variable "instance_type" {
    default = "t2.micro"
}

variable "vlc_cidr" {
    default = "192.168.0.0/16"
}
variable "subnet_one" {
    default = "192.168.1.0/24"
}
variable "subnet_two" {
    default = "192.168.2.0/24"
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}

variable "aval_zone_one" {
    default = "eu-west-1a"
}

variable "aval_zone_two" {
    default = "eu-west-1b"
}