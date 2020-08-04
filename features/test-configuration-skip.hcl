port = 4040
enable_experimental = true

namespace "nginx" {
  source {
    files = [".behave-sandbox/access.log"]
  }
  format = "$remote_addr - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent\" \"$http_x_forwarded_for\""

  // not sure why we need to explicitly define a list - using separate skip blocks does not work as expected (maybe only works with a key)
  skip = [{
    from = "request"
    split = 2
    match = "^/root.*$"
  }, {
    match = "^/base"
  }, {
    from = "request"
    match = "^PATCH /match"
  }, {
    from = "request"
    split = 2
    match = "/path/"
  }]
}
