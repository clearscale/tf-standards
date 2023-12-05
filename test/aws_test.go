package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

type Account struct {
	ID       string `json:"id"`
	Key      string `json:"key"`
	Name     string `json:"name"`
	Provider string `json:"provider"`
	Prefix   struct {
		Dash struct {
			Full struct {
				Default struct {
					Default  string `json:"default"`
					Template struct {
						Resource string `json:"resource"`
					}
				} `json:"default"`
			} `json:"full"`
		} `json:"dash"`
		Dot struct {
			Full struct {
				Default  string `json:"default"`
				Template struct {
					Resource string `json:"resource"`
				}
			} `json:"full"`
		} `json:"dot"`
	} `json:"prefix"`
	Region struct {
		Default string `json:"default"`
		Title   string `json:"title"`
		Short   string `json:"short"`
	} `json:"region"`
}

type Accounts struct {
	AWS []Account `json:"aws"`
}

/**
 * Using default variables
 * TODO: Test the rest of the values
 */
func TestTerraformContextForAWSProviderDefault(t *testing.T) {
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../",
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	output := terraform.OutputJson(t, terraformOptions, "accounts")

	var accounts Accounts
	err := json.Unmarshal([]byte(output), &accounts)
	if err != nil {
		t.Fatalf("Failed to unmarshal output: %v", err)
	}

	// Dash notation
	expectedDefaultDashPrefixValue := "cs-pmod-shared"
	assert.Equal(t,
		expectedDefaultDashPrefixValue, accounts.AWS[0].Prefix.Dash.Full.Default.Default)
	expectedDefaultDashTemplateResource := "cs-pmod-shared-uswest1-{{resource}}"
	assert.Equal(t,
		expectedDefaultDashTemplateResource, accounts.AWS[0].Prefix.Dash.Full.Default.Template.Resource)

	// Dot notation
	expectedDefaultDotPrefixValue := "CsPmod.Shared"
	assert.Equal(t,
		expectedDefaultDotPrefixValue, accounts.AWS[0].Prefix.Dot.Full.Default)
	expectedDefaultDotTemplateResource := "CsPmod.Shared.Uswest1.Dev.{{resource}}"
	assert.Equal(t,
		expectedDefaultDotTemplateResource, accounts.AWS[0].Prefix.Dot.Full.Template.Resource)

	// Region formatting
	expectedRegionDefaultValue := "us-west-1"
	assert.Equal(t,
		expectedRegionDefaultValue, accounts.AWS[0].Region.Default)
	expectedRegionTitleValue := "Us-West-1"
	assert.Equal(t,
		expectedRegionTitleValue, accounts.AWS[0].Region.Title)
	expectedRegionShortValue := "uswest1"
	assert.Equal(t,
		expectedRegionShortValue, accounts.AWS[0].Region.Short)
}

/**
 * Pass custom variables
 * TODO: Test the rest of the values
 */
func TestTerraformContextForAWSProviderCustom(t *testing.T) {
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../",

		Vars: map[string]interface{}{
			"prefix": "test",
			"region": "us-east-1",
			"suffix": "terrasuffix",
		},
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	output := terraform.OutputJson(t, terraformOptions, "accounts")

	var accounts Accounts
	err := json.Unmarshal([]byte(output), &accounts)
	if err != nil {
		t.Fatalf("Failed to unmarshal output: %v", err)
	}

	// Dash notation
	expectedDefaultDashPrefixValue := "test-pmod-shared"
	assert.Equal(t,
		expectedDefaultDashPrefixValue, accounts.AWS[0].Prefix.Dash.Full.Default.Default)
	expectedDefaultDashTemplateResource := "test-pmod-shared-useast1-{{resource}}"
	assert.Equal(t,
		expectedDefaultDashTemplateResource, accounts.AWS[0].Prefix.Dash.Full.Default.Template.Resource)

	// Dot notation
	expectedDefaultDotPrefixValue := "TestPmod.Shared"
	assert.Equal(t,
		expectedDefaultDotPrefixValue, accounts.AWS[0].Prefix.Dot.Full.Default)
	expectedDefaultDotTemplateResource := "TestPmod.Shared.Useast1.Dev.{{resource}}"
	assert.Equal(t,
		expectedDefaultDotTemplateResource, accounts.AWS[0].Prefix.Dot.Full.Template.Resource)

	// Region formatting
	expectedRegionDefaultValue := "us-east-1"
	assert.Equal(t,
		expectedRegionDefaultValue, accounts.AWS[0].Region.Default)
	expectedRegionTitleValue := "Us-East-1"
	assert.Equal(t,
		expectedRegionTitleValue, accounts.AWS[0].Region.Title)
	expectedRegionShortValue := "useast1"
	assert.Equal(t,
		expectedRegionShortValue, accounts.AWS[0].Region.Short)
}
