# fichier principal module root
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.0" # config versions une fois au niveau principal (root)
    }
  }
}

provider "docker" {

}

# -----------------
# gestion volumes
# ----------------
resource "docker_volume" "shared_data" {
  name = "shared_data"
}


# ------------------
# gestion des images
# ------------------

# 2 images à provisionner (resource)
resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_image" "echo" {
  name = "hashicorp/http-echo"
}

# 1 image déjà présente (soit installée en mode manuel ou autre projet terraform)
data "docker_image" "apache_httpd" {
  name = "httpd:alpine"
}

# -----------------------------------------
#            modules
# -----------------------------------------


# instanciation du module web_container
module "web_01" {
  source     = "./modules/web_container" # localisation du module
  depends_on = [docker_volume.shared_data]

  # inputs (variable) du module
  image_id = docker_image.nginx.image_id
}

# 2e instanciation du module web_container (nginx)
# - suffixe et ports
module "web_logger" {
  source = "./modules/web_container" # localisation du module

  # inputs (variable) du module
  image_id              = docker_image.nginx.image_id
  container_name_suffix = "logger"
  external_port         = 81
}

# 3e instanciation du module web_container (echo)
# - suffixe et ports
module "web_echo" {
  source = "./modules/web_container"

  image_id              = docker_image.echo.image_id
  container_name_suffix = "echo"
  external_port         = 82
  internal_port         = 5678
}

# instance utilisant l'image non resource
module "web_httpd" {
  source = "./modules/web_container"

  # NB: pour une image data, on utilise l'attrinut 'id' directement 
  #     contrairement à 1 resource où on utilise 'image_id' car 'id' désigne l'id TF de la resource
  image_id              = data.docker_image.apache_httpd.id
  container_name_suffix = "httpd"
  external_port         = 83
}


# instaciation en boucle
module "web_echo_multiple" {
  source = "./modules/web_container"
  count  = var.nb_echo_multiple

  image_id              = docker_image.echo.image_id
  container_name_suffix = "echom-${count.index}"
  internal_port         = 5678
  external_port         = 90 + count.index
}

# utilisation des outputs des modules instanciés
resource "docker_container" "mirror_module_outputs" {
  image      = docker_image.echo.image_id
  name       = "mirror_module_outputs"
  depends_on = [docker_volume.shared_data]

  # exemple utilisation output d'un module : module.<nom_module>.<nom_output>
  command = ["-text=logger container name = ${module.web_logger.container_name} ; logger ip = ${module.web_logger.container_ip}"]
  ports {
    internal = 5678
    external = 9000
  }
}