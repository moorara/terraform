variable "vpc_cidrs" {
  type = "map"
  default = {
    ap-northeast-1  =  "10.11.0.0/16",
    ap-northeast-2  =  "10.12.0.0/16",
    ap-south-1      =  "10.13.0.0/16",
    ap-southeast-1  =  "10.14.0.0/16",
    ap-southeast-2  =  "10.15.0.0/16",
    ca-central-1    =  "10.16.0.0/16",
    eu-central-1    =  "10.17.0.0/16",
    eu-north-1      =  "10.18.0.0/16",
    eu-west-1       =  "10.19.0.0/16",
    eu-west-2       =  "10.20.0.0/16",
    eu-west-3       =  "10.21.0.0/16",
    sa-east-1       =  "10.22.0.0/16",
    us-east-1       =  "10.23.0.0/16",
    us-east-2       =  "10.24.0.0/16",
    us-west-1       =  "10.25.0.0/16",
    us-west-2       =  "10.26.0.0/16"
  }
}
