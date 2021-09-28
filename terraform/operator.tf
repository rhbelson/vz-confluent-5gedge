resource "kubernetes_namespace" "confluent" {
    metadata {
        name = "confluent"
    }
} 

provider "helm" {
    kubernetes {
        host                   = data.aws_eks_cluster.cluster.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
        token                  = data.aws_eks_cluster_auth.cluster.token
    }
}

resource "helm_release" "confluent_for_kubernetes" {
    name       = "confluent-for-kubernetes"

    repository = "https://packages.confluent.io/helm"
    chart      = "confluent-for-kubernetes"

    namespace = "confluent"

    depends_on = [
        kubernetes_namespace.confluent
    ]
}