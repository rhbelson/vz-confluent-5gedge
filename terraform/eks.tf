data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token

  experiments {
    manifest_resource = true
  }
}

module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.cluster_name}"
  cluster_version = "1.21"
  manage_aws_auth = false
  subnets         = [
    aws_subnet.tf_region_subnet.id,
    aws_subnet.tf_region_subnet_2.id,
    # aws_subnet.tf_wl_subnet.id
  ]
  vpc_id          = aws_vpc.tf_vpc.id
}

resource "aws_cloudformation_stack" "eks_node_group" {
  name = "tf-node-group"
  parameters = {
    ClusterControlPlaneSecurityGroup    = module.eks_cluster.cluster_security_group_id
    NodeGroupName                       = "Wavelength-Node-Group"
    KeyName                             = var.ec2_key
    Subnets                             = aws_subnet.tf_wl_subnet.id
    ClusterName                         = module.eks_cluster.cluster_id
    VpcId                               = aws_vpc.tf_vpc.id
    NodeAutoScalingGroupDesiredCapacity = 1
    NodeInstanceType                    = "t3.xlarge"
    BootstrapArguments                  = join(", ", ["--apiserver-endpoint", module.eks_cluster.cluster_endpoint, "--b64-cluster-ca", module.eks_cluster.cluster_certificate_authority_data, "--capabilities", "CAPABILITY_NAMED_IAM"])
  }

  depends_on = [
    module.eks_cluster,
    # kubernetes_config_map.aws_auth,
  ]

  template_url = var.node_group_s3_bucket_url
  capabilities = ["CAPABILITY_IAM"]
}

# resource "null_resource" "apply_auth_map" {
#     provisioner "local-exec" {
#       command = "./apply-auth-map.sh"
#     }
#     depends_on = [
#       data.aws_eks_cluster.cluster
#     ]
# }

