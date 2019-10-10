variable "namespace" {}
variable "kafka_name" {}
variable "cluster_size" {}
variable "offset_topic_replication_factor" {
  default = 1
}
variable "zookeeper_cluster_size" {
  default = 1
}
variable "kafka_rest_replicacount" {
  default = 1
}
variable "kafka_rest_ingress_host" {
  default = "mydearhost.io"
}
variable "kafka_rest_ingress_annotations" {
  type    = list(object({ key = string, value = string }))
  default = []
}
variable "kafka_rest_enabled" {
  type    = bool
  default = false
}

variable "kafka_rest_endpoint" {
  type    = string
  default = "kafka"
}

variable "kafka_rest_ingress_enabled" {
  type    = bool
  default = true
}

variable "kafka_storage_size" {
  type = string
  default = "1Gi"
}

variable "kafka_storage_class_name" {
  type = string
  default = "standard"
}

variable "zookeeper_storage_size" {
  type = string
  default = "2Gi"
}

variable "zookeeper_storage_class_name" {
  type = string
  default = "standard"
}
