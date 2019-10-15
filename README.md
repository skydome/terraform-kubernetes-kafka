# terraform-kubernetes-cassandra
Kafka on Kubernetes

Tested on GKE but it should work for any kubernetes cluster given the right terraform-provider-kubernetes setup.

## Inputs

- **kafka_name**                               : Name of the kafka deployment
- **kafka_storage_size**                       : Disk size to be requested for kafka (i.e. "64Gi")
- **kafka_storage_class_name**                 : Kubernetes storage class to be used for kafka persistence
- **allow_auto_create_topics**                 : Allow automatic topic creation on the broker when subscribing to or assigning a topic.
- **default_replication_factor**               : Default replication factor for automatically created topics
- **min_insync_replicas**                      : Minimum in-sync replica count for partitions
- **transaction_state_log_replication_factor** : The replication factor for the transaction topic
- **transaction_state_log_min_isr**            : Overridden min.insync.replicas config for the transaction topic.
- **offset_topic_replication_factor**          : Default offset topic replication factor
- **zookeeper_storage_size**                   : Disk size to be requested for zooekeeper (i.e. "64Gi")
- **zookeeper_storage_class_name**             : Kubernetes storage class to be used for zookeeper persistence
- **namespace**                                : Kubernetes namespace to be deployed
- **cluster_size**                             : Kafka cluster size
- **zookeeper_cluster_size**                   : Zookeeper cluster size
- **kafka_rest_enabled**                       : Should we deploy kafka rest?
- **kafka_rest_replicacount**                  : Kafka rest deploment replica count
- **kafka_rest_ingress_host**                  : Ingress host address for routing
- **kafka_rest_ingress_annotations**           : Extra annotations for kubernetes ingress
- **kafka_rest_ingress_enabled**               : Should we enable ingress for kafka rest? (may want to deploy proxy in front of it?)

## Dependencies

Terraform Kubernetes Provider

## Tested With

- terraform-providers/kubernetes : 1.9.0
- confluentinc/cp-kafka:5.3.0 docker image
- confluentinc/cp-kafka-rest:5.3.0 docker image
- zookeeper:3.5.5 docker image
- kubernetes 1.13.7-gke.8

## Credits

This module was initially generated from helm/incubator/kafka and cp-helm-charts/kafka-rest via [k2tf](https://github.com/sl1pm4t/k2tf) project.
