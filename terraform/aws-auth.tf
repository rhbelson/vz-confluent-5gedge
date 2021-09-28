locals {
    yaml_quote = ""

    map_worker_roles = [
        for role_arn in ["arn:aws:iam::829250931565:role/tf-node-group-1-NodeInstanceRole-1U4CZGYO9YQRN"] : {
        rolearn : role_arn
        username : "system:node:{{EC2PrivateDNSName}}"
        groups : [
            "system:bootstrappers",
            "system:nodes"
        ]
        }
    ]

    map_additional_iam_roles = []
    map_additional_iam_users = []
    map_additional_aws_accounts = []
}

resource "kubernetes_config_map" "aws_auth" {
    metadata {
        name = "aws-auth"
        namespace = "kube-system"
    }

    data = {
        mapRoles    = replace(yamlencode(distinct(concat(local.map_worker_roles, local.map_additional_iam_roles))), "\"", local.yaml_quote)
        mapUsers    = replace(yamlencode(local.map_additional_iam_users), "\"", local.yaml_quote)
        mapAccounts = replace(yamlencode(local.map_additional_aws_accounts), "\"", local.yaml_quote)
    }
    
}
# aws_cloudformation_stack.eks_node_group.outputs.NodeInstanceRole
