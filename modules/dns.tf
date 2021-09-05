resource "aws_route53_record" "nodes" {
  zone_id = var.zone_id
  name = "il5-${replace(var.availability_zones[count.index % length(var.availability_zones)], "-", "")}-${var.function_type}-${var.cluster_type}-${var.db_cluster}-${floor(count.index/length(var.availability_zones))+1}"
  type = "CNAME"
  ttl = "120"
  records = [
    aws_instance.nodes[count.index].private_dns
    ]
  count = var.db_nodes
}
