package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test initializing and applying the Terraform configuration
func TestTerraformInitApply(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformBinary: "terraform",
		TerraformDir:    "../vmtest/",
	}
	terraform.InitAndApply(t, terraformOptions)
}

// Test destroying the Terraform resources after apply
func TestTerraformDestroy(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformBinary: "terraform",
		TerraformDir:    "../vmtest/",
	}
	// Ensure resources are destroyed at the end
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}