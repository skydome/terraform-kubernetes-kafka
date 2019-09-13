resource "kubernetes_config_map" "zookeeper" {
  metadata {
    name   = "${var.kafka_name}-zookeeper"
    namespace = "${var.namespace}"
    labels = { app = "${var.kafka_name}-zookeeper", component = "server" }
  }
  data = { ok = "#!/bin/sh\necho ruok | nc 127.0.0.1 $${1:-2181}\n", ready = "#!/bin/sh\necho ruok | nc 127.0.0.1 $${1:-2181}\n", run = "#!/bin/bash\n\nset -a\nROOT=$(echo /apache-zookeeper-*)\n\nZK_USER=$${ZK_USER:-\"zookeeper\"}\nZK_LOG_LEVEL=$${ZK_LOG_LEVEL:-\"INFO\"}\nZK_DATA_DIR=$${ZK_DATA_DIR:-\"/data\"}\nZK_DATA_LOG_DIR=$${ZK_DATA_LOG_DIR:-\"/data/log\"}\nZK_CONF_DIR=$${ZK_CONF_DIR:-\"/conf\"}\nZK_CLIENT_PORT=$${ZK_CLIENT_PORT:-2181}\nZK_SERVER_PORT=$${ZK_SERVER_PORT:-2888}\nZK_ELECTION_PORT=$${ZK_ELECTION_PORT:-3888}\nZK_TICK_TIME=$${ZK_TICK_TIME:-2000}\nZK_INIT_LIMIT=$${ZK_INIT_LIMIT:-10}\nZK_SYNC_LIMIT=$${ZK_SYNC_LIMIT:-5}\nZK_HEAP_SIZE=$${ZK_HEAP_SIZE:-2G}\nZK_MAX_CLIENT_CNXNS=$${ZK_MAX_CLIENT_CNXNS:-60}\nZK_MIN_SESSION_TIMEOUT=$${ZK_MIN_SESSION_TIMEOUT:- $((ZK_TICK_TIME*2))}\nZK_MAX_SESSION_TIMEOUT=$${ZK_MAX_SESSION_TIMEOUT:- $((ZK_TICK_TIME*20))}\nZK_SNAP_RETAIN_COUNT=$${ZK_SNAP_RETAIN_COUNT:-3}\nZK_PURGE_INTERVAL=$${ZK_PURGE_INTERVAL:-0}\nID_FILE=\"$ZK_DATA_DIR/myid\"\nZK_CONFIG_FILE=\"$ZK_CONF_DIR/zoo.cfg\"\nLOG4J_PROPERTIES=\"$ZK_CONF_DIR/log4j.properties\"\nHOST=$(hostname)\nDOMAIN=`hostname -d`\nZOOCFG=zoo.cfg\nZOOCFGDIR=$ZK_CONF_DIR\nJVMFLAGS=\"-Xmx$ZK_HEAP_SIZE -Xms$ZK_HEAP_SIZE\"\n\nAPPJAR=$(echo $ROOT/*jar)\nCLASSPATH=\"$${ROOT}/lib/*:$${APPJAR}:$${ZK_CONF_DIR}:\"\n\nif [[ $HOST =~ (.*)-([0-9]+)$ ]]; then\n    NAME=$${BASH_REMATCH[1]}\n    ORD=$${BASH_REMATCH[2]}\n    MY_ID=$((ORD+1))\nelse\n    echo \"Failed to extract ordinal from hostname $HOST\"\n    exit 1\nfi\n\nmkdir -p $ZK_DATA_DIR\nmkdir -p $ZK_DATA_LOG_DIR\necho $MY_ID >> $ID_FILE\n\necho \"clientPort=$ZK_CLIENT_PORT\" >> $ZK_CONFIG_FILE\necho \"dataDir=$ZK_DATA_DIR\" >> $ZK_CONFIG_FILE\necho \"dataLogDir=$ZK_DATA_LOG_DIR\" >> $ZK_CONFIG_FILE\necho \"tickTime=$ZK_TICK_TIME\" >> $ZK_CONFIG_FILE\necho \"initLimit=$ZK_INIT_LIMIT\" >> $ZK_CONFIG_FILE\necho \"syncLimit=$ZK_SYNC_LIMIT\" >> $ZK_CONFIG_FILE\necho \"maxClientCnxns=$ZK_MAX_CLIENT_CNXNS\" >> $ZK_CONFIG_FILE\necho \"minSessionTimeout=$ZK_MIN_SESSION_TIMEOUT\" >> $ZK_CONFIG_FILE\necho \"maxSessionTimeout=$ZK_MAX_SESSION_TIMEOUT\" >> $ZK_CONFIG_FILE\necho \"autopurge.snapRetainCount=$ZK_SNAP_RETAIN_COUNT\" >> $ZK_CONFIG_FILE\necho \"autopurge.purgeInterval=$ZK_PURGE_INTERVAL\" >> $ZK_CONFIG_FILE\necho \"4lw.commands.whitelist=*\" >> $ZK_CONFIG_FILE\n\nfor (( i=1; i<=$ZK_REPLICAS; i++ ))\ndo\n    echo \"server.$i=$NAME-$((i-1)).$DOMAIN:$ZK_SERVER_PORT:$ZK_ELECTION_PORT\" >> $ZK_CONFIG_FILE\ndone\n\nrm -f $LOG4J_PROPERTIES\n\necho \"zookeeper.root.logger=$ZK_LOG_LEVEL, CONSOLE\" >> $LOG4J_PROPERTIES\necho \"zookeeper.console.threshold=$ZK_LOG_LEVEL\" >> $LOG4J_PROPERTIES\necho \"zookeeper.log.threshold=$ZK_LOG_LEVEL\" >> $LOGGER_PROPERS_FILE\necho \"zookeeper.log.dir=$ZK_DATA_LOG_DIR\" >> $LOG4J_PROPERTIES\necho \"zookeeper.log.file=zookeeper.log\" >> $LOG4J_PROPERTIES\necho \"zookeeper.log.maxfilesize=256MB\" >> $LOG4J_PROPERTIES\necho \"zookeeper.log.maxbackupindex=10\" >> $LOG4J_PROPERTIES\necho \"zookeeper.tracelog.dir=$ZK_DATA_LOG_DIR\" >> $LOG4J_PROPERTIES\necho \"zookeeper.tracelog.file=zookeeper_trace.log\" >> $LOG4J_PROPERTIES\necho \"log4j.rootLogger=\\$${zookeeper.root.logger}\" >> $LOG4J_PROPERTIES\necho \"log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender\" >> $LOG4J_PROPERTIES\necho \"log4j.appender.CONSOLE.Threshold=\\$${zookeeper.console.threshold}\" >> $LOG4J_PROPERTIES\necho \"log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout\" >> $LOG4J_PROPERTIES\necho \"log4j.appender.CONSOLE.layout.ConversionPattern=%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n\" >> $LOG4J_PROPERTIES\n\nif [ -n \"$JMXDISABLE\" ]\nthen\n    MAIN=org.apache.zookeeper.server.quorum.QuorumPeerMain\nelse\n    MAIN=\"-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=$JMXPORT -Dcom.sun.management.jmxremote.authenticate=$JMXAUTH -Dcom.sun.management.jmxremote.ssl=$JMXSSL -Dzookeeper.jmx.log4j.disable=$JMXLOG4J org.apache.zookeeper.server.quorum.QuorumPeerMain\"\nfi\n\nset -x\nexec java -cp \"$CLASSPATH\" $JVMFLAGS $MAIN $ZK_CONFIG_FILE\n" }
}

resource "kubernetes_service" "zookeeper_headless" {
  metadata {
    name   = "${var.kafka_name}-zookeeper-headless"
    namespace = "${var.namespace}"
    labels = { app = "${var.kafka_name}-zookeeper" }
  }
  spec {
    port {
      name        = "client"
      protocol    = "TCP"
      port        = 2181
      target_port = "client"
    }
    port {
      name        = "election"
      protocol    = "TCP"
      port        = 3888
      target_port = "election"
    }
    port {
      name        = "server"
      protocol    = "TCP"
      port        = 2888
      target_port = "server"
    }
    selector   = { app = "${var.kafka_name}-zookeeper" }
    cluster_ip = "None"
  }
}

resource "kubernetes_service" "zookeeper" {
  metadata {
    name   = "${var.kafka_name}-zookeeper"
    namespace = "${var.namespace}"
    labels = { app = "${var.kafka_name}-zookeeper" }
  }
  spec {
    port {
      name        = "client"
      protocol    = "TCP"
      port        = 2181
      target_port = "client"
    }
    selector = { app = "${var.kafka_name}-zookeeper" }
    type     = "ClusterIP"
  }
}

resource "kubernetes_service" "kafka" {
  metadata {
    name   = "${var.kafka_name}"
    namespace = "${var.namespace}"
    labels = { app = "${var.kafka_name}" }
  }
  spec {
    port {
      name        = "broker"
      port        = 9092
      target_port = "kafka"
    }
    selector = { app = "${var.kafka_name}" }
  }
}

resource "kubernetes_service" "kafka_headless" {
  metadata {
    name        = "${var.kafka_name}-headless"
    namespace = "${var.namespace}"
    labels      = { app = "${var.kafka_name}" }
    annotations = { "service.alpha.kubernetes.io/tolerate-unready-endpoints" = "true" }
  }
  spec {
    port {
      name = "broker"
      port = 9092
    }
    selector   = { app = "${var.kafka_name}" }
    cluster_ip = "None"
  }
}

resource "kubernetes_stateful_set" "zookeeper" {
  metadata {
    name   = "${var.kafka_name}-zookeeper"
    namespace = "${var.namespace}"
    labels = { app = "${var.kafka_name}-zookeeper", component = "server" }
  }
  spec {
    replicas = "${var.zookeeper_cluster_size}"
    selector {
      match_labels = { app = "${var.kafka_name}-zookeeper", component = "server" }
    }
    template {
      metadata {
        labels = { app = "${var.kafka_name}-zookeeper", component = "server" }
      }
      spec {
        volume {
          name = "config"
          config_map {
            name         = "${var.kafka_name}-zookeeper"
            default_mode = "0555"
          }
        }
        volume {
          name = "data"
        }
        container {
          name    = "zookeeper"
          image   = "zookeeper:3.5.5"
          command = ["/bin/bash", "-xec", "/config-scripts/run"]
          port {
            name           = "client"
            container_port = 2181
            protocol       = "TCP"
          }
          port {
            name           = "election"
            container_port = 3888
            protocol       = "TCP"
          }
          port {
            name           = "server"
            container_port = 2888
            protocol       = "TCP"
          }
          env {
            name  = "ZK_REPLICAS"
            value = "3"
          }
          env {
            name  = "JMXAUTH"
            value = "false"
          }
          env {
            name  = "JMXDISABLE"
            value = "false"
          }
          env {
            name  = "JMXPORT"
            value = "1099"
          }
          env {
            name  = "JMXSSL"
            value = "false"
          }
          env {
            name  = "ZK_HEAP_SIZE"
            value = "1G"
          }
          env {
            name  = "ZK_SYNC_LIMIT"
            value = "10"
          }
          env {
            name  = "ZK_TICK_TIME"
            value = "2000"
          }
          env {
            name  = "ZOO_AUTOPURGE_PURGEINTERVAL"
            value = "0"
          }
          env {
            name  = "ZOO_AUTOPURGE_SNAPRETAINCOUNT"
            value = "3"
          }
          env {
            name  = "ZOO_INIT_LIMIT"
            value = "5"
          }
          env {
            name  = "ZOO_MAX_CLIENT_CNXNS"
            value = "60"
          }
          env {
            name  = "ZOO_PORT"
            value = "2181"
          }
          env {
            name  = "ZOO_STANDALONE_ENABLED"
            value = "false"
          }
          env {
            name  = "ZOO_TICK_TIME"
            value = "2000"
          }
          volume_mount {
            name       = "data"
            mount_path = "/data"
          }
          volume_mount {
            name       = "config"
            mount_path = "/config-scripts"
          }
          liveness_probe {
            exec {
              command = ["sh", "/config-scripts/ok"]
            }
            initial_delay_seconds = 20
            timeout_seconds       = 5
            period_seconds        = 30
            success_threshold     = 1
            failure_threshold     = 2
          }
          readiness_probe {
            exec {
              command = ["sh", "/config-scripts/ready"]
            }
            initial_delay_seconds = 20
            timeout_seconds       = 5
            period_seconds        = 30
            success_threshold     = 1
            failure_threshold     = 2
          }
          image_pull_policy = "IfNotPresent"
        }
        termination_grace_period_seconds = 1800
        security_context {
          run_as_user = 1000
          fs_group    = 1000
        }
      }
    }
    service_name = "${var.kafka_name}-zookeeper-headless"
    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "kafka" {
  metadata {
    name   = "${var.kafka_name}"
    namespace = "${var.namespace}"
    labels = { app = "${var.kafka_name}" }
  }
  spec {
    replicas = "${var.cluster_size}"
    selector {
      match_labels = { app = "${var.kafka_name}" }
    }
    template {
      metadata {
        labels = { app = "${var.kafka_name}" }
      }
      spec {
        container {
          name    = "kafka-broker"
          image   = "confluentinc/cp-kafka:5.3.0"
          command = ["sh", "-exc", "unset KAFKA_PORT && \\\nexport KAFKA_BROKER_ID=$${POD_NAME##*-} && \\\nexport KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://$${POD_IP}:9092 && \\\nexec /etc/confluent/docker/run\n"]
          port {
            name           = "kafka"
            container_port = 9092
          }
          env {
            name = "POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name  = "KAFKA_HEAP_OPTS"
            value = "-Xmx1G -Xms1G"
          }
          env {
            name  = "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR"
            value = "${var.offset_topic_replication_factor}"
          }
          env {
            name  = "KAFKA_ZOOKEEPER_CONNECT"
            value = "${var.kafka_name}-zookeeper:2181"
          }
          env {
            name  = "KAFKA_LOG_DIRS"
            value = "/opt/kafka/data/logs"
          }
          env {
            name  = "KAFKA_CONFLUENT_SUPPORT_METRICS_ENABLE"
            value = "false"
          }
          env {
            name  = "KAFKA_JMX_PORT"
            value = "5555"
          }
          volume_mount {
            name       = "datadir"
            mount_path = "/opt/kafka/data"
          }
          liveness_probe {
            exec {
              command = ["sh", "-ec", "/usr/bin/jps | /bin/grep -q SupportedKafka"]
            }
            initial_delay_seconds = 30
            timeout_seconds       = 5
          }
          readiness_probe {
            tcp_socket {
              port = "kafka"
            }
            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
          }
          image_pull_policy = "IfNotPresent"
        }
        termination_grace_period_seconds = 60
      }
    }
    volume_claim_template {
      metadata {
        name = "datadir"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = { storage = "1Gi" }
        }
      }
    }
    service_name          = "${var.kafka_name}-headless"
    pod_management_policy = "OrderedReady"
    update_strategy {
      type = "OnDelete"
    }
  }
}

resource "kubernetes_deployment" "kafka_rest" {
  count  = var.kafka_rest_enabled ? 1 : 0
  metadata {
    name = "${var.kafka_name}-rest"
    namespace = "${var.namespace}"
    labels = {
      app = "${var.kafka_name}-rest"
      release = "${var.kafka_name}-rest"
    }
  }

  spec {
    replicas = var.kafka_rest_replicacount

    selector {
      match_labels = {
        app = "${var.kafka_name}-rest"
        release = "${var.kafka_name}-rest"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.kafka_name}-rest"
          release = "${var.kafka_name}-rest"
        }

        annotations = {
          "prometheus.io/port" = "5556"
          "prometheus.io/scrape" = "true"
        }
      }

      spec {
        volume {
          name = "jmx-config"

          config_map {
            name = "${var.kafka_name}-rest-jmx-configmap"
          }
        }

        container {
          name    = "prometheus-jmx-exporter"
          image   = "solsson/kafka-prometheus-jmx-exporter@sha256:6f82e2b0464f50da8104acd7363fb9b995001ddff77d248379f8788e78946143"
          command = ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-XX:MaxRAMFraction=1", "-XshowSettings:vm", "-jar", "jmx_prometheus_httpserver.jar", "5556", "/etc/jmx-kafka-rest/jmx-kafka-rest-prometheus.yml"]

          port {
            container_port = 5556
          }

          volume_mount {
            name       = "jmx-config"
            mount_path = "/etc/jmx-kafka-rest"
          }

          image_pull_policy = "IfNotPresent"
        }

        container {
          name  = "${var.kafka_name}-rest-server"
          image = "confluentinc/cp-kafka-rest:5.3.0"

          port {
            name           = "rest-proxy"
            container_port = 8082
            protocol       = "TCP"
          }

          port {
            name           = "jmx"
            container_port = 5555
          }

          env {
            name = "KAFKA_REST_HOST_NAME"

            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }

          env {
            name  = "KAFKA_REST_ZOOKEEPER_CONNECT"
            value = "${var.kafka_name}-zookeeper-headless:2181"
          }

          env {
            name  = "KAFKA_REST_SCHEMA_REGISTRY_URL"
            value = "${var.kafka_name}-schema-registry:8081"
          }

          env {
            name  = "KAFKAREST_HEAP_OPTS"
            value = "-Xms512M -Xmx512M"
          }

          env {
            name  = "KAFKA_REST_JMX_PORT"
            value = "5555"
          }

          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}

resource "kubernetes_ingress" "kafka_rest_ingress" {
  count  = var.kafka_rest_enabled ? 1 : 0
  metadata {
    name = "${var.kafka_name}-rest-ingress"
    namespace = "${var.namespace}"
    labels = {
      app = "${var.kafka_name}-rest"
      release = "${var.kafka_name}-rest"
    }

    annotations = {
      for instance in var.kafka_rest_ingress_annotations:
      instance.key => instance.value
    }
  }

  spec {
    tls {
      hosts       = ["${var.kafka_rest_ingress_host}"]
      secret_name = "${var.namespace}-tls-cert"
    }

    rule {
      host = "${var.kafka_rest_ingress_host}"

      http {
        path {
          path = "/${var.kafka_rest_endpoint}(/|$)(.*)"

          backend {
            service_name = "${var.kafka_name}-rest-service"
            service_port = "8082"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "kafka_rest_service" {
  count  = var.kafka_rest_enabled ? 1 : 0
  metadata {
    name = "${var.kafka_name}-rest-service"
    namespace = "${var.namespace}"
    labels = {
      app = "${var.kafka_name}-rest"
      release = "${var.kafka_name}-rest"
    }
  }

  spec {
    port {
      name = "rest-proxy"
      port = 8082
    }

    selector = {
      app = "${var.kafka_name}-rest"
      release = "${var.kafka_name}-rest"
    }
  }
}


resource "kubernetes_config_map" "kafka_rest_jmx_configmap" {
  count  = var.kafka_rest_enabled ? 1 : 0
  metadata {
    name = "${var.kafka_name}-rest-jmx-configmap"
    namespace = "${var.namespace}"
    labels = {
      app = "${var.kafka_name}-rest"
      release = "${var.kafka_name}-rest"
    }
  }

  data = {
    "jmx-kafka-rest-prometheus.yml" = "jmxUrl: service:jmx:rmi:///jndi/rmi://localhost:5555/jmxrmi                                                                                                \nlowercaseOutputName: true                                                                                                                                  \nlowercaseOutputLabelNames: true                                                                                                                            \nssl: false                                                                                                                                                 \nrules:                                                                     \n- pattern : 'kafka.rest<type=jetty-metrics>([^:]+):'                                                                                                       \n  name: \"cp_kafka_rest_jetty_metrics_$1\"                                                                                                                   \n- pattern : 'kafka.rest<type=jersey-metrics>([^:]+):'                                                                                                      \n  name: \"cp_kafka_rest_jersey_metrics_$1\"\n"
  }
}

