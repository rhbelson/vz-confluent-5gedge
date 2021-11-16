resource "local_file" "manifests" {
  for_each = var.wavelength_zones
  filename = "confluent_manifest_${each.key}.yaml"
  content = templatefile(
    "${path.module}/templates/min.tpl",
    {
      zookeeper_replicas = 1,
      broker_replicas    = 3,
      domain             = "${var.domain}",
      cp_version         = "${var.cp_version}",
      cfk_version        = "${var.cfk_version}",
      namespace          = "${each.key}",
      zone               = "${each.value.availability_zone}"
      nodeport_offset    = "${each.value.nodeport_offset}"
    }
  )
}