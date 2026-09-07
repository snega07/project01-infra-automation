When you create a VPC, AWS automatically creates a main route table:

When we don't associate any route table to the subnet. The subnet will get associated with the VPC main route table.

VPC: 10.0.0.0/16
       │
       └── Main Route Table (automatically created)
              │
              └── 10.0.0.0/16 → local
              