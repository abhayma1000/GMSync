package v3

import (
	v3 "envoyproxy.io/envoy-cue/spec/config/accesslog/v3"
)

// [#next-free-field: 8]
#Router: {
	"@type": "type.googleapis.com/envoy.extensions.filters.http.router.v3.Router"
	// Whether the router generates dynamic cluster statistics. Defaults to
	// true. Can be disabled in high performance scenarios.
	dynamic_stats?: bool
	// Whether to start a child span for egress routed calls. This can be
	// useful in scenarios where other filters (auth, ratelimit, etc.) make
	// outbound calls and have child spans rooted at the same ingress
	// parent. Defaults to false.
	start_child_span?: bool
	// Configuration for HTTP upstream logs emitted by the router. Upstream logs
	// are configured in the same way as access logs, but each log entry represents
	// an upstream request. Presuming retries are configured, multiple upstream
	// requests may be made for each downstream (inbound) request.
	upstream_log?: [...v3.#AccessLog]
	// Do not add any additional ``x-envoy-`` headers to requests or responses. This
	// only affects the :ref:`router filter generated x-envoy- headers
	// <config_http_filters_router_headers_set>`, other Envoy filters and the HTTP
	// connection manager may continue to set ``x-envoy-`` headers.
	suppress_envoy_headers?: bool
	// Specifies a list of HTTP headers to strictly validate. Envoy will reject a
	// request and respond with HTTP status 400 if the request contains an invalid
	// value for any of the headers listed in this field. Strict header checking
	// is only supported for the following headers:
	//
	// Value must be a ','-delimited list (i.e. no spaces) of supported retry
	// policy values:
	//
	// * :ref:`config_http_filters_router_x-envoy-retry-grpc-on`
	// * :ref:`config_http_filters_router_x-envoy-retry-on`
	//
	// Value must be an integer:
	//
	// * :ref:`config_http_filters_router_x-envoy-max-retries`
	// * :ref:`config_http_filters_router_x-envoy-upstream-rq-timeout-ms`
	// * :ref:`config_http_filters_router_x-envoy-upstream-rq-per-try-timeout-ms`
	strict_check_headers?: [...string]
	// If not set, ingress Envoy will ignore
	// :ref:`config_http_filters_router_x-envoy-expected-rq-timeout-ms` header, populated by egress
	// Envoy, when deriving timeout for upstream cluster.
	respect_expected_rq_timeout?: bool
	// If set, Envoy will avoid incrementing HTTP failure code stats
	// on gRPC requests. This includes the individual status code value
	// (e.g. upstream_rq_504) and group stats (e.g. upstream_rq_5xx).
	// This field is useful if interested in relying only on the gRPC
	// stats filter to define success and failure metrics for gRPC requests
	// as not all failed gRPC requests charge HTTP status code metrics. See
	// :ref:`gRPC stats filter<config_http_filters_grpc_stats>` documentation
	// for more details.
	suppress_grpc_request_failure_code_stats?: bool
}
