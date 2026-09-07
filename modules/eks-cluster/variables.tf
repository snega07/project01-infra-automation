variable cluster_name {
type = string
}

variable tags {
type = map(string)
}


variable node_role_arn {
type = string
}

variable cluster_role_arn {
type = string
}
variable subnet_ids {
type = list(string)
}

variable kubernetes_version{
type = string
}

variable endpoint_public_access{
type = bool
}

variable endpoint_private_access{
type = bool
}
    
variable public_access_cidrs{
type = list(string)
}

variable node_groups {
    type = map(object({
        desired_size   = number
        max_size       = number
        min_size       = number
        instance_types = list(string)
        capacity_type  = optional(string, "ON_DEMAND")
        labels         = optional(map(string), {})
        taints         = optional(list(object({
            key    = string
            value  = string
            effect = string
        })), [])
        tags           = optional(map(string), {})
    }))
}

