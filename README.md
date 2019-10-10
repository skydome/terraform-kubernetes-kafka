# terraform-kubernetes-cassandra
Kafka on Kubernetes

Tested on GKE but it should work for any kubernetes cluster given the right terraform-provider-kubernetes setup.

## Inputs

- **kafka_name**                       : name of the kafka deployment
- **kafka_storage_size**               : disk size to be requested for kafka (i.e. "64Gi")
- **kafka_storage_class_name**         : kubernetes storage class to be used for kafka persistence
- **zookeeper_storage_size**           : disk size to be requested for zooekeeper (i.e. "64Gi")
- **zookeeper_storage_class_name**     : kubernetes storage class to be used for kafka persistence
- **namespace**                        : kubernetes namespace to be deployed
- **cluster_size**                     : kafka cluster size
- **zookeeper_cluster_size**           : zookeeper cluster size
- **offset_topic_replication_factor**  : default kafka topic replication factor
- **kafka_rest_enabled**               : should we deploy kafka rest?
- **kafka_rest_replicacount**          : kafka rest deploment replica count
- **kafka_rest_ingress_host**          : ingress host address for routing
- **kafka_rest_ingress_annotations**   : extra annotations for kubernetes ingress
- **kafka_rest_ingress_enabled**       : should we enable ingress for kafka rest? (may want to deploy proxy in front of it?)

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
