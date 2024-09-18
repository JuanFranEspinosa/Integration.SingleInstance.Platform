<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_accounts"></a> [accounts](#module\_accounts) | git@github.com:eVisionSoftware/Infrastructure.Modules.AccountMappings | n/a |
| <a name="module_single_instance"></a> [single\_instance](#module\_single\_instance) | git@github.com:eVisionSoftware/Infrastructure.SingleInstance.Deployment//aws/deployment | jfe/explaination |
| <a name="module_standard_tags"></a> [standard\_tags](#module\_standard\_tags) | git@github.com:eVisionSoftware/Infrastructure.Modules.StandardTags//create | 2.0.2 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arcgis_login_secret"></a> [arcgis\_login\_secret](#input\_arcgis\_login\_secret) | Access token to artitactory | `string` | n/a | yes |
| <a name="input_artifactory_access_token"></a> [artifactory\_access\_token](#input\_artifactory\_access\_token) | Access token to artitactory | `string` | n/a | yes |
| <a name="input_artifactory_username"></a> [artifactory\_username](#input\_artifactory\_username) | Artifactory username | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | AWS domain name | `string` | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name of the instance | `string` | `"SingleInstance.si.dev.enablon.io"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Key pair assigned at launch | `string` | `"integrationteam-key"` | no |
| <a name="input_packages"></a> [packages](#input\_packages) | n/a | <pre>list(object({<br>    product = string,<br>    version = string<br>  }))</pre> | <pre>[<br>  {<br>    "product": "eVision.OneVisionPackage.ShowCase",<br>    "version": "13.0.24"<br>  }<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-west-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "environment": "sandbox",<br>  "name": "singleinstance"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_Url"></a> [Url](#output\_Url) | n/a |
<!-- END_TF_DOCS -->