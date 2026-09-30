# terraform-tencentcloud-tke-cluster-endpoint

Terraform module which manages the access endpoints (public Internet access and private intranet access) of an **existing** TencentCloud Kubernetes Engine (TKE) cluster.

The following resources are included.

* [Kubernetes Cluster Endpoint](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/kubernetes_cluster_endpoint)

This module configures the cluster's kube-apiserver access entry points. It does **not** create the cluster itself — you must provide the ID of a cluster that has already been provisioned. The endpoint resource is created only when either public access or private access is enabled.

## Usage

```hcl
module "tke_cluster_endpoint" {
  source = "git::https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-cluster-endpoint.git"

  # ID of an existing TKE cluster
  cluster_id = "cls-xxxxxxxx"

  # Enable public (Internet) access to the cluster
  cluster_public_access    = true
  cluster_security_group_id = "sg-xxxxxxxx" # Security group guarding the public endpoint

  # (Optional) Custom domain for the public endpoint
  cluster_internet_domain = "k8s.example.com"

  # Enable private (intranet) access to the cluster
  cluster_private_access           = true
  cluster_private_access_subnet_id = "subnet-xxxxxxxx" # Subnet for the private endpoint

  # (Optional) Custom domain for the private endpoint
  cluster_intranet_domain = "k8s-intranet.example.com"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_id | ID of an existing TKE cluster whose endpoints will be managed. | string | n/a | yes |
| cluster_public_access | Specify whether to open cluster public (Internet) access. | bool | false | no |
| cluster_internet_domain | Domain name for cluster kube-apiserver Internet access. Be careful if you modify this value, the `cluster_external_endpoint` (public endpoint) may be changed automatically too. | string | null | no |
| extensive_parameters | Extensive parameters for cluster kube-apiserver Internet access. | string | null | no |
| cluster_security_group_id | Security group id used to guard the cluster public access endpoint. | string | null | no |
| cluster_private_access | Specify whether to open cluster private (intranet) access. | bool | false | no |
| cluster_intranet_domain | Domain name for cluster kube-apiserver intranet access. Be careful if you modify this value, the `pgw_endpoint` (private endpoint) may be changed automatically too. | string | null | no |
| cluster_private_access_subnet_id | Subnet id used for cluster private access. | string | null | no |

## Outputs

| Name | Description |
|:---:|:---|
| cluster_endpoint | Cluster public endpoint if public access / endpoint is enabled. Empty string otherwise. |
| cluster_intranet_endpoint | Cluster private endpoint if private access / endpoint is enabled. Empty string otherwise. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-tke-cluster-endpoint)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| tencentcloud | >= 1.81.145 |
