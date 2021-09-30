# resource "kubernetes_manifest" "zookeeper_confluent_zookeeper" {
#     manifest = {
#         "apiVersion" = "platform.confluent.io/v1beta1"
#         "kind" = "Zookeeper"
#         "metadata" = {
#             "name" = "zookeeper"
#             "namespace" = "confluent"
#             # Added to address https://github.com/hashicorp/terraform-provider-kubernetes/issues/1040; computed_fields doesn't appear to work here
#             "finalizers" = [
#                 "zookeeper.finalizers.platform.confluent.io",
#             ]
#         }
#         "spec" = {
#             "replicas" = 3
#             "image" = {
#                 "application" = "confluentinc/cp-zookeeper:6.2.0"
#                 "init" = "confluentinc/confluent-init-container:2.0.0"
#             }
#             "logVolumeCapacity" = "10Gi"
#             "dataVolumeCapacity" = "10Gi"
#         }
#     }

#     # computed_fields = ["metadata.finalizers"]

#     depends_on = [
#         helm_release.confluent_for_kubernetes,
#     ]
# }

# resource "kubernetes_manifest" "kafka_confluent_kafka" {
#     manifest = {
#         "apiVersion" = "platform.confluent.io/v1beta1"
#         "kind" = "Kafka"
#         "metadata" = {
#             "name" = "kafka"
#             "namespace" = "confluent"
#             # Added to address https://github.com/hashicorp/terraform-provider-kubernetes/issues/1040; computed_fields doesn't appear to work here
#             "finalizers" = [
#                 "kafka.finalizers.platform.confluent.io",
#             ]
#         }
#         "spec" = {
#             "replicas" = 3
#             "image" = {
#                 "application" = "confluentinc/cp-server:6.2.0"
#                 "init" = "confluentinc/confluent-init-container:2.0.0"
#             }
#             "dataVolumeCapacity" = "50Gi"
#             "listeners" = {
#                 "custom" = [
#                     {
#                         "externalAccess" = {
#                             "nodePort" = {
#                                 "host" = "np.eventsizer.io"
#                                 "nodePortOffset" = 31000
#                             }
#                             "type" = "nodePort"
#                         }
#                         "name" = "np"
#                         "port" = 9096
#                     },
#                 ]
#                 "external" = {
#                     "externalAccess" = {
#                         "loadBalancer" = {
#                             "domain" = "kafka.eventsizer.io"
#                         }
#                         "type" = "loadBalancer"
#                     }
#                 }
#             }
#             "metricReporter" = {
#                 "enabled" = true
#             }
#             "configOverrides" = {
#                 "server" = [
#                     "confluent.cluster.link.enable=true",
#                 ]
#             }
#         }
#     }

#     # computed_fields = ["metadata.finalizers"]

#     depends_on = [
#         helm_release.confluent_for_kubernetes,
#         kubernetes_manifest.zookeeper_confluent_zookeeper,
#     ]
# }

# resource "kubernetes_manifest" "schemaregistry_confluent_schemaregistry" {
#     manifest = {
#         "apiVersion" = "platform.confluent.io/v1beta1"
#         "kind" = "SchemaRegistry"
#         "metadata" = {
#             "name" = "schemaregistry"
#             "namespace" = "confluent"
#             # Added to address https://github.com/hashicorp/terraform-provider-kubernetes/issues/1040; computed_fields doesn't appear to work here
#             "finalizers" = [
#                 "schemaregistry.finalizers.platform.confluent.io",
#             ]
#         }
#         "spec" = {
#             "image" = {
#                 "application" = "confluentinc/cp-schema-registry:6.2.0"
#                 "init" = "confluentinc/confluent-init-container:2.0.0"
#             }
#             "replicas" = 1
#         }
#     }

#     # computed_fields = ["metadata.finalizers"]

#     depends_on = [
#         helm_release.confluent_for_kubernetes,
#         kubernetes_manifest.kafka_confluent_kafka,
#     ]
# }

# resource "kubernetes_manifest" "connect_confluent_connect" {
#     manifest = {
#         "apiVersion" = "platform.confluent.io/v1beta1"
#         "kind" = "Connect"
#         "metadata" = {
#             "name" = "connect"
#             "namespace" = "confluent"
#             # Added to address https://github.com/hashicorp/terraform-provider-kubernetes/issues/1040; computed_fields doesn't appear to work here
#             "finalizers" = [
#                 "connect.finalizers.platform.confluent.io",
#             ]
#         }
#         "spec" = {
#             "replicas" = 1
#             "image" = {
#                 "application" = "confluentinc/cp-server-connect:6.2.0"
#                 "init" = "confluentinc/confluent-init-container:2.0.0"
#             }
#             "dependencies" = {
#                 "kafka" = {
#                     "bootstrapEndpoint" = "kafka:9071"
#                 }
#             }
#         }
#     }

#     # computed_fields = ["metadata.finalizers"]

#     depends_on = [
#         helm_release.confluent_for_kubernetes,
#         kubernetes_manifest.kafka_confluent_kafka,
#     ]
# }

# resource "kubernetes_manifest" "ksqldb_confluent_ksqldb" {
#     manifest = {
#         "apiVersion" = "platform.confluent.io/v1beta1"
#         "kind" = "KsqlDB"
#         "metadata" = {
#             "name" = "ksqldb"
#             "namespace" = "confluent"
#             # Added to address https://github.com/hashicorp/terraform-provider-kubernetes/issues/1040; computed_fields doesn't appear to work here
#             "finalizers" = [
#                 "ksqldb.finalizers.platform.confluent.io",
#             ]
#         }
#         "spec" = {
#             "replicas" = 1
#             "image" = {
#                 "application" = "confluentinc/cp-ksqldb-server:6.2.0"
#                 "init" = "confluentinc/confluent-init-container:2.0.0"
#             }
#             "dataVolumeCapacity" = "10Gi"
#         }
#     }

#     # computed_fields = ["metadata.finalizers"]

#     depends_on = [
#         helm_release.confluent_for_kubernetes,
#         kubernetes_manifest.kafka_confluent_kafka,
#     ]
# }

# resource "kubernetes_manifest" "controlcenter_confluent_controlcenter" {
#     manifest = {
#         "apiVersion" = "platform.confluent.io/v1beta1"
#         "kind" = "ControlCenter"
#         "metadata" = {
#             "name" = "controlcenter"
#             "namespace" = "confluent"
#             # Added to address https://github.com/hashicorp/terraform-provider-kubernetes/issues/1040; computed_fields doesn't appear to work here
#             "finalizers" = [
#                 "controlcenter.finalizers.platform.confluent.io",
#             ]
#         }
#         "spec" = {
#             "replicas" = 1
#             "image" = {
#                 "application" = "confluentinc/cp-enterprise-control-center:6.2.0"
#                 "init" = "confluentinc/confluent-init-container:2.0.0"
#             }
#             "dataVolumeCapacity" = "10Gi"
#             "dependencies" = {
#                 "connect" = [
#                     {
#                         "name" = "connect"
#                         "url" = "http://connect.confluent.svc.cluster.local:8083"
#                     },
#                 ]
#                 "ksqldb" = [
#                     {
#                         "name" = "ksqldb"
#                         "url" = "http://ksqldb.confluent.svc.cluster.local:8088"
#                     },
#                 ]
#                 "schemaRegistry" = {
#                     "url" = "http://schemaregistry.confluent.svc.cluster.local:8081"
#                 }
#             }
#         }
#     }

#     # computed_fields = ["metadata.finalizers"]

#     depends_on = [
#         helm_release.confluent_for_kubernetes,
#         kubernetes_manifest.kafka_confluent_kafka,
#     ]
# }