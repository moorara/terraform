workflow "Main" {
  on = "push"
  resolves = [ "AWS Tests" ]
}

action "AWS Tests" {
  uses = "./.github/action-terraform"
  secrets = [ "AWS_ACCESS_KEY", "AWS_SECRET_KEY" ]
  env = {
    AWS_REGION = "us-east-1"
    AWS_ENVIRONMENT = "ci"
  }
  args = [ "cd test/aws && make keys init validate" ]
}
