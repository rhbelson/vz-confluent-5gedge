resource "local_file" "manifest" {
  filename = "confluent_manifest.yaml"
  content = templatefile(
    "${path.module}/templates/all.tpl",
    {
      zookeeper_replicas = 3,
      broker_replicas    = 3,
      domain             = "${var.domain}",
      cp_version         = "${var.cp_version}",
      cfk_version        = "${var.cfk_version}",
    }
  )
}