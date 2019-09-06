variable "namespace" {}
variable "kafka_name" {}
variable "cluster_size" {}
variable "offset_topic_replication_factor" {}
variable "zookeeper_cluster_size" {}
variable "kafka_rest_replicacount" {}
variable "kafka_rest_ingress_host" {}
variable "kafka_rest_ingress_annotations" {
  type = list(object({key = string, value = string}))
}
variable "kafka_rest_enabled" {
  type = bool
  default = false
}
