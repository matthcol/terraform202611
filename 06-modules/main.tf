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

resource "docker_image" "echo" {
    name = "hashicorp/http-echo"
}

# instanciation du module web_container
module "web_01" {
    source = "./modules/web_container"   # localisation du module

    # inputs (variable) du module
    image_id = docker_image.nginx.image_id
}

# 2e instanciation du module web_container (nginx)
# - suffixe et ports
module "web_logger" {
    source = "./modules/web_container"   # localisation du module

    # inputs (variable) du module
    image_id = docker_image.nginx.image_id
    container_name_suffix = "logger"
    external_port = 81
}

# 3e instanciation du module web_container (echo)
# - suffixe et ports
module "web_echo" {
    source = "./modules/web_container"

    image_id = docker_image.echo.image_id
    container_name_suffix = "echo"
    external_port = 82
    internal_port = 5678
}

# instaciation en boucle
module "web_echo_multiple" {
    source = "./modules/web_container"
    count = var.nb_echo_multiple

    image_id = docker_image.echo.image_id
    container_name_suffix = "echom-${count.index}"
    internal_port = 5678
    external_port = 83 + count.index
}

# utilisation des outputs des modules instanciés
resource "docker_container" "mirror_module_outputs" {
    image = docker_image.echo.image_id
    name = "mirror_module_outputs"

    # exemple utilisation output d'un module : module.<nom_module>.<nom_output>
    command = ["-text=logger container name = ${module.web_logger.container_name} ; logger ip = ${module.web_logger.container_ip}"]
    ports {
        internal =  5678
        external = 9000
    }
}