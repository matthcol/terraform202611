# paramètres du module web_containers

# paramètre obligatoire (required), car pas de valeur par défaut
variable "image_id" {
    type = string
}

# paramètres facultatifs (valeurs par défaut)
variable "container_name_suffix" {
    type = string
    default = "01"
}

variable "internal_port" {
    type = number
    default = 80
}

variable "external_port" {
    type = number
    default = 80
}