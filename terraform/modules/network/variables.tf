variable "name_suffix" {
  description = "Sufijo para los nombres, por ejemplo urlshortener-dev"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group donde se crea la red"
  type        = string
}

variable "address_space" {
  description = "Rango de direcciones de la red virtual"
  type        = string
  default     = "10.10.0.0/16"
}

variable "apps_subnet_prefix" {
  description = "Rango de la subred de la aplicación"
  type        = string
  default     = "10.10.0.0/23"
}

variable "db_subnet_prefix" {
  description = "Rango de la subred de la base de datos"
  type        = string
  default     = "10.10.2.0/24"
}

variable "tags" {
  description = "Etiquetas para todos los recursos"
  type        = map(string)
  default     = {}
}