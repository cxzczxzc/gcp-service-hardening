package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func validateMigInstanceGroup(t *testing.T, mig string) {
	fmt.Printf("actualTestMigInstanceGroup = %v\n", mig)
	assert.Contains(t, mig, "terratest-modules127c1f2e744f8")
	assert.Contains(t, mig, "us-east4")
	assert.Contains(t, mig, "example")
}

func TestTerraform(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// website::tag::1::Set the path to the Terraform code that will be tested.
		// The path to where our Terraform code is located
		TerraformDir: "../examples/basic",
		NoColor:      true,
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
		//actualTestRegion := terraform.Output(t, terraformOptions, "my_test_region")
		actualTestInstanceTemplateName := terraform.Output(t, terraformOptions, "instance_template_name")
		actualTestInstanceTemplateTags := terraform.OutputList(t, terraformOptions, "instance_template_tags")
		actualTestmigInstanceGroupManagerRegion := terraform.Output(t, terraformOptions, "mig_instance_group_manager_region")
		actualTestmigInstanceGroup := terraform.Output(t, terraformOptions, "mig_instance_group")

		fmt.Printf("actualTestInstanceTemplateName = %v\n", actualTestInstanceTemplateName)
		fmt.Printf("actualTestInstanceTemplateTags = %v\n", actualTestInstanceTemplateTags)
		fmt.Printf("actualTestmigInstanceGroupManagerRegion = %v\n", actualTestmigInstanceGroupManagerRegion)

		validateMigInstanceGroup(t, actualTestmigInstanceGroup)
		assert.Contains(t, actualTestInstanceTemplateTags, "ssh-in")
		assert.Equal(t, "us-east4", actualTestmigInstanceGroupManagerRegion)
	}
}

func TestTerraformLinux(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/linux",
		NoColor:      true,
	})

	if "apply" != os.Getenv("TF_COMMAND") {
		terraform.InitAndPlan(t, terraformOptions)
	} else {
		defer terraform.Destroy(t, terraformOptions)

		terraform.InitAndApply(t, terraformOptions)

		actualTestInstanceTemplateName := terraform.Output(t, terraformOptions, "instance_template_name")
		actualTestInstanceTemplateTags := terraform.OutputList(t, terraformOptions, "instance_template_tags")
		actualTestmigInstanceGroupManagerRegion := terraform.Output(t, terraformOptions, "mig_instance_group_manager_region")
		actualTestmigInstanceGroup := terraform.Output(t, terraformOptions, "mig_instance_group")

		fmt.Printf("actualTestInstanceTemplateName = %v\n", actualTestInstanceTemplateName)
		fmt.Printf("actualTestInstanceTemplateTags = %v\n", actualTestInstanceTemplateTags)
		fmt.Printf("actualTestmigInstanceGroupManagerRegion = %v\n", actualTestmigInstanceGroupManagerRegion)

		validateMigInstanceGroup(t, actualTestmigInstanceGroup)
		assert.Contains(t, actualTestInstanceTemplateTags, "ssh-in")
		assert.Contains(t, actualTestInstanceTemplateName, "linux-example-app1")
		assert.Equal(t, "us-east4", actualTestmigInstanceGroupManagerRegion)
	}
}

func TestTerraformWin(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/windows",
		NoColor:      true,
	})

	if "apply" != os.Getenv("TF_COMMAND") {
		terraform.InitAndPlan(t, terraformOptions)
	} else {
		defer terraform.Destroy(t, terraformOptions)

		terraform.InitAndApply(t, terraformOptions)

		actualTestInstanceTemplateName := terraform.Output(t, terraformOptions, "instance_template_name")
		actualTestInstanceTemplateTags := terraform.OutputList(t, terraformOptions, "instance_template_tags")
		actualTestmigInstanceGroupManagerRegion := terraform.Output(t, terraformOptions, "mig_instance_group_manager_region")
		actualTestmigInstanceGroup := terraform.Output(t, terraformOptions, "mig_instance_group")

		fmt.Printf("actualTestInstanceTemplateName = %v\n", actualTestInstanceTemplateName)
		fmt.Printf("actualTestInstanceTemplateTags = %v\n", actualTestInstanceTemplateTags)
		fmt.Printf("actualTestmigInstanceGroupManagerRegion = %v\n", actualTestmigInstanceGroupManagerRegion)

		validateMigInstanceGroup(t, actualTestmigInstanceGroup)
		assert.Contains(t, actualTestInstanceTemplateTags, "rdp-in")
		assert.Contains(t, actualTestInstanceTemplateName, "win-example-app1")
		assert.Equal(t, "us-east4", actualTestmigInstanceGroupManagerRegion)
	}
}
