# .bash_functions file
# Vinicius Figueiredo <viniciusfs@gmail.com>

aws_login() {
  local env=$1
  aws sso login --profile $env
  export AWS_PROFILE=$env
}
