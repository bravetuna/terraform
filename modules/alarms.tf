resource "aws_sns_topic" "alarm_db" {
  name = "alarms-topic-${var.cluster_type}"
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

}

resource "aws_cloudwatch_metric_alarm" "health_db" {
  alarm_name                = "health-alarm-${var.cluster_type}-${var.db_cluster}-${count.index+ 1}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 health status"
  alarm_actions             = [ "${aws_sns_topic.alarm_db.arn}" ]
  count = var.db_nodes
  dimensions = {
     InstanceId = aws_instance.nodes.*.id[count.index]
  }
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = "${aws_sns_topic.alarm_db.arn}"
  protocol  = "email"
  endpoint  = "syu@tropo.com"
}
