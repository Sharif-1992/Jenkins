package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformInitApply(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformBinary: "terraform",
		TerraformDir: "../Jenkins/", // Root folder with your *.tf files
	}

	// Run init and apply
	terraform.InitAndApply(t, terraformOptions)
}