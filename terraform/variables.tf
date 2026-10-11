variable "location" {
  description = "Región de Azure donde se crea todo"
  type        = string
  default     = "northeurope"
}

variable "project" {
  description = "Nombre del proyecto, usado en los nombres de los recursos"
  type        = string
  default     = "urlshortener"
}

variable "environment" {
  description = "Entorno: dev, pre o pro"
  type        = string
  default     = "dev"
}

variable "image_tag" {
  description = "Versión de la imagen de la app a desplegar"
  type        = string
  default     = "v2"
}
