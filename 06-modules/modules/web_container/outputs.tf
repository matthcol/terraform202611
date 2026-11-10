# outputs module web_container

output "container_name" {
    value = docker_container.web.name
}

output "container_ip" {
    value = docker_container.web.network_data[0].ip_address
}