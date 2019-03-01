region := $(shell cat terraform.tfvars | grep region | grep -oe '".*"')
environment := $(shell cat terraform.tfvars | grep environment | grep -oe '".*"')

key_name := $(environment)-bastion
host := $(shell git remote get-url origin | cut -d@ -f2 | cut -d: -f1)
repo := $(shell git remote get-url origin | cut -d: -f2 | rev | cut -c5- | rev)


clean:
	@ rm -f *.pub *.pem $(key_name) && \
	  rm -rf .terraform terraform.tfstate terraform.tfstate.backup

keys:
	@ ssh-keygen -f $(key_name) -t rsa -N '' 1> /dev/null && \
	  chmod 400 $(key_name) && \
	  mv $(key_name) $(key_name).pem

init:
	@ terraform init

validate:
	@ terraform validate \
	    -var owner=$(shell whoami) \
	    -var git_commit=$(shell git rev-parse --short HEAD) \
			-var git_branch=$(shell git rev-parse --abbrev-ref HEAD) \
			-var git_repo="https://$(host)/$(repo)"

plan:
	@ terraform plan \
	    -var owner=$(shell whoami) \
	    -var git_commit=$(shell git rev-parse --short HEAD) \
			-var git_branch=$(shell git rev-parse --abbrev-ref HEAD) \
			-var git_repo="https://$(host)/$(repo)"

apply:
	@ terraform apply \
	    -var owner=$(shell whoami) \
	    -var git_commit=$(shell git rev-parse --short HEAD) \
			-var git_branch=$(shell git rev-parse --abbrev-ref HEAD) \
			-var git_repo="https://$(host)/$(repo)"

destroy:
	@ terraform destroy \
	    -var owner=$(shell whoami) \
	    -var git_commit=$(shell git rev-parse --short HEAD) \
			-var git_branch=$(shell git rev-parse --abbrev-ref HEAD) \
			-var git_repo="https://$(host)/$(repo)"


.PHONY: clean
.PHONY: keys
.PHONY: init validate plan apply destroy
