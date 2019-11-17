locals {
tags = { 
    "Env" = "dev"
}

log_bucket_name = "jamie-alb-${var.region}"

 http_tcp_listeners_count = 3

  http_tcp_listeners = [
    {
      "port"     = 80
      "protocol" = "HTTP"
    },
    {
      "port"               = 8080
      "protocol"           = "HTTP"
      "target_group_index" = 0
    },
    {
      "port"               = 8081
      "protocol"           = "HTTP"
      "target_group_index" = 1
    },
  ]

  target_groups_count = 2

  target_groups = [
    {
      "name"             = "foo"
      "backend_protocol" = "HTTP"
      "backend_port"     = 8080
      "slow_start"       = 0
    },
    {
      "name"             = "bar"
      "backend_protocol" = "HTTP"
      "backend_port"     = 8080
      "slow_start"       = 100
    },
  ]

}
