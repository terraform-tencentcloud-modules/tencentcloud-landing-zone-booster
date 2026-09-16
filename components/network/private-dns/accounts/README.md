# tencentcloud-private-dns-accounts

This Terraform component associates Tencent Cloud accounts with Private DNS, enabling cross-account VPC binding for private zones.

After an account is associated, VPCs under that account can be bound to Private DNS zones.

## Usage

```hcl
module "private_dns_accounts" {
  source = "./tc-modules/components/network/private-dns/accounts"

  account_associations = {
    account_a = {
      account_uin = "100000000001"
    }
    account_b = {
      account_uin = "100000000002"
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| tencentcloud | >= 1.82.70 |

## Providers

| Name | Version |
|------|---------|
| tencentcloud | >= 1.82.70 |

## Resources

| Name | Type |
|------|------|
| tencentcloud_private_dns_account.accounts | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account_associations | Map of Private DNS account associations for cross-account VPC binding. Key is a unique identifier, value contains account_uin. | map(object({ account_uin = string })) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| account_association_ids | Map of account association keys to their IDs |
| account_associations | Complete Private DNS account association resource objects |
| account_association_details | Map of account association keys to their details, including account UIN, email, and nickname |
