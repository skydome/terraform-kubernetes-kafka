variable "namespace" {}
variable "kafka_name" {}

variable "confluent_kafka_version" {
  type    = string
  default = "5.4.0"
}

variable "kafka_storage_size" {
  type    = string
  default = "1Gi"
}

variable "kafka_storage_class_name" {
  type    = string
  default = "standard"
}

variable "cluster_size" {
  default = 1
}

variable "allow_auto_create_topics" {
  type    = bool
  default = true
}

variable "offset_topic_replication_factor" {
  default = 1
}

variable "default_replication_factor" {
  default = 1
}

variable "min_insync_replicas" {
  default = 1
}

variable "transaction_state_log_replication_factor" {
  default = 1
}

variable "transaction_state_log_min_isr" {
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

variable "zookeeper_storage_size" {
  type    = string
  default = "2Gi"
}

variable "zookeeper_storage_class_name" {
  type    = string
  default = "standard"
}
