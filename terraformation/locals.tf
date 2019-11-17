locals {
tags = { 
    "Env" = "dev"
}

log_bucket_name = "jamie-alb-${var.region}"

 http_tcp_listeners_count = 1

  http_tcp_listeners = [
    {
      "port"     = 80
      "protocol" = "HTTP"
    },
    
  ]

  target_groups_count = 2

  target_groups = [
    {
      "name"             = "primary"
      "backend_protocol" = "HTTP"
      "backend_port"     = 8080
      "slow_start"       = 0
    },
    {
      "name"             = "secondary"
      "backend_protocol" = "HTTP"
      "backend_port"     = 8080
      "slow_start"       = 100
    }
  ]

}
