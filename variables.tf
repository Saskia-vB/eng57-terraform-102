variable "vpc_id" {
  type = string
  #default= "vpc-08039043ffb902e94"
  #default= "vpc-0733dd8d62bc3d5eb" - this one worked
  default = "vpc-056c10bb21195dece"
  #default= "vpc-0f6df61e3d6234398" - no longer exists
}

variable "name" {
  type = string
  default= "Eng57.Saskia.B."
}

variable "ami-web" {
  type = string
  default= "ami-02d2b7951e241ed22"
  #default = "ami-00b48f09c568b0014"
}

variable "ami-db" {
  type = string
  #default= "ami-07841f7191c6c162c"
  default = "ami-03b13f993274ce14a"
  #default = "ami-09dfae1594679f82d"
}
