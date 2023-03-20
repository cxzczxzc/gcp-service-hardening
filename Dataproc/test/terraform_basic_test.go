package test

import (
	"fmt"
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
		TerraformDir: "../examples/basic",

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

		t.Run("Validate expected master and workers", func(t *testing.T) {

			// Generate expected master and worker names using the cluster name
			clusterName := terraform.Output(t, terraformOptions, "cluster_name")
			expectedMasters := []string{fmt.Sprintf("%s-m", clusterName)}
			expectedWorkers := []string{
				fmt.Sprintf("%s-w-0", clusterName),
				fmt.Sprintf("%s-w-1", clusterName),
			}

			// Get master and worker lists from outputs
			masters := terraform.OutputList(t, terraformOptions, "cluster_master_instance_names")
			workers := terraform.OutputList(t, terraformOptions, "cluster_worker_instance_names")

			// Check master and worker list match
			assert.ElementsMatch(t, masters, expectedMasters)
			assert.ElementsMatch(t, workers, expectedWorkers)
		})

		t.Run("Validate expected http port keys", func(t *testing.T) {
			// Check http port has some expected keys
			expectedHttpPortsKeys := []string{"HBase"}
			httpPorts := terraform.OutputMap(t, terraformOptions, "cluster_http_ports")

			httpPortsKeys := []string{}
			for key := range httpPorts {
				httpPortsKeys = append(httpPortsKeys, key)
			}

			for _, key := range expectedHttpPortsKeys {
				assert.Contains(t, httpPortsKeys, key)
			}
		})
	}
}
