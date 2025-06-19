resource "datadog_monitor" "http_service_check" {
  name = "App HTTP is DOWN (agent-based)"
  type = "service check"

  query = "\"http.can_connect\".over(\"*\").by(\"host\").last(2).count_by_status()"

  message = <<EOT
🚨 Приложение не отвечает
Datadog агент не может подключиться (http.can_connect).
EOT

  notify_no_data      = true
  no_data_timeframe   = 10
  include_tags        = true
  require_full_window = true

  tags = ["env:prod", "check:agent", "service:app"]
}
