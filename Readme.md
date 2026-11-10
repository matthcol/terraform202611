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
Provisionner l'image `hashicorp/http-echo` et un conteneur echo
avec la commande `-text=Bonjour depuis Terraform`.

Le port par défaut de l'image est 5678. La commande se concatène à l'entrypoint qui lance toujours le serveur echo.

Changer la commande par `-text=Bonjour depuis chez moi`.

Enlever le conteneur seulement.

## 3e projet : HCL
Définir un nombre de conteneur à 3 dans la resource docker_container echo

```sh
terraform init
terraform apply
terraform state list
   # docker_container.echo[0]
   # docker_container.echo[1]
   # docker_container.echo[2]
   # docker_image.echo

 curl localhost:8090
    # Bonjour depuis chez moi [0]
 curl localhost:8091
     # Bonjour depuis chez moi [1]
 curl localhost:8092 
     # Bonjour depuis chez moi [2]
```

Changer le count de 3 à 5
```sh
terraform plan    # add 2 conteneurs
terraform apply
curl localhost:8094 
     # Bonjour depuis chez moi [4]
```

Changer le count de 5 à 2 dans le `main.tf`
```sh
terraform plan 
```

Ajouter le message de welcome et le nombre de conteneurs
dans le fichier de variables `variables.tf`

```hcl
variable "nb_containers" {
    type = number
    default = 3
}

variable "message" {
  type = string
  default = "hello"
}
```

1 variable est définie avec une valeur par défaut dans un block `variable`.

1 variable peut être redéfinie (de la - prioritaire à la + prioritaire):

- variable d'environnement
```sh
$env:TF_VAR_message="Au-revoir"
export TF_VAR_message="Au-revoir"
```

- fichier `terraform.tfvars`
```
nb_containers = 7
message = "coucou"
```

- fichiers `*.auto.tfvars` par ordre alphabétique
```
nb_containers = 7
message = "coucou"
```

- CLI: -var
```
terraform apply -var="nb_containers=6"
```

## Variables, types, opérateurs et fonctions
### Types simples
- number : 12, 5.2
    * operateurs : +, -, *, /, %
    * fonctions : abs, ceil, floor, max, min, ...
- string : "bonjour Terraform"
    * concaténation : template "${var.var1}, ${var.var2}, ...."
    * fonctions : upper, lower, substr, length, ...
- bool : true, false
    * opérateurs de comparaisons : ==, !=, <, >, <=, >=
    * opérateurs de logique : &&, ||, !  (resp. AND, OR, NOT)
    * expression ternaire : cond ? val_vrai : val_faux

### Types complexes
- list(T) : list(string) : ["lundi", "mardi", "mercredi"]
- set(T) : set(number) : [12, 23, 46] ou toset([....])
- map(T) : map(number) : 
```
{
    api = 8080
    db = 3306
    front = 80
}
```
- object
- tuple


    * fonctions : length, sort, contains, concat, ...

## Dépendances

```sh
terraform graph
terraform graph > graph.dot
```

Visualisation avec graphviz (à installer: https://graphviz.org/download/)
```
dot -Tsvg graph.dot -o graph.svg
dot -Tpng graph.dot -o graph.png
```

Dépendances implicites à travers les variables resources.
