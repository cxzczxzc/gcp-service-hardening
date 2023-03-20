package test

import (
	"fmt"
	"os"
	"strconv"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraform(t *testing.T) {
	// tests should not run in parallel because they create clusters in the same project using different TFC workspaces
	// t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// website::tag::1::Set the path to the Terraform code that will be tested.
		// The path to where our Terraform code is located
		TerraformDir: "../examples/basic",

		// 		Variables to pass to our Terraform code using -var options
		// 		Vars: map[string]interface{}{},

		// Variables to pass to our Terraform code using -var-file options
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
		// 		actualTestRegion := terraform.Output(t, terraformOptions, "my_test_region")
		//actualExampleList := terraform.OutputList(t, terraformOptions, "example_list")
		//actualExampleMap := terraform.OutputMap(t, terraformOptions, "example_map")

		// website::tag::3::Check the output against expected values.
		// Verify we're getting back the outputs we expect
		//assert.Equal(t, "eu-west-1", actualTestRegion)
		//assert.Equal(t, expectedList, actualExampleList)
		//assert.Equal(t, expectedMap, actualExampleMap)
	}
}

func TestGKEModule(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/workload_id",
		NoColor:      true,
	})

	if os.Getenv("TF_COMMAND") != "apply" {
		terraform.InitAndPlan(t, terraformOptions)
	} else {
		defer terraform.Destroy(t, terraformOptions)

		errString, err := terraform.InitAndApplyE(t, terraformOptions)

		// When creating a cluster and deploying k8s resources to it wihtin the same run, the first apply may fail due to the cluster
		// not being ready to receive new resources. A second run in that case resolves the issue.
		if err != nil {
			fmt.Println(errString)
			terraform.Apply(t, terraformOptions)
		}

		workloadIdJobCompletions, err := strconv.Atoi(terraform.Output(t, terraformOptions, "job_demo_completions"))
		assert.Nil(t, err)
		assert.Greaterf(t, workloadIdJobCompletions, 0, fmt.Sprintf("job should complete at least once to validate workload ID has worked successfully. Got: %d", workloadIdJobCompletions))
	}
}
