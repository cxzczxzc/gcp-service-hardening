package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"log"
	"os"
	"testing"
)

func TestBuckets(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// website::tag::1::Set the path to the Terraform code that will be tested.
		// The path to where our Terraform code is located
		TerraformDir: "../examples/basic",

		// 		Variables to pass to our Terraform code using -var options
		// 		Vars: map[string]interface{}{},

		// Variables to pass to our Terraform code using -var-file options
		// VarFiles: []string{"example.auto.tfvars"},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	})

	// website::tag::2::Run "terraform init" and "terraform apply".
	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	if "apply" != os.Getenv("TF_COMMAND") {
		terraform.InitAndPlan(t, terraformOptions)
	} else {
		// website::tag::4::Clean up resources with "terraform destroy". Using "defer" runs the command at the end of the test, whether the test succeeds or fails.
		// At the end of the test, run `terraform destroy` to clean up any resources that were created
		defer terraform.Destroy(t, terraformOptions)

		terraform.InitAndApply(t, terraformOptions)

		// Run `terraform output` to get the values of output variables

		// Check bucket properties
		expectedVersioning := string("[map[enabled:true]]")
		actualTestRegion := terraform.Output(t, terraformOptions, "region")
		actualTestBucket := terraform.Output(t, terraformOptions, "bucket")
		actualTestVersioning := terraform.Output(t, terraformOptions, "versioning")
		actualTestStorageClass := terraform.Output(t, terraformOptions, "storage_class")

		assert.Equal(t, "us-east4", actualTestRegion)
		assert.Contains(t, actualTestBucket, "dnb-gcp-cloud-storage-terratest-bucket")
		assert.Equal(t, expectedVersioning, actualTestVersioning)
		assert.Equal(t, "STANDARD", actualTestStorageClass)

		// Check storage pubsub notification
		storageNotification := terraform.OutputMap(t, terraformOptions, "storage_notification")
		assert.NotEmpty(t, storageNotification)
	}
}

func TestBucketValidation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/production-grade",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	})

	// This will run `terraform init` and `terraform plan`. It's expected to fail due to a validation, so the error is catched.
	errString, _ := terraform.InitAndPlanE(t, terraformOptions)
	if assert.Contains(t, errString, "Validation: storage class for 'prod' environment must be MULTI_REGIONAL.") {
		log.Println("Error catched: validation was expected to be triggered and the plan to fail")
	}
}
