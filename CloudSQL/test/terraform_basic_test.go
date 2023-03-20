package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
)

func TestPostgresqlTerraform(t *testing.T) {
	t.Parallel()

	// PostgreSQL
	terraformOptionsPostgreSql := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic/postgresql",
		NoColor:      true,
	})

	// website::tag::2::Run "terraform init" and "terraform apply".
	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	if "apply" != os.Getenv("TF_COMMAND") {
		terraform.InitAndPlan(t, terraformOptionsPostgreSql)
	} else {
		// website::tag::4::Clean up resources with "terraform destroy". Using "defer" runs the command at the end of the test, whether the test succeeds or fails.
		// At the end of the test, run `terraform destroy` to clean up any resources that were created
		defer terraform.Destroy(t, terraformOptionsPostgreSql)

		terraform.InitAndApply(t, terraformOptionsPostgreSql)

		t.Run("Validate postgres", func(t *testing.T) {

			name := terraform.Output(t, terraformOptionsPostgreSql, "name")
			assert.NotEmpty(t, name)

			psql_conn := terraform.Output(t, terraformOptionsPostgreSql, "psql_conn")
			assert.NotEmpty(t, psql_conn)
		})
	}
}

func TestMssqlTerraform(t *testing.T) {
	t.Parallel()

	// SQL Server
	terraformOptionsMSSql := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic/mssql",
		NoColor:      true,
	})

	// website::tag::2::Run "terraform init" and "terraform apply".
	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	if "apply" != os.Getenv("TF_COMMAND") {
		terraform.InitAndPlan(t, terraformOptionsMSSql)
	} else {
		// website::tag::4::Clean up resources with "terraform destroy". Using "defer" runs the command at the end of the test, whether the test succeeds or fails.
		// At the end of the test, run `terraform destroy` to clean up any resources that were created
		defer terraform.Destroy(t, terraformOptionsMSSql)

		terraform.InitAndApply(t, terraformOptionsMSSql)

		t.Run("Validate mssql", func(t *testing.T) {

			name := terraform.Output(t, terraformOptionsMSSql, "name")
			assert.NotEmpty(t, name)

			mssql_conn := terraform.Output(t, terraformOptionsMSSql, "mssql_conn")
			assert.NotEmpty(t, mssql_conn)

			private_ip_address := terraform.Output(t, terraformOptionsMSSql, "private_ip_address")
			assert.NotEmpty(t, private_ip_address)
		})
	}
}

func TestMysqlTerraform(t *testing.T) {
	t.Parallel()

	// MySQL
	terraformOptionsMySql := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic/mysql",
		NoColor:      true,
	})

	// website::tag::2::Run "terraform init" and "terraform apply".
	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	if "apply" != os.Getenv("TF_COMMAND") {
		terraform.InitAndPlan(t, terraformOptionsMySql)
	} else {
		// website::tag::4::Clean up resources with "terraform destroy". Using "defer" runs the command at the end of the test, whether the test succeeds or fails.
		// At the end of the test, run `terraform destroy` to clean up any resources that were created
		defer terraform.Destroy(t, terraformOptionsMySql)

		terraform.InitAndApply(t, terraformOptionsMySql)

		t.Run("Validate mysql", func(t *testing.T) {

			name := terraform.Output(t, terraformOptionsMySql, "name")
			assert.NotEmpty(t, name)

			mysql_conn := terraform.Output(t, terraformOptionsMySql, "mysql_conn")
			assert.NotEmpty(t, mysql_conn)
		})
	}
}
