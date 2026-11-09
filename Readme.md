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

## Provider Docker
Nom : kreuzwerker/docker
Lien: https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs


## 1er projet : Hello Nginx
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

terraform destroy # puis yes
```

## 2e projet : Echo
Provisionner l'image hashicorps/http-echo et un conteneur echo
avec la commande `-text=Bonjour depuis Terraform`.

Le port par défaut de l'image est 5678. La commande se concatène à l'entrypoint qui lance toujours le serveur echo.

Changer la commande par `-text=Bonjour depuis chez moi`.
