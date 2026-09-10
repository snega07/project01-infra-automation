### EKS Setup -> Control plane and Worker Node:

                    AWS
                     │
             ┌───────┴────────┐
             │   EKS Cluster  │
             │ Control Plane  │
             └───────┬────────┘
                     │
              EKS Cluster IAM Role
              ├── AmazonEKSClusterPolicy
              |__ AmazonEKSVPCResourceController
              |
              └── (other required permissions as applicable)
                     │
                     ▼
              Managed Node Group
                     │
              Launch Template
                     │
              ┌──────┴──────┐
              │ EC2 Worker  │
              │    Node     │
              └──────┬──────┘
                     │
              Root EBS (gp3)
              e.g. 20 GiB
                     │
                     ▼
              Worker Node IAM Role
              ├── AmazonEKSWorkerNodePolicy
              ├── AmazonEC2ContainerRegistryPullOnly
              └── AmazonEKS_CNI_Policy




IMDS
EC2 → IMDS → temporary credentials → EC2 IAM role → AWS


IRSA
Pod → OIDC identity token → AssumeRoleWithWebIdentity
    → temporary credentials → IAM role → AWS


Pod Identity
Pod → ServiceAccount → Pod Identity association/agent
    → temporary credentials → IAM role → AWS

IRSA = OIDC token + AssumeRoleWithWebIdentity

Pod Identity = EKS-managed Pod-to-IAM-role association

IMDS = EC2 metadata service that delivers credentials for the EC2 IAM role

                    EKS Cluster
                         │
          ┌──────────────┴──────────────┐
          │                             │
    Production Node Group          Spot Node Group
       ON_DEMAND                       SPOT
          │                             │
    Critical APIs                 Batch workloads
    Databases                     CI/CD workers
    Core services                  Stateless apps
    