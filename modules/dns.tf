resource "aws_route53_record" "nodes" {
  zone_id = var.zone_id
  name = "${var.function_type}-${var.cluster_type}-${var.db_cluster}-${count.index+1}"
  type = "CNAME"
  ttl = "120"
  records = [
    aws_instance.nodes[count.index].private_dns
    ]
  count = var.db_nodes
}
