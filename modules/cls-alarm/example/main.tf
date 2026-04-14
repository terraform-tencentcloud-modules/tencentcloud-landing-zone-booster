module "cls_alarm" {
  source = "../"

  cls_alarm_policy_name = "告警策略测试"
  alarm_notice_ids      = ["notice-4b4762bb-86ec-40de-b554-5fc16d01abd1"]
  alarm_period          = 15
  multi_conditions = [{
    alarm_level = 1
    condition   = "[$1.__QUERYCOUNT__]> 10"
  }]
  start_time_offset = -20
  message_template  = "{{.Lables_Test}}"
  trigger_count     = 2
  logset_id         = "dda7e11e-974c-4c83-adc5-caf2088fad93"
  topic_id          = "4a5fc29b-d048-43f9-b9af-d4e3850c0b5f"
  query             = "level: error | select count(*) as errCount limit 100"
  monitor_time = {
    time = 25
    type = "Period"
  }
}
