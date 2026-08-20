variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet" {
    description = "public subnet CIDR"
    type = map(object({
        cidr_block = string
        az         = string
    }))
}

variable "private_subnet" {
    description = "private subnet CIDR"
    type = map(object({
        cidr_block = string
        az         = string
    }))
}

variable "rds_subnet" {
   description = "rds subnet CIDR"
   type = map(object({
    cidr_block = string
    az         = string
   }))
}