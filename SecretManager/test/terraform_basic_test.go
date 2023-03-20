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
		// website::tag::1::Set the path to the Terraform code that will be tested.
		// The path to where our Terraform code is located
		TerraformDir: "../examples/basic",

		// 		Variables to pass to our Terraform code using -var options
		// 		Vars: map[string]interface{}{},

		// Variables to pass to our Terraform code using -var-file options
		//Uncomment VarFiles line below if you need to test locally.
		//VarFiles: []string{"example.auto.tfvars"},

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
		actualTestRegion := terraform.Output(t, terraformOptions, "my_test_region")
		//actualExampleList := terraform.OutputList(t, terraformOptions, "example_list")
		//actualExampleMap := terraform.OutputMap(t, terraformOptions, "example_map")

		// website::tag::3::Check the output against expected values.
		// Verify we're getting back the outputs we expect
		assert.Equal(t, "us-east4", actualTestRegion)
		//assert.Equal(t, expectedList, actualExampleList)
		//assert.Equal(t, expectedMap, actualExampleMap)
	}
}
