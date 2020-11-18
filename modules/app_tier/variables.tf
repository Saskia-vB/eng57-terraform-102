## App variables

variable "vpc_id" {
  description = "the vpc we want it to launch instances"
  # type = string
  # default= "vpc-08039043ffb902e94"
}

variable "name" {
  description = "rootname based on naming convention"
}

variable "my-ip" {
  description = "local IP to create secure port 22 connection with resources"
}

variable "internet_gateway_id" {
  description = "IP of internet gateway"
}

variable "db_private_ip" {
  description = "private ip for db"
}

variable "ami-web" {
  description = "ami for the webapp"
}

variable "ssh_key_var" {
  description = "secret ssh key"
}
