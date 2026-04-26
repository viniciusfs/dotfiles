# .bash_functions file
# Vinicius Figueiredo <viniciusfs@gmail.com>

aws_login() {
  local env=$1
  aws sso login --profile $env
  export AWS_PROFILE=$env
}

cluster_login() {
  local cluster=$1
  kubectl config use-context $cluster
}
