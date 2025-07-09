.PHONY: all install-tools validate fmt docs

all: install-tools validate fmt docs

install-tools:
	go install github.com/terraform-docs/terraform-docs@latest

docs:
	@echo "Generating documentation for root and modules..."
	terraform-docs markdown document . --output-file README.md --output-mode inject --hide modules
	for dir in modules/*; do \
		if [ -d "$$dir" ]; then \
			echo "Processing $$dir..."; \
			(cd "$$dir" && terraform-docs markdown document . --output-file README.md --output-mode inject --hide modules) || echo "Skipped: $$dir"; \
		fi \
	done

fmt:
	terraform fmt -recursive

validate:
	terraform init -backend=false
	terraform validate
	@echo "Cleaning up initialization files..."
	rm -rf .terraform terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl
