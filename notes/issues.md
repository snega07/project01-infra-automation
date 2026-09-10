1) EKS control plane issue joining with worker node.

 - When NAT gateway was not added. Since worker nodes are created in private subnet. This worker node need to communicate with other AWS services(to assume role like sts, role, policy) in order to join with the control plane node. For this communication to succeed we must either have VPC endpoint for private access and NAT gateway for access via internet.

 We need enable private/public access endpoint using vpc_config block in eks cluster resource definition.

 "The EKS vpc_config defines the networking configuration for the EKS cluster, including the subnets associated with the cluster and whether the Kubernetes API endpoint is accessible privately, publicly, or both. public_access_cidrs restricts which source CIDRs can access the public API endpoint. The managed node group's subnet_ids separately determine where the worker EC2 instances are launched. For private worker nodes, outbound access to required AWS services can be provided through a NAT Gateway or appropriate VPC endpoints."

 The EKS API endpoint is the network endpoint through which clients/workers communicate with the Kubernetes API server.

Think of it as the address of the Kubernetes API server.

For example, EKS gives you an endpoint conceptually like:

https://xxxxx.eks.amazonaws.com -> API server

______________________________________________________________________________________________