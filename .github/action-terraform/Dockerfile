FROM hashicorp/terraform:light

LABEL "com.github.actions.name"="Terraform"
LABEL "com.github.actions.description"="Run terraform commands"
LABEL "com.github.actions.icon"="check"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="http://github.com/moorara/terraform"
LABEL "homepage"="http://github.com/moorara/terraform"
LABEL "maintainer"="Milad Irannejad"

# Install tools
RUN apk add --no-cache make

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
