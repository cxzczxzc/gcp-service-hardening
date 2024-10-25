# cloud-kms-module

This module allows you to create key rings, asymmetric and symmetric keys within your project. 
It also allows you to set Cloud KMS Owner, Encrypter, and Decrypter roles on keys as well as key rings.


## Cloud KMS - Details about Keys

Cloud KMS supports both symmteric and asymmteric keys. Depending on your requirements you should choose the right key. 
The type of key is determined by the `purpose` attribute of the `google_kms_crypto_key` resource. At a high level each key purpose is described below:

1. **ASYMMETRIC_SIGN** - Asymmetric keys used for signing purposes.
2. **ASYMMETRIC_DECRYPT** - Aysymmetric key used for encryption and decryption purposes.
3. **ENCRYPT_DECRYPT** - Symmetric key used for encryption and decryption. Only this key type supports auto rotation.
4. **MAC** - Symmetric key used for signing.

In addition to the above, the `google_kms_crypto_key` resource also has two important attributes: `algorithm` and `protection_level`.

The value of the `algorithm` depends on key purpose, and varies for each key purpose. [See this](https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm) for details about the supported algorithm for each key type. 

The value of `protection_level` can be either `SOFTWARE` or `HSM`. You should choose `HSM` when you want FIPS 140-2 Level 3 compliance. 
Otherwise, if you choose `SOFTWARE`, you'll get at least [FIPS 140-2 Level 1 compliance](https://cloud.google.com/kms/docs/protection-levels#:~:text=can%20be%20enabled.-,Software%20protection%20level,Cryptographic%20Primitives%20of%20the%20BCM). 

For supported regions for either type of `protection_level` on key, [check this.](https://cloud.google.com/kms/docs/locations)

## How to use the module

Go to `examples/basic` folder and look at the `variables.tf` file. 

The example contains scenarios that detail creation of every type of key. 

### Key Import

Importing external keys is possible with KMS, but not with Terraform. For importing external keys, you can follow the steps enlisted in this [guide](https://cloud.google.com/kms/docs/importing-a-key).
   
It is not possible to do imports directly via Terraform because there are multiple steps involving encrypting the key before sending it to Cloud KMS, and performing all those steps within terraform opens the door for accidentally leaking [senstive data](https://developer.hashicorp.com/terraform/language/state/sensitive-data) to logs or other insecure sources. 

It is recommended that you use `gcloud` to import the keys as it automates wrapping of the key before importing it. You can also build automation using client libaries or REST API, but you should ensure that any logs from that automation are not exposed to anyone to prevent accidentally leaking the external key. Access to that API should also be controlled.  

### Required Providers

The template repo contains a few required providers for the module repo, which specify module version ranges in the `./versions.tf` file. Versions will be updated and maintained by Dependabot. If unneeded for the given module, remove from the `./versions.tf` file in order to prevent unnecessary provider downloads during `terraform init`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.18.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.18.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_kms_crypto_key.asymmetric_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key) | resource |
| [google_kms_crypto_key.symmetric_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key) | resource |
| [google_kms_crypto_key.symmetric_key_with_rotation_period](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key) | resource |
| [google_kms_crypto_key_iam_member.decrypters_for_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key_iam_member) | resource |
| [google_kms_crypto_key_iam_member.encrypters_for_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key_iam_member) | resource |
| [google_kms_crypto_key_iam_member.operators_for_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key_iam_member) | resource |
| [google_kms_key_ring.key_ring](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring) | resource |
| [google_kms_key_ring_iam_member.decrypters_for_key_ring](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring_iam_member) | resource |
| [google_kms_key_ring_iam_member.encrypters_for_key_ring](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring_iam_member) | resource |
| [google_kms_key_ring_iam_member.operators_for_key_ring](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asymmetric_keys"></a> [asymmetric\_keys](#input\_asymmetric\_keys) | The key purpose for asymmetric keys can be ASYMMETRIC\_DECRYPT or ASYMMETRIC\_SIGN see this link for algorithms supported by each key purpose: https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm the possible value for protection level can be either SOFTWARE or HSM | <pre>map(object({<br>    asymmetric_key_name             = string<br>    asymmetric_key_purpose          = string<br>    asymmetric_key_algorithm        = string<br>    asymmetric_key_protection_level = string<br>    labels                          = optional(map(string))<br>  }))</pre> | `{}` | no |
| <a name="input_decrypters"></a> [decrypters](#input\_decrypters) | List of comma-separated principals for each key declared in set\_decrypters\_for. <br>  These principals will get roles/cloudkms.cryptoKeyDecrypter. This role<br>  contains the permissions required for using the key to decrypt data. <br>  The principals must start with the prefix that indicates the type of principal.<br>  Eg. "serviceAccount:", "user:", "group:" etc.<br><br>  For more information about roles and permissions check this: https://cloud.google.com/kms/docs/reference/permissions-and-roles | `list(string)` | `[]` | no |
| <a name="input_encrypters"></a> [encrypters](#input\_encrypters) | List of comma-separated principals for each key declared in set\_encrypters\_for. <br>  These principals will get roles/cloudkms.cryptoKeyEncrypter. This role<br>  contains the permissions required for using the key to encrypt data. <br>  The principals must start with the prefix that indicates the type of principal.<br>  Eg. "serviceAccount:", "user:", "group:" etc.<br><br>  For more information about roles and permissions check this: https://cloud.google.com/kms/docs/reference/permissions-and-roles | `list(string)` | `[]` | no |
| <a name="input_keyring"></a> [keyring](#input\_keyring) | Keyring name. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location for the keyring. | `string` | n/a | yes |
| <a name="input_operators"></a> [operators](#input\_operators) | List of comma-separated principals for each key declared in set\_operators\_for. <br>  These principals will get roles/cloudkms.cryptoOperator. This role<br>  contains the permissions required for using the key to encrypt, decrypt, sign, and verify data. <br>  The principals must start with the prefix that indicates the type of principal.<br>  Eg. "serviceAccount:", "user:", "group:" etc.<br><br>  For more information about roles and permissions check this: https://cloud.google.com/kms/docs/reference/permissions-and-roles | `list(string)` | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id where the keyring will be created. | `string` | n/a | yes |
| <a name="input_set_crypto_operators_for_keys"></a> [set\_crypto\_operators\_for\_keys](#input\_set\_crypto\_operators\_for\_keys) | Name of keys for which crypto operators will be set. | `list(string)` | `[]` | no |
| <a name="input_set_decrypters_for_keys"></a> [set\_decrypters\_for\_keys](#input\_set\_decrypters\_for\_keys) | Name of keys for which decrypters will be set. | `list(string)` | `[]` | no |
| <a name="input_set_encrypters_for_keys"></a> [set\_encrypters\_for\_keys](#input\_set\_encrypters\_for\_keys) | Name of keys for which encrypters will be set. | `list(string)` | `[]` | no |
| <a name="input_symmetric_keys"></a> [symmetric\_keys](#input\_symmetric\_keys) | The key purpose for symmetric keys can be either MAC or ENCRYPT\_DECRYPT see this link for algorithms supported by each key purpose: https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm the possible value for protection level can be either SOFTWARE or HSM | <pre>map(object({<br>    symmetric_key_name             = string<br>    symmetric_key_purpose          = string<br>    symmetric_key_algorithm        = string<br>    symmetric_key_protection_level = string<br>    labels                         = optional(map(string))<br>  }))</pre> | `{}` | no |
| <a name="input_symmetric_keys_auto_rotate"></a> [symmetric\_keys\_auto\_rotate](#input\_symmetric\_keys\_auto\_rotate) | automatic rotation of keys is only possible when the key purpose is ENCRYPT\_DECRYPT key purpose ENCRYPT\_DECRYPT only works with the algorithm GOOGLE\_SYMMETRIC\_ENCRYPTION the possible value for protection level can be either SOFTWARE or HSM | <pre>map(object({<br>    symmetric_key_name             = string<br>    symmetric_key_protection_level = string<br>    symmetric_key_rotation_period  = string<br>    labels                         = optional(map(string))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asymmetric_keys"></a> [asymmetric\_keys](#output\_asymmetric\_keys) | Map of generated asymmetric crypto keys. |
| <a name="output_symmetric_keys"></a> [symmetric\_keys](#output\_symmetric\_keys) | Map of generated symmetric crypto keys. |
| <a name="output_symmetric_keys_auto_rotate"></a> [symmetric\_keys\_auto\_rotate](#output\_symmetric\_keys\_auto\_rotate) | Map of generated symmetric crypto keys auto rotate. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
