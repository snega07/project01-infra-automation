# Create Launch Template for EKS Node Group
resource "aws_launch_template" "node" {
  for_each = var.node_groups

  name_prefix = "${var.cluster_name}-${each.key}-"
  description = "Launch template for ${var.cluster_name} ${each.key} node group"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = lookup(each.value, "disk_size", 20)
      volume_type           = "gp3"
      iops                  = 3000
      throughput            = 125
      delete_on_termination = true
      encrypted             = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
  #   security_groups             = [aws_security_group.node.id]
   }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.cluster_name}-${each.key}-node"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

# Create EKS Node Group
resource "aws_eks_node_group" "main" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = each.key
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  version         = var.kubernetes_version

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  instance_types = each.value.instance_types
  capacity_type  = lookup(each.value, "capacity_type", "ON_DEMAND")

  labels = lookup(each.value, "labels", {})

  dynamic "taint" {
    for_each = coalesce(lookup(each.value, "taints", null), [])
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  launch_template {
    id      = aws_launch_template.node[each.key].id
    version = aws_launch_template.node[each.key].latest_version
  }

  tags = merge(
    var.tags,
    lookup(each.value, "tags", {})
  )

  # depends_on = [
  #   aws_eks_addon.vpc_cni,
  #   aws_eks_addon.kube_proxy
  # ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# Create EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
    public_access_cidrs     = var.public_access_cidrs
    # security_group_ids      = [aws_security_group.cluster.id]
  }

  # encryption_config {
  #   provider {
  #     key_arn = aws_kms_key.eks.arn
  #   }
  #   resources = ["secrets"]
  # }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # depends_on = [
  #   aws_cloudwatch_log_group.eks
  # ]

  tags = var.tags
}

