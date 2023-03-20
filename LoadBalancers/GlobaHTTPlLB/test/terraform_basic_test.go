package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraform(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/basic",
		NoColor:      true,
	})

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	if "apply" != os.Getenv("TF_COMMAND") {
		terraform.InitAndPlan(t, terraformOptions)
	} else {
		// At the end of the test, run `terraform destroy` to clean up any resources that were created
		defer terraform.Destroy(t, terraformOptions)

		terraform.InitAndApply(t, terraformOptions)

		// Run `terraform output` to get the values of output variables
		proxy := terraform.Output(t, terraformOptions, "https_proxy")
		urlMap := terraform.Output(t, terraformOptions, "url_map")

		// Verify we're getting back the outputs we expect
		assert.Equal(t, "https-lb-https-proxy", proxy)
		assert.Equal(t, "https-lb-url-map", urlMap)
	}
}
