output "published_routes" {
  description = "Routes published to CCN"
  value = {
    for k, route in tencentcloud_ccn_routes.routes : k => {
      route_id = route.route_id
      switch   = route.switch
    }
  }
}
