package v2

import (
	v2 "envoyproxy.io/envoy-cue/spec/config/ratelimit/v2"
)

// [#next-free-field: 8]
#RateLimit: {
	"@type": "type.googleapis.com/envoy.config.filter.http.rate_limit.v2.RateLimit"
	// The rate limit domain to use when calling the rate limit service.
	domain?: string
	// Specifies the rate limit configurations to be applied with the same
	// stage number. If not set, the default stage number is 0.
	//
	// .. note::
	//
	//  The filter supports a range of 0 - 10 inclusively for stage numbers.
	stage?: uint32
	// The type of requests the filter should apply to. The supported
	// types are *internal*, *external* or *both*. A request is considered internal if
	// :ref:`x-envoy-internal<config_http_conn_man_headers_x-envoy-internal>` is set to true. If
	// :ref:`x-envoy-internal<config_http_conn_man_headers_x-envoy-internal>` is not set or false, a
	// request is considered external. The filter defaults to *both*, and it will apply to all request
	// types.
	request_type?: string
	// The timeout in milliseconds for the rate limit service RPC. If not
	// set, this defaults to 20ms.
	timeout?: string
	// The filter's behaviour in case the rate limiting service does
	// not respond back. When it is set to true, Envoy will not allow traffic in case of
	// communication failure between rate limiting service and the proxy.
	// Defaults to false.
	failure_mode_deny?: bool
	// Specifies whether a `RESOURCE_EXHAUSTED` gRPC code must be returned instead
	// of the default `UNAVAILABLE` gRPC code for a rate limited gRPC call. The
	// HTTP code will be 200 for a gRPC response.
	rate_limited_as_resource_exhausted?: bool
	// Configuration for an external rate limit service provider. If not
	// specified, any calls to the rate limit service will immediately return
	// success.
	rate_limit_service?: v2.#RateLimitServiceConfig
}
