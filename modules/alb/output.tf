output "lb-dns" {
  value = aws_lb.main-alb.dns_name
}

output "lb-zone-id" {
  value = aws_lb.main-alb.zone_id
}

output "lb-arn" {
  value = aws_lb.main-alb.arn
}

output "target-group-arn" {
  value = aws_lb_target_group.alb-target-group.arn
}