# fichier principal module root
terraform {
  required_providers {
    docker = {
        source = "kreuzwerker/docker"
        version = "~> 4.0"   # config versions une fois au niveau principal (root)
    }
  }
}

provider "docker" {
  
}

resource "docker_image" "nginx" {
    name = "nginx:alpine"
}

# instanciation du module web_container
module "web_01" {
    source = "./modules/web_container"
    image_id = docker_image.nginx.image_id
}

# 2e instanciation du module web_container (nginx)
# - suffixe et ports

# 3e instanciation du module web_container (echo)
# - suffixe et ports