# terraform-google-dnb_gcp_kms

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

Here's the sample code:
```
module "kms" {
  source                     = "../.."
  project_id                 = var.project_id
  location                   = var.location
  keyring                    = var.keyring
  asymmetric_keys            = var.asymmetric_keys
  symmetric_keys_auto_rotate = var.symmetric_keys_auto_rotate
  symmetric_keys             = var.symmetric_keys
}

module "kms_iam" {
  source     = "../../kms_iam/"
  project_id = var.project_id
  keyring    = var.keyring
  location   = var.location

  owners                   = var.key_owners
  set_owners_for_keys      = var.keys_to_set_owners_for
  set_owners_for_key_rings = var.key_rings_to_set_owners_for

  decrypters                   = var.key_decrypters
  set_decrypters_for_keys      = var.keys_to_set_decrypters_for
  set_decrypters_for_key_rings = var.key_rings_to_set_decrypters_for

  encrypters                   = var.key_encrypters
  set_encrypters_for_keys      = var.keys_to_set_encrypters_for
  set_encrypters_for_key_rings = var.key_rings_to_set_encrypters_for

  depends_on = [
    module.kms
  ]
}
```

### Required Providers

The template repo contains a few required providers for the module repo, which specify module version ranges in the `./versions.tf` file. Versions will be updated and maintained by Dependabot. If unneeded for the given module, remove from the `./versions.tf` file in order to prevent unnecessary provider downloads during `terraform init`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.18.0 |

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
| [google_kms_key_ring.key_ring](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asymmetric_keys"></a> [asymmetric\_keys](#input\_asymmetric\_keys) | The key purpose for asymmetric keys can be ASYMMETRIC\_DECRYPT or ASYMMETRIC\_SIGN see this link for algorithms supported by each key purpose: https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm the possible value for protection level can be either SOFTWARE or HSM | <pre>map(object({<br>    asymmetric_key_name             = string<br>    asymmetric_key_purpose          = string<br>    asymmetric_key_algorithm        = string<br>    asymmetric_key_protection_level = string<br>    labels                          = optional(map(string))<br>  }))</pre> | `{}` | no |
| <a name="input_keyring"></a> [keyring](#input\_keyring) | Keyring name. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location for the keyring. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id where the keyring will be created. | `string` | n/a | yes |
| <a name="input_symmetric_keys"></a> [symmetric\_keys](#input\_symmetric\_keys) | The key purpose for symmetric keys can be either MAC or ENCRYPT\_DECRYPT see this link for algorithms supported by each key purpose: https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm the possible value for protection level can be either SOFTWARE or HSM | <pre>map(object({<br>    symmetric_key_name             = string<br>    symmetric_key_purpose          = string<br>    symmetric_key_algorithm        = string<br>    symmetric_key_protection_level = string<br>    labels                         = optional(map(string))<br>  }))</pre> | `{}` | no |
| <a name="input_symmetric_keys_auto_rotate"></a> [symmetric\_keys\_auto\_rotate](#input\_symmetric\_keys\_auto\_rotate) | automatic rotation of keys is only possible when the key purpose is ENCRYPT\_DECRYPT key purpose ENCRYPT\_DECRYPT only works with the algorithm GOOGLE\_SYMMETRIC\_ENCRYPTION the possible value for protection level can be either SOFTWARE or HSM | <pre>map(object({<br>    symmetric_key_name             = string<br>    symmetric_key_protection_level = string<br>    symmetric_key_rotation_period  = string<br>    labels                         = optional(map(string))<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
