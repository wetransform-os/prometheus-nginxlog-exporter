Feature: Access log lines can be skipped

  Scenario: Matched lines are skipped (full match on URI)
    Given a running exporter listening with configuration file "test-configuration-skip.hcl"
    When the following HTTP request is logged to "access.log"
      """
      172.17.0.1 - - [23/Jun/2016:16:04:20 +0000] "GET /root HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      172.17.0.1 - foo [23/Jun/2016:16:04:20 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      """
    Then the exporter should report value 1 for metric nginx_http_response_count_total{method="GET",status="200"}

  Scenario: Matched lines are skipped (match on start with default configuration)
    Given a running exporter listening with configuration file "test-configuration-skip.hcl"
    When the following HTTP request is logged to "access.log"
      """
      172.17.0.1 - - [23/Jun/2016:16:04:20 +0000] "GET /base HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      172.17.0.1 - - [23/Jun/2016:16:04:20 +0000] "GET /base/buns HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      172.17.0.1 - foo [23/Jun/2016:16:04:20 +0000] "POST /base HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      172.17.0.1 - foo [23/Jun/2016:16:04:20 +0000] "POST /vase HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      """
    Then the exporter should report value 1 for metric nginx_http_response_count_total{method="POST",status="200"}

  Scenario: Matched lines are skipped (match on start on full reuqest information)
    Given a running exporter listening with configuration file "test-configuration-skip.hcl"
    When the following HTTP request is logged to "access.log"
      """
      172.17.0.1 - - [23/Jun/2016:16:04:20 +0000] "GET /match HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      172.17.0.1 - - [23/Jun/2016:16:04:20 +0000] "GET /match/catch HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      172.17.0.1 - foo [23/Jun/2016:16:04:20 +0000] "PATCH /match HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      """
    Then the exporter should report value 2 for metric nginx_http_response_count_total{method="GET",status="200"}

  Scenario: Matched lines are skipped (partial match on URI)
    Given a running exporter listening with configuration file "test-configuration-skip.hcl"
    When the following HTTP request is logged to "access.log"
      """
      172.17.0.1 - - [23/Jun/2016:16:04:20 +0000] "GET /sub/path HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      172.17.0.1 - - [23/Jun/2016:16:04:20 +0000] "GET /sub/path/sub HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      172.17.0.1 - foo [23/Jun/2016:16:04:20 +0000] "POST /path/sub HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
      """
    Then the exporter should report value 1 for metric nginx_http_response_count_total{method="GET",status="200"}