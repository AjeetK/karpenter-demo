# Karpenter needs permissions to create EC2 instances in AWS. If you use a self-hosted Kubernetes cluster, for example by using kOps. You can add additional IAM policies to the existing IAM role attached to Kubernetes nodes. We use EKS, the best way to grant access to internal service would be with IAM roles for service accounts.
# First, we need to create an OpenID Connect provider.

data "tls_certificate" "eks" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
