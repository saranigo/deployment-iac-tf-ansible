variable "vpc_cidr" {
  description = "choose cidr for vpc"
  default     = "10.20.0.0/16"
}

variable "region" {
 default = "us-east-2"
}

variable "nat_amis" {
 type = map
 default = {
   us-east-2 = "ami-0d563aeddd4be7fff"
   us-east-1 = "ami-0ee02acd56a52998e"}
}

variable "Jenkins_instance_type" {
  description = "Choose instance type for the Jenkins"
  type = string
  default = "t3.micro"
}

variable "Jenkins_tags" {
 type = map
 default = {
  Name = "Jenkins-server"
}
}

variable "jenkins_web_amis" {
 type = map
 default = {
   us-east-2 = "ami-0d563aeddd4be7fff"
   us-east-1 = "ami-0ee02acd56a52998e"}
}

variable "Jenkins_ec2_count" {
 description = "Total no of ec2 instance"
 type = string
 default = "2"
}

variable "my_app_s3_bucket" {
 default = "jenkins-dev"
}
