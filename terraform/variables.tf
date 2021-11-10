variable "profile" {
  type        = string
  description = "AWS Credentials Profile to use"
  default     = "default"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "This is the AWS region."
}

variable "worker_key_name" {
  type        = string
  default     = "test_key"
  description = "This is your EC2 key name."
}

variable "cluster_name" {
  type    = string
  default = "wavelength"
}

variable "wavelength_zone" {
  type        = string
  default     = "us-east-1-wl1-nyc-wlz-1"
  description = "This is the Wavelength Zone to deploy the EKS node group."
}

variable "wavelength_zone_2" {
  type        = string
  default     = "us-east-1-wl1-bos-wlz-1"
  description = "This is the second Wavelength Zone to deploy the EKS node group."
}

variable "wavelength_zone_3" {
  type        = string
  default     = "us-east-1-wl1-was-wlz-1"
  description = "This is the third Wavelength Zone to deploy the EKS node group."
}

variable "wavelength_zone_4" {
  type        = string
  default     = "us-east-1-wl1-atl-wlz-1"
  description = "This is the fourth Wavelength Zone to deploy the EKS node group."
}

variable "wavelength_zone_5" {
  type        = string
  default     = "us-east-1-wl1-mia-wlz-1"
  description = "This is the fifth Wavelength Zone to deploy the EKS node group."
}
variable "availability_zone_1" {
  type        = string
  default     = "us-east-1a"
  description = "This is the first Availability Zone for the EKS control plane."
}

variable "availability_zone_2" {
  type        = string
  default     = "us-east-1b"
  description = "This is the second Availability Zone for the EKS control plane."
}

variable "node_group_s3_bucket_url" {
  type        = string
  default     = "https://wavelengthtutorials.s3.amazonaws.com/wlz-eks-node-group.yaml"
  description = "This is the S3 object URL of the EKS node group with auto-attached Carrier IPs."
}

variable "worker_volume_size" {
  default     = 20
  description = "This is the volume size (GB) of the EBS volumes for the EKS worker nodes."
}

variable "worker_instance_type" {
  default     = "t3.xlarge"
  description = "This is the EC2 instance type for the EKS worker nodes."
}

variable "require_imdsv2" {
  default = true
}

variable "wlz2" {
  default     = false
  description = "Bool to determine deployment of second Wavelength Zone node group."
}
variable "wlz3" {
  default     = false
  description = "Bool to determine deployment of third Wavelength Zone node group."
}
variable "wlz4" {
  default     = false
  description = "Bool to determine deployment of fourth Wavelength Zone node group."
}
variable "wlz5" {
  default     = false
  description = "Bool to determine deployment of fifth Wavelength Zone node group."
}


# Create AMI Mapping for Wavelength Zone (EKS 1.21)
variable "worker_image_id" {
  type = map(string)
  default = {
    "us-east-1" = "ami-0193ebf9573ebc9f7"
    "us-west-2" = "ami-0bb07d9c8d6ca41e8"
  }
}

variable "worker_nodegroup_name" {
  default     = "Wavelength-Node-Group"
  description = "This is the AMI for the EKS worker nodes."

}

variable "domain" {
  default     = "lab.local"
  description = "This the Route53 domain name for your Confluent cluster."
}

variable "zoneid" {
  default     = "none"
  description = "This is the Route53 ZoneID of your Public Hosted Zone for your Confluent cluster."
}

locals {
  ports_in = [
    443,
    80,
    22
  ]
  ports_out = [
    0
  ]
}

variable "cp_version" {
  default     = "6.2.1"
  description = "This is the version of the Confluent Platform."
}

variable "cfk_version" {
  default     = "2.1.0"
  description = "This is the version of Confluent for Kubernetes."
}


