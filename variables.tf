variable "vpc_cidr_block" {
  type        = string
  description = "vpc cidr block"
}

variable "cidr_blocks" {
  description = "cidr blocks and name tags for vpc and subnets"
  type = list(object({
    cidr_block = string
    name       = string
  }))
}

variable "environment" {
  type        = string
  description = "deployment environment"
}

variable "subnet_cidr_block" {
  description = "subnet cidr block"
  default     = "10.0.10.0/24"
  type        = string
}
