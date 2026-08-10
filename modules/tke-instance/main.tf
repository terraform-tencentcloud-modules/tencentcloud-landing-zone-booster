locals {
  cluster_id      = var.create_cluster ? tencentcloud_kubernetes_cluster.cluster[0].id : var.cluster_id
  kube_config_raw = concat(tencentcloud_kubernetes_cluster.cluster.*.kube_config, [""])[0]
  kube_config     = try(yamldecode(local.kube_config_raw), "")
}

resource "random_password" "worker_pwd" {
  length           = 12
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "tencentcloud_kubernetes_cluster" "cluster" {
  count = var.create_cluster ? 1 : 0

  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_cidr                    = var.network_type == "VPC-CNI" ? "" : var.cluster_cidr
  cluster_os                      = var.cluster_os
  cluster_level                   = var.cluster_level
  cluster_max_pod_num             = var.cluster_max_pod_num
  cluster_max_service_num         = var.cluster_max_service_num
  cluster_deploy_type             = var.cluster_deploy_type
  cluster_ipvs                    = var.cluster_ipvs
  cluster_desc                    = var.cluster_desc
  vpc_id                          = var.vpc_id
  vpc_cni_type                    = var.vpc_cni_type
  service_cidr                    = var.cluster_service_cidr
  network_type                    = var.network_type
  eni_subnet_ids                  = var.eni_subnet_ids
  claim_expired_seconds           = var.network_type == "VPC-CNI" ? var.claim_expired_seconds : null
  node_name_type                  = var.node_name_type
  kube_proxy_mode                 = var.kube_proxy_mode
  container_runtime               = var.container_runtime
  runtime_version                 = var.runtime_version
  deletion_protection             = var.deletion_protection

  auto_upgrade_cluster_level       = var.auto_upgrade_cluster_level
  is_non_static_ip_mode            = var.is_non_static_ip_mode
  ignore_cluster_cidr_conflict     = var.ignore_cluster_cidr_conflict
  ignore_service_cidr_conflict     = var.network_type == "VPC-CNI" ? var.ignore_service_cidr_conflict : null
  upgrade_instances_follow_cluster = var.upgrade_instances_follow_cluster

  dynamic "node_pool_global_config" {
    for_each = var.node_pool_global_config == null ? [] : [1]
    content {
      is_scale_in_enabled            = var.node_pool_global_config.is_scale_in_enabled
      expander                       = var.node_pool_global_config.expander
      ignore_daemon_sets_utilization = var.node_pool_global_config.ignore_daemon_sets_utilization
      max_concurrent_scale_in        = var.node_pool_global_config.max_concurrent_scale_in
      scale_in_delay                 = var.node_pool_global_config.scale_in_delay
      scale_in_unneeded_time         = var.node_pool_global_config.scale_in_unneeded_time
      scale_in_utilization_threshold = var.node_pool_global_config.scale_in_utilization_threshold
      skip_nodes_with_local_storage  = var.node_pool_global_config.skip_nodes_with_local_storage
      skip_nodes_with_system_pods    = var.node_pool_global_config.skip_nodes_with_system_pods
    }
  }

  log_agent {
    enabled          = var.enable_log_agent
    kubelet_root_dir = var.kubelet_root_dir
  }

  event_persistence {
    enabled                    = var.enable_event_persistence
    log_set_id                 = var.event_log_set_id
    topic_id                   = var.event_log_topic_id
    delete_event_log_and_topic = var.event_log_topic_id == null
  }

  cluster_audit {
    enabled                    = var.enable_cluster_audit_log
    log_set_id                 = var.cluster_audit_log_set_id
    topic_id                   = var.cluster_audit_log_topic_id
    delete_audit_log_and_topic = var.cluster_audit_log_topic_id == null
  }

  labels = var.labels
  tags   = var.tags

  lifecycle {
    ignore_changes = [
      cluster_intranet,
      cluster_intranet_subnet_id,
      cluster_internet,
      cluster_internet_security_group
    ]
  }
}

resource "tencentcloud_kubernetes_auth_attachment" "auth_attach" {
  count = var.enable_pod_identity ? 1 : 0

  cluster_id                              = local.cluster_id
  use_tke_default                         = var.use_tke_default
  issuer                                  = var.use_tke_default ? null : var.issuer
  jwks_uri                                = var.use_tke_default ? null : var.jwks_uri
  auto_create_discovery_anonymous_auth    = var.auto_create_discovery_anonymous_auth
  auto_create_oidc_config                 = var.auto_create_oidc_config
  auto_install_pod_identity_webhook_addon = var.auto_create_oidc_config ? true : var.auto_install_pod_identity_webhook_addon

  depends_on = [
    tencentcloud_kubernetes_cluster.cluster
  ]
}

resource "tencentcloud_kubernetes_log_config" "kubernetes_log_configs" {
  count = var.enable_log_agent ? 1 : 0

  cluster_id      = local.cluster_id
  cluster_type    = var.cluster_type
  log_config_name = var.log_config_name
  logset_id       = var.logset_id
  log_config      = jsonencode({
    "apiVersion" : "cls.cloud.tencent.com/v1",
    "kind" : "LogConfig",
    "metadata" : {
      "name" : var.log_config_name
    },
    "spec" : {
      "clsDetail" : {
        "extractRule" : {
          "backtracking" : "0",
          "isGBK" : "false",
          "jsonStandard" : "false",
          "unMatchUpload" : "false"
        },
        "indexs" : [
          {
            "indexName" : "namespace"
          },
          {
            "indexName" : "pod_name"
          },
          {
            "indexName" : "container_name"
          }
        ],
        "logFormat" : "default",
        "logType" : "minimalist_log",
        "maxSplitPartitions" : 0,
        "region" : "ap-shanghai",
        "storageType" : "",
      },
      "inputDetail" : {
        "containerStdout" : {
          "metadataContainer" : [
            "namespace",
            "pod_name",
            "pod_ip",
            "pod_uid",
            "container_id",
            "container_name",
            "image_name",
            "cluster_id"
          ],
          "nsLabelSelector" : "",
          "workloads" : [
            {
              "kind" : "deployment",
              "name" : "testlog1",
              "namespace" : "default"
            }
          ]
        },
        "type" : "container_stdout"
      }
    }
  })
}

resource "tencentcloud_kubernetes_health_check_policy" "kubernetes_health_check_policy" {
  for_each = { for policy in var.health_check_policies : policy.name => policy }
  
  cluster_id = local.cluster_id
  name       = each.value.name
  dynamic "rules" {
    for_each = each.value.rules
    content {
      name                = rules.value.name
      auto_repair_enabled = rules.value.auto_repair_enabled
      enabled             = rules.value.enabled
    }
  }
}