package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// For examples of using terratest and a basic case, check out the template repository:
// https://github.com/dnb-main/repo-template-terraform-module/blob/main/test/terraform_basic_test.go

func TestTerraform(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
	})

	terraform.InitAndPlan(t, terraformOptions)
}

func TestIAMApply(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
		NoColor:      true,
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	t.Run("Module should create IAM binding for SA in project", func(t *testing.T) {
		var allSaBindings map[string]Binding

		terraform.OutputStructE(t, terraformOptions, "all_sa_bindings", &allSaBindings)

		assert.Contains(t, allSaBindings, "bigquery-sa1-data-access-roles/bigquery.dataViewer")
	})
	t.Run("Module should be able to create IAM binding for SA external to project", func(t *testing.T) {
		var allSaBindings map[string]Binding

		terraform.OutputStructE(t, terraformOptions, "all_sa_bindings", &allSaBindings)
		assert.Contains(t, allSaBindings, "external_project_sa-roles/bigquery.dataViewer")
	})
	t.Run("Module should not be able to create IAM binding for identities that aren't a SA", func(t *testing.T) {
		var allSaBindings map[string]Binding

		terraform.OutputStructE(t, terraformOptions, "all_sa_bindings", &allSaBindings)
		assert.NotContains(t, allSaBindings, "not_a_service_account-roles/container.admin")
	})
}

func TestIAMFailureApply(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/failure_case",
		NoColor:      true,
	})

	defer terraform.Destroy(t, terraformOptions)

	t.Run("Module should fail when utilizing an unapproved role", func(t *testing.T) {

		_, err := terraform.InitAndApplyE(t, terraformOptions)
		assert.Error(t, err)
	})
}

type Binding struct {
	Condition []interface{}
	Id        string
	Member    string
	Project   string
	Role      string
}
