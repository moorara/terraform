#!/bin/sh -l

set -euo pipefail


echo "access_key  = \"$AWS_ACCESS_KEY\""   >  ./test/aws/terraform.tfvars
echo "secret_key  = \"$AWS_SECRET_KEY\""   >> ./test/aws/terraform.tfvars
echo "region      = \"$AWS_REGION\""       >> ./test/aws/terraform.tfvars
echo "environment = \"$AWS_ENVIRONMENT\""  >> ./test/aws/terraform.tfvars

sh -c "$*"