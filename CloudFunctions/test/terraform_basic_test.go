package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
)

func TestTerraform(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// website::tag::1::Set the path to the Terraform code that will be tested.
		// The path to where our Terraform code is located
		TerraformDir: "../examples/basic/provision_httpfunc",

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

		expectedRegion := "us-east4"
		expectedSAemaildomain := "gserviceaccount.com"

		t.Run("Validate http CloudFunction", func(t *testing.T) {

			region := terraform.Output(t, terraformOptions, "httpfunc_region")
			assert.Equal(t, expectedRegion, region)

			saemail := terraform.Output(t, terraformOptions, "httpfunc_service_account_email")
			assert.Contains(t, saemail, expectedSAemaildomain)

			triggerurl := terraform.Output(t, terraformOptions, "httpfunc_cloudfunction_https_trigger_url")
			assert.Contains(t, triggerurl, "https")

			cloudfuncid := terraform.Output(t, terraformOptions, "httpfunc_cloudfunction_id")
			assert.NotEmpty(t, cloudfuncid)

		})

		t.Run("Validate pubsub CloudFunction", func(t *testing.T) {

			region := terraform.Output(t, terraformOptions, "pubsubfunc_region")
			assert.Equal(t, expectedRegion, region)

			saemail := terraform.Output(t, terraformOptions, "pubsubfunc_service_account_email")
			assert.Contains(t, saemail, expectedSAemaildomain)

			cloudfuncid := terraform.Output(t, terraformOptions, "pubsubfunc_cloudfunction_id")
			assert.NotEmpty(t, cloudfuncid)

		})

		t.Run("Validate http CloudFunction", func(t *testing.T) {

			region := terraform.Output(t, terraformOptions, "storagefunc_region")
			assert.Equal(t, expectedRegion, region)

			saemail := terraform.Output(t, terraformOptions, "storagefunc_service_account_email")
			assert.Contains(t, saemail, expectedSAemaildomain)

			cloudfuncid := terraform.Output(t, terraformOptions, "storagefunc_cloudfunction_id")
			assert.NotEmpty(t, cloudfuncid)

		})

	}
}
