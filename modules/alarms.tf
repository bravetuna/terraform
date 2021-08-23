resource "aws_sns_topic" "alarm_cassandra" {
  name = "alarms-topic-cassandra"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF

#  provisioner "local-exec" {
#    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email} --region ${var.region}"
#  }
}

/*
resource "aws_cloudwatch_metric_alarm" "cassandra_CPU" {
  alarm_name                = "health-alarm-cassandra-${var.cassandra_cluster}-${count.index+ 1}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
}
*/

resource "aws_cloudwatch_metric_alarm" "health_cassandra" {
  alarm_name                = "health-alarm-cassandra-${var.cassandra_cluster}-${count.index+ 1}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 health status"
  alarm_actions             = [ "${aws_sns_topic.alarm_cassandra.arn}" ]
  count = var.cassandra_nodes
  dimensions = {
     InstanceId = aws_instance.cassandra_nodes.*.id[count.index]
  }
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = "${aws_sns_topic.alarm_cassandra.arn}"
  protocol  = "email"
  endpoint  = "syu@tropo.com"
}