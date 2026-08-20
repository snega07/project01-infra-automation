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

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "enable_nat" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = false
}

variable "single_nat_subnet_key" {
  description = "The private subnet key to place the single NAT Gateway in (required when single_nat = true)"
  type        = string
  default     = null
}

variable "single_nat" {
  description = "Whether to create a single NAT Gateway in the specified"
  type = bool
  default = false
  }