.ONESHELL:
PROJECT_DIR = ${CURDIR}

fmt:
	@echo "Running Terraform Format..."
	terraform fmt -recursive .
init:
	@echo
	@echo "Running Terraform init..."
	cd example/production && terraform init
plan:
	@echo
	@echo "Running Terraform Plan and Converting it to json..."
	cd example/production && terraform plan --out tfplan.binary
	cd example/production && terraform show -json tfplan.binary | jq '.' > tfplan.json
	@echo "Terraform Plan has been generated to `pwd`/example/production/tfplan.json."
check:
	@echo
	@echo "Starting Terraform Check from Checkov..."
# If you want to check external modules as well
# checkov --framework terraform --download-external-modules false --external-modules-download-path ../external-modules -d .
	checkov --framework terraform -d .
	@echo "Terraform Checks have been Completed."
check-tfplan:
	@echo
	@echo "Starting Terraform Plan Check from Checkov..."
	checkov --framework terraform_plan -f example/production/tfplan.json
	@echo "Terraform Plan Checks have been Completed."
test: fmt init plan check check-tfplan
test-apply: test
	@echo
	@echo "Running Terraform Apply after testing..."
# Not setting it to -auto-approve for now
	cd example/production && terraform apply "tfplan.binary"
clean:
	@echo
	@echo "Destroying Infrastructure Created by Make..."
	cd example/production && terraform destroy -auto-approve

.PHONY: *
