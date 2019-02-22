region := $(shell cat terraform.tfvars | grep region | grep -oe '".*"')
environment := $(shell cat terraform.tfvars | grep environment | grep -oe '".*"')

key_name := bastion-$(environment)


clean:
	@ rm -f *.pub *.pem && \
	  rm -rf .terraform terraform.tfstate terraform.tfstate.backup

keys:
	@ ssh-keygen -f $(key_name) -t rsa -N '' 1> /dev/null && \
	  chmod 400 $(key_name) && \
	  mv $(key_name) $(key_name).pem

init:
	@ terraform init

validate:
	@ terraform validate

plan:
	@ terraform plan

apply:
	@ terraform apply

destroy:
	@ terraform destroy


.PHONY: clean
.PHONY: keys
.PHONY: init validate plan apply destroy
