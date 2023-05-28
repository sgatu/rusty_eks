locals {
  instance_type = "t4g.small"
  spot_config = coalesce(var.spot_config, {
    spot_price             = "0.0158"
    wait_for_fulfillment   = "true"
    spot_type              = "one-time"
    block_duration_minutes = "0"
  })
}
