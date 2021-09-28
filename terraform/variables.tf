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

variable "ec2_key" {
  type        = string
  default     = "test_key"
  description = "This is your EC2 key name."
}

variable "wavelength_zone" {
  type        = string
  default     = "us-east-1-wl1-nyc-wlz-1"
  description = "This is the Wavelength Zone to deploy the EKS node group."
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


