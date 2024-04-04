package test

import (
	"encoding/json"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

type NameDetails struct {
	General    string `json:"general"`
	Region     string `json:"region"`
	RegionCode string `json:"region_code"`
	Title      string `json:"title"`
}

type AWSNames struct {
	Dev    NameDetails `json:"dev"`
	Shared NameDetails `json:"shared"`
}

type Names struct {
	AWS AWSNames `json:"aws"`
}

type Output struct {
	Client  string `json:"client"`
	Env     string `json:"env"`
	Name    string `json:"name"`
	Names   Names  `json:"names"`
	Prefix  string `json:"prefix"`
	Project string `json:"project"`
	Region  string `json:"region"`
}

/**
 * Pass custom variables
 * TODO: Test the rest of the values
 */
func TestTerraformContextForAWSProviderCustom(t *testing.T) {
	t.Parallel()

	// Installl the provider.tf with defered deletion
	defer os.Remove("../provider.tf")
	files.CopyFile("./terraform/provider.tf", "../provider.tf")

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../",

		Vars: map[string]interface{}{
			"prefix":   "tst",
			"region":   "us-west-2",
			"name":     "terratest",
			"function": "fx",
			"suffix":   "sf",
			"accounts": []map[string]interface{}{
				{
					"id":       "*",
					"name":     "dev",
					"provider": "aws",
					"key":      "current",
					"region":   "us-east-1",
				}, {
					"id":       "*",
					"name":     "shared",
					"provider": "aws",
					"key":      "shared",
				},
			},
		},
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of the names output variable.
	output := terraform.OutputJson(t, terraformOptions, "names")

	var names Names
	err := json.Unmarshal([]byte(output), &names)
	if err != nil {
		t.Fatalf("Failed to unmarshal output: %v", err)
	}

	// Test the values from the `dev` environment in AWS names
	assert.Equal(t, "tst-pmod-dev-use1-terratest-fx-sf", names.AWS.Dev.General)
	assert.Equal(t, "us-east-1", names.AWS.Dev.Region)
	assert.Equal(t, "use1", names.AWS.Dev.RegionCode)
	assert.Equal(t, "TstPmod.Dev.USE1.Terratest.Fx.Sf", names.AWS.Dev.Title)

	// Test the values from the `shared` environment in AWS names
	assert.Equal(t, "tst-pmod-shared-usw2-dev-terratest-fx-sf", names.AWS.Shared.General)
	assert.Equal(t, "us-west-2", names.AWS.Shared.Region)
	assert.Equal(t, "usw2", names.AWS.Shared.RegionCode)
	assert.Equal(t, "TstPmod.Shared.USW2.Dev.Terratest.Fx.Sf", names.AWS.Shared.Title)
}
