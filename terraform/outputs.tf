# data "aws_instance" "edge_broker" {
#   filter {
#     name   = "tag:Name"
#     values = ["wavelength-Wavelength-Node-Group-Node"]
#   }
#   depends_on = [aws_autoscaling_group.workers]
# }

# output "broker_private_ip" {
#   value       = data.aws_instance.edge_broker.*.private_ip
#   description = "The Private IP address of the edge instances in the Wavelength Zone"
# }

# output "broker_carrier_ip" {
#   value       = data.aws_instance.edge_broker.*.carrier_ip
#   description = "The Carrier IP address of the edge instances in the Wavelength Zone"
# }

