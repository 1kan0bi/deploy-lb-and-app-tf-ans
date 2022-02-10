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
   null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
  }
}


provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_tag" "ansible-01" {
  name = "bulutovstas_at_mail_ru"
}

resource "digitalocean_droplet" "application" {
  count    = length(var.app)
  image    = "ubuntu-18-04-x64"
  name     = "app-ubuntu-${format("%02d", count.index + 1)}"
  region   = "ams3"
  size     = "s-1vcpu-1gb"
  tags     = [digitalocean_tag.ansible-01.name]
  ssh_keys = ["${digitalocean_ssh_key.my_ssh_key.fingerprint}", "${data.digitalocean_ssh_key.rebrain_key.fingerprint}"]
}

resource "digitalocean_droplet" "balancer" {
  count    = length(var.lb)
  image    = "ubuntu-18-04-x64"
  name     = "lb-ubuntu-${format("%02d", count.index + 1)}"
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

resource "aws_route53_record" "app-domain" {
  count   = length(var.app)
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.app[count.index].login}-${var.app[count.index].prefix}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${element(digitalocean_droplet.application.*.ipv4_address, count.index)}"]
}

resource "aws_route53_record" "lb-domain" {
  count   = length(var.lb)
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.lb[count.index].login}-${var.lb[count.index].prefix}.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${element(digitalocean_droplet.balancer.*.ipv4_address, count.index)}"]
}

data "aws_route53_zone" "selected" {
  name = "devops.rebrain.srwx.net"
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
  #count = length(var.app)
  vars = {
    app = "${join("\n        ", formatlist("%s:", "${aws_route53_record.app-domain.*.name}"))}"
    balancer = "${join("\n        ", formatlist("%s:", "${aws_route53_record.lb-domain.*.name}"))}"

}
}

resource "local_file" "inventory_file" {
  filename = "${path.module}/inventory"
  content  = data.template_file.inventory_template.rendered
}

resource "null_resource" "inventory_file" {
 provisioner "local-exec" {
    command = "ansible-playbook -i ${path.module}/inventory --private-key ${var.private_ssh_key} --user root ${path.module}/ansible_playbook.yml -b"
}

depends_on = [
  local_file.inventory_file,
]

}
