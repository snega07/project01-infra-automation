vpc_cidr = "10.0.0.0/16"
public_subnet = {
    az1 = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-south-1a"
    }
    az2 = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-south-1b"
    }
}
private_subnet = {
    az1 = {
      cidr_block = "10.0.3.0/24"
      az         = "ap-south-1a"
    }
    az2 = {
      cidr_block = "10.0.4.0/24"
      az         = "ap-south-1b"
    }
}

rds_subnet = {
    az1 = {
      cidr_block = "10.0.5.0/24"
      az         = "ap-south-1a"
    }
    az2 = {
      cidr_block = "10.0.6.0/24"
      az         = "ap-south-1b"
    }
}
