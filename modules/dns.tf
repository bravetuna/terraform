resource "aws_route53_record" "cassandra_nodes" {
  zone_id = var.zone_id
  name = "agovw1-cassandra-${var.cassandra_cluster}-${replace(var.availability_zones[count.index % length(var.availability_zones)], "-", "")}-${floor(count.index/length(var.availability_zones))+1}"
  type = "CNAME"
  ttl = "120"
  records = [
    aws_instance.cassandra_nodes[count.index].private_dns
    ]
  count = var.cassandra_nodes
}
