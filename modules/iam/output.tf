output cluster_role_arn {
  value = aws_iam_role.EKS_Cluster.arn
}

output node_role_arn {
  value = aws_iam_role.node_group.arn
}