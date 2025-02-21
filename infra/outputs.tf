
output "alb-public-address" {
  value = aws_lb.alb.dns_name
}

output "public-url" {
  value = aws_route53_record.www.fqdn
}
