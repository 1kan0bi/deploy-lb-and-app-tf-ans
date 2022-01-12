terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.16.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_tag" "ansible-01" {
  name = "bulutovstas_at_mail_ru"
}
resource "digitalocean_droplet" "ansible-01" {
  image    = "ubuntu-18-04-x64"
  name     = "ansible-task-01"
  region   = "ams3"
  size     = "s-1vcpu-1gb"
  tags     = [digitalocean_tag.ansible-01.name]
  ssh_keys = ["${digitalocean_ssh_key.my_ssh_key.fingerprint}", "${data.digitalocean_ssh_key.rebrain_key.fingerprint}"]
}

provider "aws" {
  region     = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "bulutovstas.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [local.ip_addr]
}

data "aws_route53_zone" "selected" {
  name = "devops.rebrain.srwx.net"
}

locals {
  ip_addr = digitalocean_droplet.ansible-01.ipv4_address
}

data "digitalocean_ssh_key" "rebrain_key" {
  name = "REBRAIN.SSH.PUB.KEY"
}

resource "digitalocean_ssh_key" "my_ssh_key" {
  name       = "my ssh key"
  public_key = var.ssh_key
}

data "template_file" "inventory_template" {

  template = file("${path.module}/inventory.tmpl")
  vars = {
    domain = aws_route53_record.domain.name
  }

}

resource "local_file" "inventory_file" {
  filename = "${path.module}/inventory"
  content  = data.template_file.inventory_template.rendered
}
