# gcp-service-hardening
## Summary
This repository provides a collection of example Terraform templates for common GCP resources with security baked in.

The purpose of this collection is to provide 70-80% of the security configuration that you might need to do for each resource type for most security-concious customers. This helps you minimize the amount of research you need to do every time that you're creating new resources.

Each repository contains documentation in the form of a README.md file that specifies what security frameworks, standards, and benchmarks were applied to the templates.


## Test GCP Project
Currently the host GCP project for testing deployments of templates in this repository is jonacto@'s "service-hardening-test" project.


## Cloud Build Pipeline

## Triggers
Within the service-hardening-test project there are 2 main triggers. 
1. First is the `cloud-build-terraform-image` which builds a Docker image with Terraform pre-installed. This image is used in the second trigger. The repository for this trigger is [jonacto-google/cloudbuild-terraform-image](https://github.com/jonacto-google/cloudbuild-terraform-image). This trigger activates on pushes to the main branch of the repository.

2. The second trigger is `service-hardening-pr`. This trigger is in charge of watching for changes to the main branch of [cxzczxzc/gcp-service-hardening](https://github.com/cxzczxzc/gcp-service-hardening) and running a plan/apply. This pipeline plans, applies, and destroys back-to-back. If you need to persist resources without destroying them, comment out lines 15-18 in cloudbuild.yaml. Just please remember to uncomment them again when you're done.


## Local Development
1. Make sure you have GCloud SDK, Terraform, and Checkov installed locall (see Required Software Installations section).
2. Authenticate to GCP via the gcloud cli with the following command and follow the subsequent prompts in the CLI:

```
gcloud auth application-default login
```

- Using this command will create [Application Default Credentials](https://cloud.google.com/docs/authentication/application-default-credentials#personal) that Terraform can pick up and use to plan/apply without needing to manually pass in secrets.
3. Clone the [repository](https://github.com/cxzczxzc/gcp-service-hardening)
4. cd into the local repository directory
5. Run ``` terraform init```
6. Before committing code to the main branch, test your working branch locally by doing some or all of the following:
```
terraform fmt
``` 
```
terraform validate
```
```
terraform plan
```
```
terraform apply
```
```
checkov --directory .
```


## Policy as Code (PaC)
For the time being, Checkov will be used as a PaC check to make sure we don't intriduce any common security misconfigurations.

You can run Checkov locally by installing it (see install instructions below) and running the following command within the gcp-service-hardening repository root:
```
checkov --quiet --compact --directory . --framework terraform --output cli --output-file-path .
```

This will create the results_cli.txt file in the repository root. If you open this file you will see the failing policy checks.


## Future plans for validating terraform:
We plan on eventually moving away from Checkov and use [Policy Validation](https://cloud.google.com/docs/terraform/policy-validation) instead, as it is a GCP native feature.


## Required Software Installations
GCloud SDK: https://cloud.google.com/sdk/docs/install

Terraform: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

Checkov: https://www.checkov.io/2.Basics/Installing%20Checkov.html
