package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// For examples of using terratest and a basic case, check out the template repository
// https://github.com/dnb-main/repo-template-terraform-module/blob/main/test/terraform_basic_test.go

func TestTerraform(t *testing.T) {
	t.Parallel()
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
	})
	terraform.InitAndPlan(t, terraformOptions)
}