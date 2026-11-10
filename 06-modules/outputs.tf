# output principal (root)

# debug attribut d'un conteneur
output "debug_container_network_data" {
    value = docker_container.mirror_module_outputs.network_data
}

# collecte d'information (catalogue)
# * définir un output qui retourne une map avec pour chaque module le nom et ip du conteneur créé
#   NB: commencer par les modules à l'unité avant de faire le module "multiple"

output "catalogue_containers" {
  value = {
    web_01 = {
        name = module.web_01.container_name
        ip = module.web_01.container_ip
    }
    web_logger = {
        name = module.web_logger.container_name
        ip = module.web_logger.container_ip
    }
    web_echo = {
        name = module.web_echo.container_name
        ip = module.web_echo.container_ip
    }
  }
}