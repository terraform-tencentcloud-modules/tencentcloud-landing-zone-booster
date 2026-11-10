# TKE Log Config (tke-log-config) Terraform Module

This module creates a **TKE cluster log config** (`tencentcloud_kubernetes_log_config`) — binding a CLS (Cloud Log Service) topic to a TKE cluster so that container/host logs are collected and shipped to CLS. The log configuration is assembled as a JSON `LogConfig` manifest (`apiVersion: cls.cloud.tencent.com/v1`) and written to the resource.

Key capabilities:

- **CLS detail configuration** — configures the CLS topic, region, log type, storage type/period, partition strategy, extract rule and index fields.
- **Three input sources** — `container_stdout` (container standard output), `container_file` (in-container log files), `host_file` (node host log files). Switch via `input_detail.type`.
- **Flexible pod selection** — select target pods by namespace, workload, or labels, with metadata/custom labels enrichment.
- **Mutual-exclusion guards** — the module enforces selection-rule conflicts at `terraform plan` time via `lifecycle.precondition` blocks (see [Mutual-exclusion rules](#mutual-exclusion-rules)).

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| tencentcloud | > 1.18.1 |

## Providers

| Provider | Source |
|----------|--------|
| tencentcloud | tencentcloudstack/tencentcloud |

## Resources

| Name | Type |
|------|------|
| `tencentcloud_kubernetes_log_config.tke_log_config_cls` | resource |

## Inputs

### Basic configuration

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| <a name="input_log_config_name"></a> [log\_config\_name](#input\_log\_config\_name) | `string` | yes | – | Log config name. |
| <a name="input_tke_cluster_id"></a> [tke\_cluster\_id](#input\_tke\_cluster\_id) | `string` | yes | – | TKE cluster ID. |
| <a name="input_logset_id"></a> [logset\_id](#input\_logset\_id) | `string` | yes | – | CLS logset ID. |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | `string` | no | `"tke"` | Cluster type: `tke` or `eks`. |

### `cls_detail` (CLS detail configuration)

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `topic_id` | `string` | yes | – | CLS topic ID. |
| `region` | `string` | no | `"ap-jakarta"` | Tencent Cloud region. |
| `log_type` | `string` | no | `"json_log"` | Log type: `minimalist_log`, `multiline_log`, `json_log`. |
| `log_format` | `string` | no | `"default"` | Log format. |
| `storage_type` | `string` | no | `"hot"` | Storage type: `hot`, `cold`. |
| `hot_period` | `number` | no | `15` | Hot storage period in days. |
| `partition_count` | `number` | no | `2` | Number of partitions. |
| `max_split_partitions` | `number` | no | `50` | Max partitions for auto-split. |
| `extract_rule` | `object` | no | `{}` | Log parsing/extract rule (see below). |
| `indexs` | `list(object)` | no | `[{index_name="namespace"},{index_name="pod_name"},{index_name="container_name"}]` | Index fields. Each element: `{ index_name = string }`. |

#### `extract_rule` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `backtracking` | `string` | no | `"0"` | Backtracking offset. |
| `is_gbk` | `string` | no | `"false"` | Whether encoding is GBK. |
| `json_standard` | `string` | no | `"true"` | Whether JSON is standard format. |
| `un_match_upload` | `string` | no | `"true"` | Upload unmatched logs. |
| `un_matched_key` | `string` | no | `"parseFailed"` | Key name for unmatched logs. |

### `input_detail` (log input configuration)

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `type` | `string` | no | `"container_stdout"` | Input type: `container_stdout`, `container_file`, `host_file`. |
| `container_stdout` | `object` | no | `{}` | Container standard output config (used when `type = "container_stdout"`). |
| `container_file` | `object` | no | – | In-container log file config (used when `type = "container_file"`). |
| `host_file` | `object` | no | – | Node host log file config (used when `type = "host_file"`). |

#### `container_stdout` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `all_containers` | `bool` | no | `false` | Collect all containers (mutex with `workloads`/`include_labels`/`exclude_labels`). |
| `namespace` | `string` | no | `null` | Comma-separated namespaces (mutex with `exclude_namespace`). |
| `exclude_namespace` | `string` | no | `null` | Comma-separated excluded namespaces (mutex with `namespace`). |
| `ns_label_selector` | `string` | no | `null` | Namespace label selector expression. |
| `container` | `string` | no | `null` | Container name filter (mutex with `workloads`). |
| `include_labels` | `map(string)` | no | `null` | Include pods with labels (mutex with `workloads`/`namespace`/`exclude_namespace`). |
| `exclude_labels` | `map(string)` | no | `null` | Exclude pods with labels (mutex with `workloads`/`namespace`/`exclude_namespace`). |
| `metadata_labels` | `list(string)` | no | `null` | Pod labels to collect as metadata. |
| `custom_labels` | `map(string)` | no | `null` | User-defined custom metadata. |
| `metadata_container` | `list(string)` | no | `["namespace","pod_name","pod_ip","pod_uid","container_id","container_name","image_name","cluster_id"]` | Metadata fields to collect. |
| `workloads` | `list(object)` | no | `null` | Workload-based selection (mutex with labels/container). Each: `{ kind = string, name = string, namespace = string, container = optional(string) }`; `kind` ∈ deployment/statefulset/daemonset/job/cronjob. |

#### `container_file` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `namespace` | `string` | no | `null` | Kubernetes namespace (single value; mutex with `exclude_namespace`). |
| `exclude_namespace` | `string` | no | `null` | Comma-separated excluded namespaces (mutex with `namespace`). |
| `ns_label_selector` | `string` | no | `null` | Namespace label selector expression. |
| `container` | `string` | no | `null` | Container name filter (`*` for all). |
| `log_path` | `string` | yes | – | Log file directory (no wildcards). |
| `file_pattern` | `string` | no | `"*.log"` | Log file name pattern (`*` and `?` supported). |
| `include_labels` | `map(string)` | no | `null` | Include pods with labels (mutex with `workload`). |
| `exclude_labels` | `map(string)` | no | `null` | Exclude pods with labels (mutex with `workload`). |
| `metadata_labels` | `list(string)` | no | `null` | Pod labels to collect as metadata. |
| `custom_labels` | `map(string)` | no | `null` | User-defined custom metadata. |
| `metadata_container` | `list(string)` | no | `["namespace","pod_name","pod_ip","pod_uid","container_id","container_name","image_name","cluster_id"]` | Metadata fields to collect. |
| `workload` | `object` | no | `null` | Single workload selection (mutex with labels). `{ name = string, container = optional(string) }`. |

#### `host_file` object

| Attribute | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `log_path` | `string` | yes | – | Log file directory (no wildcards). |
| `file_pattern` | `string` | no | `"*.log"` | Log file name pattern (`*` and `?` supported). |
| `custom_labels` | `map(string)` | no | `null` | User-defined custom metadata. |

## Mutual-exclusion rules

The module validates the following at `terraform plan` time (via `lifecycle.precondition`):

**`container_stdout`**
1. `all_containers = true` ⇒ cannot use `workloads`, `include_labels`, `exclude_labels`.
2. `workloads` set ⇒ cannot use `include_labels`, `exclude_labels`, `container`.
3. `include_labels`/`exclude_labels` set ⇒ cannot use `workloads`, `namespace`, `exclude_namespace`.

**`container_file`**
1. `workload` set ⇒ cannot use `include_labels`, `exclude_labels`.
2. `include_labels`/`exclude_labels` set ⇒ cannot use `workload`.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the Kubernetes log config. |

## Usage

### Collect all container stdout (default)

```hcl
module "tke_log_config" {
  source = "./modules/tke-log-config"

  log_config_name = "all-stdout-log"
  tke_cluster_id  = "cls-xxxxxxxx"
  logset_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  cls_detail = {
    topic_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    region   = "ap-jakarta"
  }

  input_detail = {
    type             = "container_stdout"
    container_stdout = {
      all_containers = true
    }
  }
}
```

### Collect log files from a specific namespace

```hcl
module "tke_log_config" {
  source = "./modules/tke-log-config"

  log_config_name = "app-log-files"
  tke_cluster_id  = "cls-xxxxxxxx"
  logset_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  cls_detail = {
    topic_id    = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    log_type    = "json_log"
    hot_period  = 30
    extract_rule = {
      json_standard = "true"
    }
  }

  input_detail = {
    type = "container_file"
    container_file = {
      namespace   = "app-team"
      log_path    = "/var/log/app"
      file_pattern = "*.log"
    }
  }
}
```

### Collect host files by labels (EKS)

```hcl
module "tke_log_config" {
  source = "./modules/tke-log-config"

  log_config_name = "node-host-log"
  tke_cluster_id  = "cls-yyyyyyyy"
  logset_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  cluster_type    = "eks"

  cls_detail = {
    topic_id        = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    storage_type    = "hot"
    partition_count = 4
  }

  input_detail = {
    type = "host_file"
    host_file = {
      log_path    = "/data/logs"
      file_pattern = "*.log"
      custom_labels = {
        env = "prod"
      }
    }
  }
}
```

> **Notes**:
> - `cls_detail` is converted internally from snake_case to the camelCase `clsDetail` JSON fields expected by the `LogConfig` manifest; you only need to supply the snake_case inputs.
> - `indexs` and `extract_rule` fall back to sensible defaults; the default `indexs` enables `namespace`, `pod_name`, `container_name`.
> - Respect the [mutual-exclusion rules](#mutual-exclusion-rules) — violations fail at `plan` time with a descriptive `error_message`.
