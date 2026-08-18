# terraform-tencentcloud-cls


A terraform module used for create TencentCloud CLS instance.

## Examples
- simple instance
```hcl
provider "tencentcloud" {
  region = "ap-shanghai"
}
module "cls" {
  logset_name = "ys-test-logset"
  logset_tags = {
    test="testTags"
  }

  topic_name = "test-topic"
  auto_split = false
  max_split_partitions = 40
  storage_type = "cold"
  period = 15
  topic_tags = {
    test="testTags"
  }

  index_rule = [{
    full_text = [{
      case_sensitive = false
      tokenizer = "test"
      contain_z_h=false
    }]
    key_value = []
    tag=[]
  }]
}
```

## Inputs

| Name                    | Description                                                                                                                                                                                                                      | Type        | Default | Required |
|-------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|---------|:--------:|
| region                  | The topic and logset region.                                                                                                                                                                                                     | string      | string  |   yes    |
| logset_name             | The logset name.                                                                                                                                                                                                                 | string      | 1       |   yes    |
| role_name               | If assumer_uin is not empty, it indicates the service provider who creates the logset.                                                                                                                                           | string      | string  |   yes    |
| logset_tags             | Tag description list.                                                                                                                                                                                                            | map(string) | {}      |    no    |
| topic_name              | Log topic name.                                                                                                                                                                                                                  | string      | null    |   yes    |
| auto_split              | Whether to enable automatic split. Default value: true                                                                                                                                                                           | bool        | true    |    no    |
| max_split_partitions    | Maximum number of partitions to split into for this topic if automatic split is enabled. Default value: 50.                                                                                                                      | number      | 50      |    no    |
| period                  | Lifecycle in days. Value range: 1~366. Default value: 30 .                                                                                                                                                                       | number      | 30      |    no    |
| topic_tags              | Tag description list.                                                                                                                                                                                                            | map(string) | {}      |    no    |
| include_internal_fields | Internal field marker of full-text index. Default value: false. Valid value: false: excluding internal fields; true: including internal fields                                                                                   | bool        | false   |    no    |
| metadata_flag           | Metadata flag. Default value: 0. Valid value: 0: full-text index (including the metadata field with key-value index enabled); 1: full-text index (including all metadata fields); 2: full-text index (excluding metadata fields) | number      | 0       |    no    |
| rule                    | Index rule .                                                                                                                                                                                                                     | set(object) | []      |    no    |


## Outputs

| Name               | Description              |
|--------------------|--------------------------|
| logset_id          | the ids of logset        |
| topic_id           | the states of topic      |
| index_id           | the public ips of index  |

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
