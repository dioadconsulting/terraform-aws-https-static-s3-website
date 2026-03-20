locals {
  dns_records = setunion([var.domain_name], var.domain_aliases)

  _default_error_responses = [
    { error_code = 400, response_code = 400, response_page_path = "/error/400.html", error_caching_min_ttl = 1800 },
    { error_code = 403, response_code = 403, response_page_path = "/error/403.html", error_caching_min_ttl = 1800 },
    { error_code = 404, response_code = 404, response_page_path = "/error/404.html", error_caching_min_ttl = 1800 },
    { error_code = 405, response_code = 405, response_page_path = "/error/405.html", error_caching_min_ttl = 1800 },
    { error_code = 414, response_code = 414, response_page_path = "/error/414.html", error_caching_min_ttl = 1800 },
    { error_code = 416, response_code = 416, response_page_path = "/error/416.html", error_caching_min_ttl = 1800 },
    { error_code = 500, response_code = 500, response_page_path = "/error/500.html", error_caching_min_ttl = 1800 },
    { error_code = 501, response_code = 501, response_page_path = "/error/501.html", error_caching_min_ttl = 1800 },
    { error_code = 502, response_code = 502, response_page_path = "/error/502.html", error_caching_min_ttl = 1800 },
    { error_code = 503, response_code = 503, response_page_path = "/error/503.html", error_caching_min_ttl = 1800 },
    { error_code = 504, response_code = 504, response_page_path = "/error/504.html", error_caching_min_ttl = 1800 },
  ]

  # In spa_mode, 403 and 404 are rewritten to 200/index.html so the SPA router handles them.
  effective_error_responses = [
    for r in local._default_error_responses :
    var.spa_mode && contains([403, 404], r.error_code)
    ? merge(r, { response_code = 200, response_page_path = "/index.html", error_caching_min_ttl = 0 })
    : r
  ]
}
