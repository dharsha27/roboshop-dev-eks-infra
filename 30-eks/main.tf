module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  #name               = local.common_name
  name               = var.project
  kubernetes_version = var.eks_version

  # Mandatory
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute        = true
      enable_network_policy = true
    }
    metrics-server = {}
  }

  # Optional
  endpoint_private_access = true
  endpoint_public_access  = false

  #By default admin access will be granted for who created it
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  create_node_security_group = false
  create_security_group      = false

  node_security_group_id = local.eks_node_sg_id
  security_group_id      = local.eks_control_plane_sg_id


  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    blue = {
      create             = var.enable_blue
      kubernetes_version = var.blue_version
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type = "AL2023_x86_64_STANDARD"
      # instance_types = ["t3.small","t3.medium","m5.xlarge","m4.xlarge"]
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"

      iam_role_additional_policies = {
        EBS = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
        EFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
      }
      min_size     = 1
      max_size     = 1
      desired_size = 1

      # This is required AWS LoadBalancerController
      metadata_options = {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 2
        http_tokens                 = "required"
      }

      labels = {
        nodegroup = "blue"
      }
    }

    green = {
      create             = var.enable_green
      kubernetes_version = var.green_version
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      # instance_types = ["t3.small", "t3.medium", "m5.xlarge", "m4.xlarge"]
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"

      iam_role_additional_policies = {
        EBS = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
        EFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
      }
      min_size     = 1
      max_size     = 1
      desired_size = 1

      # This is required AWS LoadBalancerController
      metadata_options = {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 2
        http_tokens                 = "required"
      }

      labels = {
        nodegroup = "green"
      }
    }
  }

  tags = local.common_tags
}



# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 21.0"

#   name               = var.project
#   kubernetes_version = var.eks_version

#   addons = {
#     coredns = {}

#     eks-pod-identity-agent = {
#       before_compute = true
#     }

#     kube-proxy = {}

#     vpc-cni = {
#       before_compute         = true
#       enable_network_policy  = true
#     }

#     metrics-server = {}

#     aws-ebs-csi-driver = {}
#   }

#   # Easier for a learning lab
#   endpoint_public_access  = true
#   endpoint_private_access = true

#   # Restrict this to your public IP
#  endpoint_public_access_cidrs = [
#   "${chomp(data.http.my_public_ip.response_body)}/32"
# ]
#   # cidr_blocks = [""]

#   enable_cluster_creator_admin_permissions = true

#   vpc_id                   = local.vpc_id
#   subnet_ids               = local.private_subnet_ids
#   control_plane_subnet_ids = local.private_subnet_ids

#   create_node_security_group = false
#   create_security_group      = false

#   node_security_group_id = local.eks_node_sg_id
#   security_group_id      = local.eks_control_plane_sg_id

#   eks_managed_node_groups = {
#     blue = {
#       create             = var.enable_blue
#       kubernetes_version = var.blue_version

#       ami_type = "AL2023_x86_64_STANDARD"

#       instance_types = [
#         "t3.small"
#       ]

#       capacity_type = "SPOT"

#       min_size     = 1
#       max_size     = 2
#       desired_size = 2

#       metadata_options = {
#         http_endpoint               = "enabled"
#         http_put_response_hop_limit = 2
#         http_tokens                 = "required"
#       }

#       labels = {
#         nodegroup = "blue"
#       }
#     }

#     green = {
#       create = false
#     }
#   }

#   tags = local.common_tags
# }