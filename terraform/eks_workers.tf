locals {
  userdata = <<-EOT
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${module.eks_cluster.cluster_id}
  EOT
}

# Create security group for edge resources
resource "aws_security_group_rule" "edge_confluent_1" {
  type              = "ingress"
  from_port         = 31000
  to_port           = 31003
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks_cluster.worker_security_group_id
}


resource "aws_launch_template" "worker_launch_template" {
  name = "${var.cluster_name}-wl-workers"

  # todo: change to map lookup
  image_id      = lookup(var.worker_image_id, var.region)
  instance_type = var.worker_instance_type
  key_name      = var.worker_key_name

  network_interfaces {
    associate_carrier_ip_address = true
    security_groups              = [module.eks_cluster.worker_security_group_id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.worker_volume_size
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.worker_role.arn
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = var.require_imdsv2 ? "required" : "optional"
  }

  user_data = base64encode(local.userdata)
}


resource "aws_autoscaling_group" "workers" {
  name = "${var.cluster_name}-wl-workers"

  max_size         = 10
  min_size         = 1
  desired_capacity = 3
  # health_check_grace_period = 300
  # health_check_type         = "ELB"

  vpc_zone_identifier = [aws_subnet.tf_wl_subnet.id, aws_subnet.tf_wl_subnet_2.id]

  launch_template {
    id      = aws_launch_template.worker_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${module.eks_cluster.cluster_id}-${var.worker_nodegroup_name}-Node"
    propagate_at_launch = true
  }

  tag {
    value               = "owned"
    key                 = "kubernetes.io/cluster/${module.eks_cluster.cluster_id}"
    propagate_at_launch = true
  }

  ## Todo: auto scaling update policy: max batch 1, pause 5 minutes
}

resource "null_resource" "update_dns" {
  provisioner "local-exec" {
    command = "./apply_dns.sh"
    environment = {
      ZONEID = var.zoneid
      DOMAIN = var.domain
    }
  }
  depends_on = [
    aws_autoscaling_group.workers
  ]
}