variable "do_token" {
  type        = string
  description = "DigitalOcean token"
}

variable "ssh_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVki2X88HDd+iq3LZIdt4RN4xYfOhOJxYgV/7KtI/p5"
  description = "Public ssh-key"

}
variable "secret_key" {
  type        = string
  description = "My secret AWS key"

}
variable "access_key" {
  type        = string
  description = "My access AWS key"

}

