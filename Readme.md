# Terraform

## Installation

### Terraform CLI
https://developer.hashicorp.com/terraform/install

```sh
terraform --version
```

### Cache providers
Linux/Mac
```sh
mkdir ~/.terraform_cache
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform_cache"
```

Windows
```sh
mkdir ~/.terraform_cache
setx TF_PLUGIN_CACHE_DIR "$HOME/.terraform_cache"
```

### IDE
VS Code + Extension HashiCorp Terraform

## 1er projet
```sh
mkdir 01-hello-project
cd 01-hello-project
# edit main.tf
terraform init

terraform plan
terraform apply  # puis yes
terraform apply -auto-approve # !!

docker image ls
docker ps

terraform state list
terraform state show docker_container.hello
```
