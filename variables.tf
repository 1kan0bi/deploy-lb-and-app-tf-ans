variable "do_token" {
  type        = string
  description = "DigitalOcean token"
}

variable "ssh_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9EFrctUw5Oq1oaEvSl5halIbR7K9ISxOUQ6uVA67/s2yEDO5wUetQTr8gq0XL3zrW3m+09AMA52NmQV4O1GuyuVkiSVowFb1KfJOAvLjvxtOVJBfPVYr4miTuYtNyu5J2NualfQgp6kr9T24rlPL7N7SmlE5tFCCEEEiVxGG1jorYUCMHiNaiGFwuYDpTnQg3A9ksB/eeRiDTbcfTF1auJUzTKozTleBYyWjU5nE0zYo696xBn8P1RBX18c3LxuJGCBpEUehx5UQW76ySpc0ZfvDaPiUkKXCsdZencplC4e9G15BS9pPy7b6q6kvmO9PSGYa2uWLnCB90ipOE6NZTPdWRyKjgy9O1vY+5zkQsCvt+APU51x/Z8bYCVkbto9Cd3lU/Cs2AIWETX3HI2/uEixyBRLzTsPUoz7z6PXWamFPjNH82jKS8/DpaUorHB9SnoMPsb9G5ntWCAdv7igCrHtyA9vvsHlhg0t10Y5/37ZW3/bMjlnOjH6DHrfDzxS0= kanobi@LAPTOP-8LVA9EO9"
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

variable "private_ssh_key" {
  type        = string
  description = "Private SSH key for execute commands"
}

variable "devs" {
  type    = list(map(string))
  default = [{ login = "bulutovstas", prefix = "balancer" }, { login = "bulutovstas", prefix = "app" }]
}

