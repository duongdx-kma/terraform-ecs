variable "elb-dns-name" {}
variable "elb-zone-id" {}

variable "hosted_zone_id" {}

# because already have hosted_zone: duongdx.com
data "aws_route53_zone" "selected" {
  zone_id  = var.hosted_zone_id
}

resource "aws_route53_record" "duongdx" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_route53_zone.selected.name
  type    = "A"

  alias {
    name                   = var.elb-dns-name
    zone_id                = var.elb-zone-id
    evaluate_target_health = true
  }
}