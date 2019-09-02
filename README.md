# terraform-kubernetes-cassandra
Kafka on Kubernetes

Tested on GKE but it should work for any kubernetes cluster given the right terraform-provider-kubernetes setup.

## Inputs

- **kafka_name**             : name of the kafka deployment
- **namespace**              : kubernetes namespace to be deployed
- **cluster_size**           : kafka cluster size
- **zookeeper_cluster_size** : zookeeper cluster size

## Dependencies

Terraform Kubernetes Provider

## Tested With

- terraform-providers/kubernetes : 1.9.0
- confluentinc/cp-kafka:5.0.1 docker image
- zookeeper:3.5.5 docker image
- kubernetes 1.13.7-gke.8

## Credits

This module was initially generated from helm/incubator/kafka via [k2tf](https://github.com/sl1pm4t/k2tf) project.
