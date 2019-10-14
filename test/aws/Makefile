name := $(shell cat terraform.tfvars | grep name | grep -oe '".*"')
environment := $(shell cat terraform.tfvars | grep environment | grep -oe '".*"')
region := $(shell cat terraform.tfvars | grep region | grep -oe '".*"')

uuid := $(shell uuidgen)
owner := $(shell whoami)
branch := $(shell git rev-parse --abbrev-ref HEAD)
commit := $(shell git rev-parse --short HEAD)

key_name := $(name)-$(environment)-$(region)-bastion


.PHONY: clean
clean:
	@ rm -f *.pub *.pem $(key_name) && \
	  rm -rf .terraform terraform.tfstate terraform.tfstate.backup

.PHONY: keys
keys:
	@ ssh-keygen -f $(key_name) -t rsa -N '' 1> /dev/null && \
	  chmod 400 $(key_name) && \
	  mv $(key_name) $(key_name).pem

.PHONY: init
init:
	@ terraform init

.PHONY: validate
validate:
	@ terraform validate \
	    -var uuid=$(uuid) \
	    -var owner=$(owner) \
	    -var git_branch=$(branch) \
	    -var git_commit=$(commit) \
		-var bastion_key_name=$(key_name)

.PHONY: plan
plan:
	@ terraform plan \
	    -var uuid=$(uuid) \
	    -var owner=$(owner) \
	    -var git_branch=$(branch) \
	    -var git_commit=$(commit) \
		-var bastion_key_name=$(key_name)

.PHONY: apply
apply:
	@ terraform apply \
	    -var uuid=$(uuid) \
	    -var owner=$(owner) \
	    -var git_branch=$(branch) \
	    -var git_commit=$(commit) \
		-var bastion_key_name=$(key_name)

.PHONY: destroy
destroy:
	@ terraform destroy \
	    -var uuid=$(uuid) \
	    -var owner=$(owner) \
	    -var git_branch=$(branch) \
	    -var git_commit=$(commit) \
		-var bastion_key_name=$(key_name)
