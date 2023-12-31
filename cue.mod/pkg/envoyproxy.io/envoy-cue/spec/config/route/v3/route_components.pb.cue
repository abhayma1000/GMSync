package v3

import (
	v3 "envoyproxy.io/envoy-cue/spec/deps/cncf/xds/go/xds/type/matcher/v3"
	v31 "envoyproxy.io/envoy-cue/spec/config/core/v3"
	v32 "envoyproxy.io/envoy-cue/spec/type/matcher/v3"
	v33 "envoyproxy.io/envoy-cue/spec/type/v3"
	v34 "envoyproxy.io/envoy-cue/spec/type/tracing/v3"
	v35 "envoyproxy.io/envoy-cue/spec/type/metadata/v3"
)

#VirtualHost_TlsRequirementType: "NONE" | "EXTERNAL_ONLY" | "ALL"

VirtualHost_TlsRequirementType_NONE:          "NONE"
VirtualHost_TlsRequirementType_EXTERNAL_ONLY: "EXTERNAL_ONLY"
VirtualHost_TlsRequirementType_ALL:           "ALL"

#RouteAction_ClusterNotFoundResponseCode: "SERVICE_UNAVAILABLE" | "NOT_FOUND" | "INTERNAL_SERVER_ERROR"

RouteAction_ClusterNotFoundResponseCode_SERVICE_UNAVAILABLE:   "SERVICE_UNAVAILABLE"
RouteAction_ClusterNotFoundResponseCode_NOT_FOUND:             "NOT_FOUND"
RouteAction_ClusterNotFoundResponseCode_INTERNAL_SERVER_ERROR: "INTERNAL_SERVER_ERROR"

// Configures :ref:`internal redirect <arch_overview_internal_redirects>` behavior.
// [#next-major-version: remove this definition - it's defined in the InternalRedirectPolicy message.]
//
// Deprecated: Do not use.
#RouteAction_InternalRedirectAction: "PASS_THROUGH_INTERNAL_REDIRECT" | "HANDLE_INTERNAL_REDIRECT"

RouteAction_InternalRedirectAction_PASS_THROUGH_INTERNAL_REDIRECT: "PASS_THROUGH_INTERNAL_REDIRECT"
RouteAction_InternalRedirectAction_HANDLE_INTERNAL_REDIRECT:       "HANDLE_INTERNAL_REDIRECT"

#RetryPolicy_ResetHeaderFormat: "SECONDS" | "UNIX_TIMESTAMP"

RetryPolicy_ResetHeaderFormat_SECONDS:        "SECONDS"
RetryPolicy_ResetHeaderFormat_UNIX_TIMESTAMP: "UNIX_TIMESTAMP"

#RedirectAction_RedirectResponseCode: "MOVED_PERMANENTLY" | "FOUND" | "SEE_OTHER" | "TEMPORARY_REDIRECT" | "PERMANENT_REDIRECT"

RedirectAction_RedirectResponseCode_MOVED_PERMANENTLY:  "MOVED_PERMANENTLY"
RedirectAction_RedirectResponseCode_FOUND:              "FOUND"
RedirectAction_RedirectResponseCode_SEE_OTHER:          "SEE_OTHER"
RedirectAction_RedirectResponseCode_TEMPORARY_REDIRECT: "TEMPORARY_REDIRECT"
RedirectAction_RedirectResponseCode_PERMANENT_REDIRECT: "PERMANENT_REDIRECT"

#RateLimit_Action_MetaData_Source: "DYNAMIC" | "ROUTE_ENTRY"

RateLimit_Action_MetaData_Source_DYNAMIC:     "DYNAMIC"
RateLimit_Action_MetaData_Source_ROUTE_ENTRY: "ROUTE_ENTRY"

// The top level element in the routing configuration is a virtual host. Each virtual host has
// a logical name as well as a set of domains that get routed to it based on the incoming request's
// host header. This allows a single listener to service multiple top level domain path trees. Once
// a virtual host is selected based on the domain, the routes are processed in order to see which
// upstream cluster to route to or whether to perform a redirect.
// [#next-free-field: 23]
#VirtualHost: {
	"@type": "type.googleapis.com/envoy.config.route.v3.VirtualHost"
	// The logical name of the virtual host. This is used when emitting certain
	// statistics but is not relevant for routing.
	name?: string
	// A list of domains (host/authority header) that will be matched to this
	// virtual host. Wildcard hosts are supported in the suffix or prefix form.
	//
	// Domain search order:
	//  1. Exact domain names: ``www.foo.com``.
	//  2. Suffix domain wildcards: ``*.foo.com`` or ``*-bar.foo.com``.
	//  3. Prefix domain wildcards: ``foo.*`` or ``foo-*``.
	//  4. Special wildcard ``*`` matching any domain.
	//
	// .. note::
	//
	//   The wildcard will not match the empty string.
	//   e.g. ``*-bar.foo.com`` will match ``baz-bar.foo.com`` but not ``-bar.foo.com``.
	//   The longest wildcards match first.
	//   Only a single virtual host in the entire route configuration can match on ``*``. A domain
	//   must be unique across all virtual hosts or the config will fail to load.
	//
	// Domains cannot contain control characters. This is validated by the well_known_regex HTTP_HEADER_VALUE.
	domains?: [...string]
	// The list of routes that will be matched, in order, for incoming requests.
	// The first route that matches will be used.
	// Only one of this and ``matcher`` can be specified.
	routes?: [...#Route]
	// [#next-major-version: This should be included in a oneof with routes wrapped in a message.]
	// The match tree to use when resolving route actions for incoming requests. Only one of this and ``routes``
	// can be specified.
	matcher?: v3.#Matcher
	// Specifies the type of TLS enforcement the virtual host expects. If this option is not
	// specified, there is no TLS requirement for the virtual host.
	require_tls?: #VirtualHost_TlsRequirementType
	// A list of virtual clusters defined for this virtual host. Virtual clusters
	// are used for additional statistics gathering.
	virtual_clusters?: [...#VirtualCluster]
	// Specifies a set of rate limit configurations that will be applied to the
	// virtual host.
	rate_limits?: [...#RateLimit]
	// Specifies a list of HTTP headers that should be added to each request
	// handled by this virtual host. Headers specified at this level are applied
	// after headers from enclosed :ref:`envoy_v3_api_msg_config.route.v3.Route` and before headers from the
	// enclosing :ref:`envoy_v3_api_msg_config.route.v3.RouteConfiguration`. For more information, including
	// details on header value syntax, see the documentation on :ref:`custom request headers
	// <config_http_conn_man_headers_custom_request_headers>`.
	request_headers_to_add?: [...v31.#HeaderValueOption]
	// Specifies a list of HTTP headers that should be removed from each request
	// handled by this virtual host.
	request_headers_to_remove?: [...string]
	// Specifies a list of HTTP headers that should be added to each response
	// handled by this virtual host. Headers specified at this level are applied
	// after headers from enclosed :ref:`envoy_v3_api_msg_config.route.v3.Route` and before headers from the
	// enclosing :ref:`envoy_v3_api_msg_config.route.v3.RouteConfiguration`. For more information, including
	// details on header value syntax, see the documentation on :ref:`custom request headers
	// <config_http_conn_man_headers_custom_request_headers>`.
	response_headers_to_add?: [...v31.#HeaderValueOption]
	// Specifies a list of HTTP headers that should be removed from each response
	// handled by this virtual host.
	response_headers_to_remove?: [...string]
	// Indicates that the virtual host has a CORS policy. This field is ignored if related cors policy is
	// found in the
	// :ref:`VirtualHost.typed_per_filter_config<envoy_v3_api_field_config.route.v3.VirtualHost.typed_per_filter_config>`.
	//
	// .. attention::
	//
	//   This option has been deprecated. Please use
	//   :ref:`VirtualHost.typed_per_filter_config<envoy_v3_api_field_config.route.v3.VirtualHost.typed_per_filter_config>`
	//   to configure the CORS HTTP filter.
	//
	// Deprecated: Do not use.
	cors?: #CorsPolicy
	// The per_filter_config field can be used to provide virtual host-specific configurations for filters.
	// The key should match the :ref:`filter config name
	// <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpFilter.name>`.
	// The canonical filter name (e.g., ``envoy.filters.http.buffer`` for the HTTP buffer filter) can also
	// be used for the backwards compatibility. If there is no entry referred by the filter config name, the
	// entry referred by the canonical filter name will be provided to the filters as fallback.
	//
	// Use of this field is filter specific;
	// see the :ref:`HTTP filter documentation <config_http_filters>` for if and how it is utilized.
	// [#comment: An entry's value may be wrapped in a
	// :ref:`FilterConfig<envoy_v3_api_msg_config.route.v3.FilterConfig>`
	// message to specify additional options.]
	typed_per_filter_config?: [string]: _
	// Decides whether the :ref:`x-envoy-attempt-count
	// <config_http_filters_router_x-envoy-attempt-count>` header should be included
	// in the upstream request. Setting this option will cause it to override any existing header
	// value, so in the case of two Envoys on the request path with this option enabled, the upstream
	// will see the attempt count as perceived by the second Envoy. Defaults to false.
	// This header is unaffected by the
	// :ref:`suppress_envoy_headers
	// <envoy_v3_api_field_extensions.filters.http.router.v3.Router.suppress_envoy_headers>` flag.
	//
	// [#next-major-version: rename to include_attempt_count_in_request.]
	include_request_attempt_count?: bool
	// Decides whether the :ref:`x-envoy-attempt-count
	// <config_http_filters_router_x-envoy-attempt-count>` header should be included
	// in the downstream response. Setting this option will cause the router to override any existing header
	// value, so in the case of two Envoys on the request path with this option enabled, the downstream
	// will see the attempt count as perceived by the Envoy closest upstream from itself. Defaults to false.
	// This header is unaffected by the
	// :ref:`suppress_envoy_headers
	// <envoy_v3_api_field_extensions.filters.http.router.v3.Router.suppress_envoy_headers>` flag.
	include_attempt_count_in_response?: bool
	// Indicates the retry policy for all routes in this virtual host. Note that setting a
	// route level entry will take precedence over this config and it'll be treated
	// independently (e.g.: values are not inherited).
	retry_policy?: #RetryPolicy
	// [#not-implemented-hide:]
	// Specifies the configuration for retry policy extension. Note that setting a route level entry
	// will take precedence over this config and it'll be treated independently (e.g.: values are not
	// inherited). :ref:`Retry policy <envoy_v3_api_field_config.route.v3.VirtualHost.retry_policy>` should not be
	// set if this field is used.
	retry_policy_typed_config?: _
	// Indicates the hedge policy for all routes in this virtual host. Note that setting a
	// route level entry will take precedence over this config and it'll be treated
	// independently (e.g.: values are not inherited).
	hedge_policy?: #HedgePolicy
	// The maximum bytes which will be buffered for retries and shadowing.
	// If set and a route-specific limit is not set, the bytes actually buffered will be the minimum
	// value of this and the listener per_connection_buffer_limit_bytes.
	per_request_buffer_limit_bytes?: uint32
	// Specify a set of default request mirroring policies for every route under this virtual host.
	// It takes precedence over the route config mirror policy entirely.
	// That is, policies are not merged, the most specific non-empty one becomes the mirror policies.
	request_mirror_policies?: [...#RouteAction_RequestMirrorPolicy]
}

// A filter-defined action type.
#FilterAction: {
	"@type": "type.googleapis.com/envoy.config.route.v3.FilterAction"
	action?: _
}

// A route is both a specification of how to match a request as well as an indication of what to do
// next (e.g., redirect, forward, rewrite, etc.).
//
// .. attention::
//
//   Envoy supports routing on HTTP method via :ref:`header matching
//   <envoy_v3_api_msg_config.route.v3.HeaderMatcher>`.
// [#next-free-field: 20]
#Route: {
	"@type": "type.googleapis.com/envoy.config.route.v3.Route"
	// Name for the route.
	name?: string
	// Route matching parameters.
	match?: #RouteMatch
	// Route request to some upstream cluster.
	route?: #RouteAction
	// Return a redirect.
	redirect?: #RedirectAction
	// Return an arbitrary HTTP response directly, without proxying.
	direct_response?: #DirectResponseAction
	// [#not-implemented-hide:]
	// A filter-defined action (e.g., it could dynamically generate the RouteAction).
	// [#comment: TODO(samflattery): Remove cleanup in route_fuzz_test.cc when
	// implemented]
	filter_action?: #FilterAction
	// [#not-implemented-hide:]
	// An action used when the route will generate a response directly,
	// without forwarding to an upstream host. This will be used in non-proxy
	// xDS clients like the gRPC server. It could also be used in the future
	// in Envoy for a filter that directly generates responses for requests.
	non_forwarding_action?: #NonForwardingAction
	// The Metadata field can be used to provide additional information
	// about the route. It can be used for configuration, stats, and logging.
	// The metadata should go under the filter namespace that will need it.
	// For instance, if the metadata is intended for the Router filter,
	// the filter name should be specified as ``envoy.filters.http.router``.
	metadata?: v31.#Metadata
	// Decorator for the matched route.
	decorator?: #Decorator
	// The per_filter_config field can be used to provide route-specific configurations for filters.
	// The key should match the :ref:`filter config name
	// <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpFilter.name>`.
	// The canonical filter name (e.g., ``envoy.filters.http.buffer`` for the HTTP buffer filter) can also
	// be used for the backwards compatibility. If there is no entry referred by the filter config name, the
	// entry referred by the canonical filter name will be provided to the filters as fallback.
	//
	// Use of this field is filter specific;
	// see the :ref:`HTTP filter documentation <config_http_filters>` for if and how it is utilized.
	// [#comment: An entry's value may be wrapped in a
	// :ref:`FilterConfig<envoy_v3_api_msg_config.route.v3.FilterConfig>`
	// message to specify additional options.]
	typed_per_filter_config?: [string]: _
	// Specifies a set of headers that will be added to requests matching this
	// route. Headers specified at this level are applied before headers from the
	// enclosing :ref:`envoy_v3_api_msg_config.route.v3.VirtualHost` and
	// :ref:`envoy_v3_api_msg_config.route.v3.RouteConfiguration`. For more information, including details on
	// header value syntax, see the documentation on :ref:`custom request headers
	// <config_http_conn_man_headers_custom_request_headers>`.
	request_headers_to_add?: [...v31.#HeaderValueOption]
	// Specifies a list of HTTP headers that should be removed from each request
	// matching this route.
	request_headers_to_remove?: [...string]
	// Specifies a set of headers that will be added to responses to requests
	// matching this route. Headers specified at this level are applied before
	// headers from the enclosing :ref:`envoy_v3_api_msg_config.route.v3.VirtualHost` and
	// :ref:`envoy_v3_api_msg_config.route.v3.RouteConfiguration`. For more information, including
	// details on header value syntax, see the documentation on
	// :ref:`custom request headers <config_http_conn_man_headers_custom_request_headers>`.
	response_headers_to_add?: [...v31.#HeaderValueOption]
	// Specifies a list of HTTP headers that should be removed from each response
	// to requests matching this route.
	response_headers_to_remove?: [...string]
	// Presence of the object defines whether the connection manager's tracing configuration
	// is overridden by this route specific instance.
	tracing?: #Tracing
	// The maximum bytes which will be buffered for retries and shadowing.
	// If set, the bytes actually buffered will be the minimum value of this and the
	// listener per_connection_buffer_limit_bytes.
	per_request_buffer_limit_bytes?: uint32
	// The human readable prefix to use when emitting statistics for this endpoint.
	// The statistics are rooted at vhost.<virtual host name>.route.<stat_prefix>.
	// This should be set for highly critical
	// endpoints that one wishes to get “per-route” statistics on.
	// If not set, endpoint statistics are not generated.
	//
	// The emitted statistics are the same as those documented for :ref:`virtual clusters <config_http_filters_router_vcluster_stats>`.
	//
	// .. warning::
	//
	//    We do not recommend setting up a stat prefix for
	//    every application endpoint. This is both not easily maintainable and
	//    statistics use a non-trivial amount of memory(approximately 1KiB per route).
	stat_prefix?: string
}

// Compared to the :ref:`cluster <envoy_v3_api_field_config.route.v3.RouteAction.cluster>` field that specifies a
// single upstream cluster as the target of a request, the :ref:`weighted_clusters
// <envoy_v3_api_field_config.route.v3.RouteAction.weighted_clusters>` option allows for specification of
// multiple upstream clusters along with weights that indicate the percentage of
// traffic to be forwarded to each cluster. The router selects an upstream cluster based on the
// weights.
#WeightedCluster: {
	"@type": "type.googleapis.com/envoy.config.route.v3.WeightedCluster"
	// Specifies one or more upstream clusters associated with the route.
	clusters?: [...#WeightedCluster_ClusterWeight]
	// Specifies the total weight across all clusters. The sum of all cluster weights must equal this
	// value, if this is greater than 0.
	// This field is now deprecated, and the client will use the sum of all
	// cluster weights. It is up to the management server to supply the correct weights.
	//
	// Deprecated: Do not use.
	total_weight?: uint32
	// Specifies the runtime key prefix that should be used to construct the
	// runtime keys associated with each cluster. When the ``runtime_key_prefix`` is
	// specified, the router will look for weights associated with each upstream
	// cluster under the key ``runtime_key_prefix`` + ``.`` + ``cluster[i].name`` where
	// ``cluster[i]`` denotes an entry in the clusters array field. If the runtime
	// key for the cluster does not exist, the value specified in the
	// configuration file will be used as the default weight. See the :ref:`runtime documentation
	// <operations_runtime>` for how key names map to the underlying implementation.
	runtime_key_prefix?: string
	// Specifies the header name that is used to look up the random value passed in the request header.
	// This is used to ensure consistent cluster picking across multiple proxy levels for weighted traffic.
	// If header is not present or invalid, Envoy will fall back to use the internally generated random value.
	// This header is expected to be single-valued header as we only want to have one selected value throughout
	// the process for the consistency. And the value is a unsigned number between 0 and UINT64_MAX.
	header_name?: string
}

// Configuration for a cluster specifier plugin.
#ClusterSpecifierPlugin: {
	"@type": "type.googleapis.com/envoy.config.route.v3.ClusterSpecifierPlugin"
	// The name of the plugin and its opaque configuration.
	extension?: v31.#TypedExtensionConfig
	// If is_optional is not set or is set to false and the plugin defined by this message is not a
	// supported type, the containing resource is NACKed. If is_optional is set to true, the resource
	// would not be NACKed for this reason. In this case, routes referencing this plugin's name would
	// not be treated as an illegal configuration, but would result in a failure if the route is
	// selected.
	is_optional?: bool
}

// [#next-free-field: 16]
#RouteMatch: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteMatch"
	// If specified, the route is a prefix rule meaning that the prefix must
	// match the beginning of the ``:path`` header.
	prefix?: string
	// If specified, the route is an exact path rule meaning that the path must
	// exactly match the ``:path`` header once the query string is removed.
	path?: string
	// If specified, the route is a regular expression rule meaning that the
	// regex must match the ``:path`` header once the query string is removed. The entire path
	// (without the query string) must match the regex. The rule will not match if only a
	// subsequence of the ``:path`` header matches the regex.
	//
	// [#next-major-version: In the v3 API we should redo how path specification works such
	// that we utilize StringMatcher, and additionally have consistent options around whether we
	// strip query strings, do a case sensitive match, etc. In the interim it will be too disruptive
	// to deprecate the existing options. We should even consider whether we want to do away with
	// path_specifier entirely and just rely on a set of header matchers which can already match
	// on :path, etc. The issue with that is it is unclear how to generically deal with query string
	// stripping. This needs more thought.]
	safe_regex?: v32.#RegexMatcher
	// If this is used as the matcher, the matcher will only match CONNECT requests.
	// Note that this will not match HTTP/2 upgrade-style CONNECT requests
	// (WebSocket and the like) as they are normalized in Envoy as HTTP/1.1 style
	// upgrades.
	// This is the only way to match CONNECT requests for HTTP/1.1. For HTTP/2,
	// where Extended CONNECT requests may have a path, the path matchers will work if
	// there is a path present.
	// Note that CONNECT support is currently considered alpha in Envoy.
	// [#comment: TODO(htuch): Replace the above comment with an alpha tag.]
	connect_matcher?: #RouteMatch_ConnectMatcher
	// If specified, the route is a path-separated prefix rule meaning that the
	// ``:path`` header (without the query string) must either exactly match the
	// ``path_separated_prefix`` or have it as a prefix, followed by ``/``
	//
	// For example, ``/api/dev`` would match
	// ``/api/dev``, ``/api/dev/``, ``/api/dev/v1``, and ``/api/dev?param=true``
	// but would not match ``/api/developer``
	//
	// Expect the value to not contain ``?`` or ``#`` and not to end in ``/``
	path_separated_prefix?: string
	// [#extension-category: envoy.path.match]
	path_match_policy?: v31.#TypedExtensionConfig
	// Indicates that prefix/path matching should be case sensitive. The default
	// is true. Ignored for safe_regex matching.
	case_sensitive?: bool
	// Indicates that the route should additionally match on a runtime key. Every time the route
	// is considered for a match, it must also fall under the percentage of matches indicated by
	// this field. For some fraction N/D, a random number in the range [0,D) is selected. If the
	// number is <= the value of the numerator N, or if the key is not present, the default
	// value, the router continues to evaluate the remaining match criteria. A runtime_fraction
	// route configuration can be used to roll out route changes in a gradual manner without full
	// code/config deploys. Refer to the :ref:`traffic shifting
	// <config_http_conn_man_route_table_traffic_splitting_shift>` docs for additional documentation.
	//
	// .. note::
	//
	//    Parsing this field is implemented such that the runtime key's data may be represented
	//    as a FractionalPercent proto represented as JSON/YAML and may also be represented as an
	//    integer with the assumption that the value is an integral percentage out of 100. For
	//    instance, a runtime key lookup returning the value "42" would parse as a FractionalPercent
	//    whose numerator is 42 and denominator is HUNDRED. This preserves legacy semantics.
	runtime_fraction?: v31.#RuntimeFractionalPercent
	// Specifies a set of headers that the route should match on. The router will
	// check the request’s headers against all the specified headers in the route
	// config. A match will happen if all the headers in the route are present in
	// the request with the same values (or based on presence if the value field
	// is not in the config).
	headers?: [...#HeaderMatcher]
	// Specifies a set of URL query parameters on which the route should
	// match. The router will check the query string from the ``path`` header
	// against all the specified query parameters. If the number of specified
	// query parameters is nonzero, they all must match the ``path`` header's
	// query string for a match to occur.
	//
	// .. note::
	//
	//    If query parameters are used to pass request message fields when
	//    `grpc_json_transcoder <https://www.envoyproxy.io/envoy-cue/spec/docs/envoy/latest/configuration/http/http_filters/grpc_json_transcoder_filter>`_
	//    is used, the transcoded message fields maybe different. The query parameters are
	//    url encoded, but the message fields are not. For example, if a query
	//    parameter is "foo%20bar", the message field will be "foo bar".
	query_parameters?: [...#QueryParameterMatcher]
	// If specified, only gRPC requests will be matched. The router will check
	// that the content-type header has a application/grpc or one of the various
	// application/grpc+ values.
	grpc?: #RouteMatch_GrpcRouteMatchOptions
	// If specified, the client tls context will be matched against the defined
	// match options.
	//
	// [#next-major-version: unify with RBAC]
	tls_context?: #RouteMatch_TlsContextMatchOptions
	// Specifies a set of dynamic metadata matchers on which the route should match.
	// The router will check the dynamic metadata against all the specified dynamic metadata matchers.
	// If the number of specified dynamic metadata matchers is nonzero, they all must match the
	// dynamic metadata for a match to occur.
	dynamic_metadata?: [...v32.#MetadataMatcher]
}

// Cors policy configuration.
//
// .. attention::
//
//   This message has been deprecated. Please use
//   :ref:`CorsPolicy in filter extension <envoy_v3_api_msg_extensions.filters.http.cors.v3.CorsPolicy>`
//   as as alternative.
//
// [#next-free-field: 13]
#CorsPolicy: {
	"@type": "type.googleapis.com/envoy.config.route.v3.CorsPolicy"
	// Specifies string patterns that match allowed origins. An origin is allowed if any of the
	// string matchers match.
	allow_origin_string_match?: [...v32.#StringMatcher]
	// Specifies the content for the ``access-control-allow-methods`` header.
	allow_methods?: string
	// Specifies the content for the ``access-control-allow-headers`` header.
	allow_headers?: string
	// Specifies the content for the ``access-control-expose-headers`` header.
	expose_headers?: string
	// Specifies the content for the ``access-control-max-age`` header.
	max_age?: string
	// Specifies whether the resource allows credentials.
	allow_credentials?: bool
	// Specifies the % of requests for which the CORS filter is enabled.
	//
	// If neither ``enabled``, ``filter_enabled``, nor ``shadow_enabled`` are specified, the CORS
	// filter will be enabled for 100% of the requests.
	//
	// If :ref:`runtime_key <envoy_v3_api_field_config.core.v3.RuntimeFractionalPercent.runtime_key>` is
	// specified, Envoy will lookup the runtime key to get the percentage of requests to filter.
	filter_enabled?: v31.#RuntimeFractionalPercent
	// Specifies the % of requests for which the CORS policies will be evaluated and tracked, but not
	// enforced.
	//
	// This field is intended to be used when ``filter_enabled`` and ``enabled`` are off. One of those
	// fields have to explicitly disable the filter in order for this setting to take effect.
	//
	// If :ref:`runtime_key <envoy_v3_api_field_config.core.v3.RuntimeFractionalPercent.runtime_key>` is specified,
	// Envoy will lookup the runtime key to get the percentage of requests for which it will evaluate
	// and track the request's ``Origin`` to determine if it's valid but will not enforce any policies.
	shadow_enabled?: v31.#RuntimeFractionalPercent
	// Specify whether allow requests whose target server's IP address is more private than that from
	// which the request initiator was fetched.
	//
	// More details refer to https://developer.chrome.com/blog/private-network-access-preflight.
	allow_private_network_access?: bool
}

// [#next-free-field: 42]
#RouteAction: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteAction"
	// Indicates the upstream cluster to which the request should be routed
	// to.
	cluster?: string
	// Envoy will determine the cluster to route to by reading the value of the
	// HTTP header named by cluster_header from the request headers. If the
	// header is not found or the referenced cluster does not exist, Envoy will
	// return a 404 response.
	//
	// .. attention::
	//
	//   Internally, Envoy always uses the HTTP/2 ``:authority`` header to represent the HTTP/1
	//   ``Host`` header. Thus, if attempting to match on ``Host``, match on ``:authority`` instead.
	//
	// .. note::
	//
	//   If the header appears multiple times only the first value is used.
	cluster_header?: string
	// Multiple upstream clusters can be specified for a given route. The
	// request is routed to one of the upstream clusters based on weights
	// assigned to each cluster. See
	// :ref:`traffic splitting <config_http_conn_man_route_table_traffic_splitting_split>`
	// for additional documentation.
	weighted_clusters?: #WeightedCluster
	// Name of the cluster specifier plugin to use to determine the cluster for requests on this route.
	// The cluster specifier plugin name must be defined in the associated
	// :ref:`cluster specifier plugins <envoy_v3_api_field_config.route.v3.RouteConfiguration.cluster_specifier_plugins>`
	// in the :ref:`name <envoy_v3_api_field_config.core.v3.TypedExtensionConfig.name>` field.
	cluster_specifier_plugin?: string
	// Custom cluster specifier plugin configuration to use to determine the cluster for requests
	// on this route.
	inline_cluster_specifier_plugin?: #ClusterSpecifierPlugin
	// The HTTP status code to use when configured cluster is not found.
	// The default response code is 503 Service Unavailable.
	cluster_not_found_response_code?: #RouteAction_ClusterNotFoundResponseCode
	// Optional endpoint metadata match criteria used by the subset load balancer. Only endpoints
	// in the upstream cluster with metadata matching what's set in this field will be considered
	// for load balancing. If using :ref:`weighted_clusters
	// <envoy_v3_api_field_config.route.v3.RouteAction.weighted_clusters>`, metadata will be merged, with values
	// provided there taking precedence. The filter name should be specified as ``envoy.lb``.
	metadata_match?: v31.#Metadata
	// Indicates that during forwarding, the matched prefix (or path) should be
	// swapped with this value. This option allows application URLs to be rooted
	// at a different path from those exposed at the reverse proxy layer. The router filter will
	// place the original path before rewrite into the :ref:`x-envoy-original-path
	// <config_http_filters_router_x-envoy-original-path>` header.
	//
	// Only one of :ref:`regex_rewrite <envoy_v3_api_field_config.route.v3.RouteAction.regex_rewrite>`
	// :ref:`path_rewrite_policy <envoy_v3_api_field_config.route.v3.RouteAction.path_rewrite_policy>`,
	// or :ref:`prefix_rewrite <envoy_v3_api_field_config.route.v3.RouteAction.prefix_rewrite>` may be specified.
	//
	// .. attention::
	//
	//   Pay careful attention to the use of trailing slashes in the
	//   :ref:`route's match <envoy_v3_api_field_config.route.v3.Route.match>` prefix value.
	//   Stripping a prefix from a path requires multiple Routes to handle all cases. For example,
	//   rewriting ``/prefix`` to ``/`` and ``/prefix/etc`` to ``/etc`` cannot be done in a single
	//   :ref:`Route <envoy_v3_api_msg_config.route.v3.Route>`, as shown by the below config entries:
	//
	//   .. code-block:: yaml
	//
	//     - match:
	//         prefix: "/prefix/"
	//       route:
	//         prefix_rewrite: "/"
	//     - match:
	//         prefix: "/prefix"
	//       route:
	//         prefix_rewrite: "/"
	//
	//   Having above entries in the config, requests to ``/prefix`` will be stripped to ``/``, while
	//   requests to ``/prefix/etc`` will be stripped to ``/etc``.
	prefix_rewrite?: string
	// Indicates that during forwarding, portions of the path that match the
	// pattern should be rewritten, even allowing the substitution of capture
	// groups from the pattern into the new path as specified by the rewrite
	// substitution string. This is useful to allow application paths to be
	// rewritten in a way that is aware of segments with variable content like
	// identifiers. The router filter will place the original path as it was
	// before the rewrite into the :ref:`x-envoy-original-path
	// <config_http_filters_router_x-envoy-original-path>` header.
	//
	// Only one of :ref:`regex_rewrite <envoy_v3_api_field_config.route.v3.RouteAction.regex_rewrite>`,
	// :ref:`prefix_rewrite <envoy_v3_api_field_config.route.v3.RouteAction.prefix_rewrite>`, or
	// :ref:`path_rewrite_policy <envoy_v3_api_field_config.route.v3.RouteAction.path_rewrite_policy>`]
	// may be specified.
	//
	// Examples using Google's `RE2 <https://github.com/google/re2>`_ engine:
	//
	// * The path pattern ``^/service/([^/]+)(/.*)$`` paired with a substitution
	//   string of ``\2/instance/\1`` would transform ``/service/foo/v1/api``
	//   into ``/v1/api/instance/foo``.
	//
	// * The pattern ``one`` paired with a substitution string of ``two`` would
	//   transform ``/xxx/one/yyy/one/zzz`` into ``/xxx/two/yyy/two/zzz``.
	//
	// * The pattern ``^(.*?)one(.*)$`` paired with a substitution string of
	//   ``\1two\2`` would replace only the first occurrence of ``one``,
	//   transforming path ``/xxx/one/yyy/one/zzz`` into ``/xxx/two/yyy/one/zzz``.
	//
	// * The pattern ``(?i)/xxx/`` paired with a substitution string of ``/yyy/``
	//   would do a case-insensitive match and transform path ``/aaa/XxX/bbb`` to
	//   ``/aaa/yyy/bbb``.
	regex_rewrite?: v32.#RegexMatchAndSubstitute
	// [#extension-category: envoy.path.rewrite]
	path_rewrite_policy?: v31.#TypedExtensionConfig
	// Indicates that during forwarding, the host header will be swapped with
	// this value. Using this option will append the
	// :ref:`config_http_conn_man_headers_x-forwarded-host` header if
	// :ref:`append_x_forwarded_host <envoy_v3_api_field_config.route.v3.RouteAction.append_x_forwarded_host>`
	// is set.
	host_rewrite_literal?: string
	// Indicates that during forwarding, the host header will be swapped with
	// the hostname of the upstream host chosen by the cluster manager. This
	// option is applicable only when the destination cluster for a route is of
	// type ``strict_dns`` or ``logical_dns``. Setting this to true with other cluster types
	// has no effect. Using this option will append the
	// :ref:`config_http_conn_man_headers_x-forwarded-host` header if
	// :ref:`append_x_forwarded_host <envoy_v3_api_field_config.route.v3.RouteAction.append_x_forwarded_host>`
	// is set.
	auto_host_rewrite?: bool
	// Indicates that during forwarding, the host header will be swapped with the content of given
	// downstream or :ref:`custom <config_http_conn_man_headers_custom_request_headers>` header.
	// If header value is empty, host header is left intact. Using this option will append the
	// :ref:`config_http_conn_man_headers_x-forwarded-host` header if
	// :ref:`append_x_forwarded_host <envoy_v3_api_field_config.route.v3.RouteAction.append_x_forwarded_host>`
	// is set.
	//
	// .. attention::
	//
	//   Pay attention to the potential security implications of using this option. Provided header
	//   must come from trusted source.
	//
	// .. note::
	//
	//   If the header appears multiple times only the first value is used.
	host_rewrite_header?: string
	// Indicates that during forwarding, the host header will be swapped with
	// the result of the regex substitution executed on path value with query and fragment removed.
	// This is useful for transitioning variable content between path segment and subdomain.
	// Using this option will append the
	// :ref:`config_http_conn_man_headers_x-forwarded-host` header if
	// :ref:`append_x_forwarded_host <envoy_v3_api_field_config.route.v3.RouteAction.append_x_forwarded_host>`
	// is set.
	//
	// For example with the following config:
	//
	//   .. code-block:: yaml
	//
	//     host_rewrite_path_regex:
	//       pattern:
	//         google_re2: {}
	//         regex: "^/(.+)/.+$"
	//       substitution: \1
	//
	// Would rewrite the host header to ``envoyproxy.io/envoy-cue/spec`` given the path ``/envoyproxy.io/envoy-cue/spec/some/path``.
	host_rewrite_path_regex?: v32.#RegexMatchAndSubstitute
	// If set, then a host rewrite action (one of
	// :ref:`host_rewrite_literal <envoy_v3_api_field_config.route.v3.RouteAction.host_rewrite_literal>`,
	// :ref:`auto_host_rewrite <envoy_v3_api_field_config.route.v3.RouteAction.auto_host_rewrite>`,
	// :ref:`host_rewrite_header <envoy_v3_api_field_config.route.v3.RouteAction.host_rewrite_header>`, or
	// :ref:`host_rewrite_path_regex <envoy_v3_api_field_config.route.v3.RouteAction.host_rewrite_path_regex>`)
	// causes the original value of the host header, if any, to be appended to the
	// :ref:`config_http_conn_man_headers_x-forwarded-host` HTTP header.
	append_x_forwarded_host?: bool
	// Specifies the upstream timeout for the route. If not specified, the default is 15s. This
	// spans between the point at which the entire downstream request (i.e. end-of-stream) has been
	// processed and when the upstream response has been completely processed. A value of 0 will
	// disable the route's timeout.
	//
	// .. note::
	//
	//   This timeout includes all retries. See also
	//   :ref:`config_http_filters_router_x-envoy-upstream-rq-timeout-ms`,
	//   :ref:`config_http_filters_router_x-envoy-upstream-rq-per-try-timeout-ms`, and the
	//   :ref:`retry overview <arch_overview_http_routing_retry>`.
	timeout?: string
	// Specifies the idle timeout for the route. If not specified, there is no per-route idle timeout,
	// although the connection manager wide :ref:`stream_idle_timeout
	// <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.stream_idle_timeout>`
	// will still apply. A value of 0 will completely disable the route's idle timeout, even if a
	// connection manager stream idle timeout is configured.
	//
	// The idle timeout is distinct to :ref:`timeout
	// <envoy_v3_api_field_config.route.v3.RouteAction.timeout>`, which provides an upper bound
	// on the upstream response time; :ref:`idle_timeout
	// <envoy_v3_api_field_config.route.v3.RouteAction.idle_timeout>` instead bounds the amount
	// of time the request's stream may be idle.
	//
	// After header decoding, the idle timeout will apply on downstream and
	// upstream request events. Each time an encode/decode event for headers or
	// data is processed for the stream, the timer will be reset. If the timeout
	// fires, the stream is terminated with a 408 Request Timeout error code if no
	// upstream response header has been received, otherwise a stream reset
	// occurs.
	//
	// If the :ref:`overload action <config_overload_manager_overload_actions>` "envoy.overload_actions.reduce_timeouts"
	// is configured, this timeout is scaled according to the value for
	// :ref:`HTTP_DOWNSTREAM_STREAM_IDLE <envoy_v3_api_enum_value_config.overload.v3.ScaleTimersOverloadActionConfig.TimerType.HTTP_DOWNSTREAM_STREAM_IDLE>`.
	idle_timeout?: string
	// Specifies how to send request over TLS early data.
	// If absent, allows `safe HTTP requests <https://www.rfc-editor.org/rfc/rfc7231#section-4.2.1>`_ to be sent on early data.
	// [#extension-category: envoy.route.early_data_policy]
	early_data_policy?: v31.#TypedExtensionConfig
	// Indicates that the route has a retry policy. Note that if this is set,
	// it'll take precedence over the virtual host level retry policy entirely
	// (e.g.: policies are not merged, most internal one becomes the enforced policy).
	retry_policy?: #RetryPolicy
	// [#not-implemented-hide:]
	// Specifies the configuration for retry policy extension. Note that if this is set, it'll take
	// precedence over the virtual host level retry policy entirely (e.g.: policies are not merged,
	// most internal one becomes the enforced policy). :ref:`Retry policy <envoy_v3_api_field_config.route.v3.VirtualHost.retry_policy>`
	// should not be set if this field is used.
	retry_policy_typed_config?: _
	// Specify a set of route request mirroring policies.
	// It takes precedence over the virtual host and route config mirror policy entirely.
	// That is, policies are not merged, the most specific non-empty one becomes the mirror policies.
	request_mirror_policies?: [...#RouteAction_RequestMirrorPolicy]
	// Optionally specifies the :ref:`routing priority <arch_overview_http_routing_priority>`.
	priority?: v31.#RoutingPriority
	// Specifies a set of rate limit configurations that could be applied to the
	// route.
	rate_limits?: [...#RateLimit]
	// Specifies if the rate limit filter should include the virtual host rate
	// limits. By default, if the route configured rate limits, the virtual host
	// :ref:`rate_limits <envoy_v3_api_field_config.route.v3.VirtualHost.rate_limits>` are not applied to the
	// request.
	//
	// This field is deprecated. Please use :ref:`vh_rate_limits <envoy_v3_api_field_extensions.filters.http.ratelimit.v3.RateLimitPerRoute.vh_rate_limits>`
	//
	// Deprecated: Do not use.
	include_vh_rate_limits?: bool
	// Specifies a list of hash policies to use for ring hash load balancing. Each
	// hash policy is evaluated individually and the combined result is used to
	// route the request. The method of combination is deterministic such that
	// identical lists of hash policies will produce the same hash. Since a hash
	// policy examines specific parts of a request, it can fail to produce a hash
	// (i.e. if the hashed header is not present). If (and only if) all configured
	// hash policies fail to generate a hash, no hash will be produced for
	// the route. In this case, the behavior is the same as if no hash policies
	// were specified (i.e. the ring hash load balancer will choose a random
	// backend). If a hash policy has the "terminal" attribute set to true, and
	// there is already a hash generated, the hash is returned immediately,
	// ignoring the rest of the hash policy list.
	hash_policy?: [...#RouteAction_HashPolicy]
	// Indicates that the route has a CORS policy. This field is ignored if related cors policy is
	// found in the :ref:`Route.typed_per_filter_config<envoy_v3_api_field_config.route.v3.Route.typed_per_filter_config>` or
	// :ref:`WeightedCluster.ClusterWeight.typed_per_filter_config<envoy_v3_api_field_config.route.v3.WeightedCluster.ClusterWeight.typed_per_filter_config>`.
	//
	// .. attention::
	//
	//   This option has been deprecated. Please use
	//   :ref:`Route.typed_per_filter_config<envoy_v3_api_field_config.route.v3.Route.typed_per_filter_config>` or
	//   :ref:`WeightedCluster.ClusterWeight.typed_per_filter_config<envoy_v3_api_field_config.route.v3.WeightedCluster.ClusterWeight.typed_per_filter_config>`
	//   to configure the CORS HTTP filter.
	//
	// Deprecated: Do not use.
	cors?: #CorsPolicy
	// Deprecated by :ref:`grpc_timeout_header_max <envoy_v3_api_field_config.route.v3.RouteAction.MaxStreamDuration.grpc_timeout_header_max>`
	// If present, and the request is a gRPC request, use the
	// `grpc-timeout header <https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-HTTP2.md>`_,
	// or its default value (infinity) instead of
	// :ref:`timeout <envoy_v3_api_field_config.route.v3.RouteAction.timeout>`, but limit the applied timeout
	// to the maximum value specified here. If configured as 0, the maximum allowed timeout for
	// gRPC requests is infinity. If not configured at all, the ``grpc-timeout`` header is not used
	// and gRPC requests time out like any other requests using
	// :ref:`timeout <envoy_v3_api_field_config.route.v3.RouteAction.timeout>` or its default.
	// This can be used to prevent unexpected upstream request timeouts due to potentially long
	// time gaps between gRPC request and response in gRPC streaming mode.
	//
	// .. note::
	//
	//    If a timeout is specified using :ref:`config_http_filters_router_x-envoy-upstream-rq-timeout-ms`, it takes
	//    precedence over `grpc-timeout header <https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-HTTP2.md>`_, when
	//    both are present. See also
	//    :ref:`config_http_filters_router_x-envoy-upstream-rq-timeout-ms`,
	//    :ref:`config_http_filters_router_x-envoy-upstream-rq-per-try-timeout-ms`, and the
	//    :ref:`retry overview <arch_overview_http_routing_retry>`.
	//
	// Deprecated: Do not use.
	max_grpc_timeout?: string
	// Deprecated by :ref:`grpc_timeout_header_offset <envoy_v3_api_field_config.route.v3.RouteAction.MaxStreamDuration.grpc_timeout_header_offset>`.
	// If present, Envoy will adjust the timeout provided by the ``grpc-timeout`` header by subtracting
	// the provided duration from the header. This is useful in allowing Envoy to set its global
	// timeout to be less than that of the deadline imposed by the calling client, which makes it more
	// likely that Envoy will handle the timeout instead of having the call canceled by the client.
	// The offset will only be applied if the provided grpc_timeout is greater than the offset. This
	// ensures that the offset will only ever decrease the timeout and never set it to 0 (meaning
	// infinity).
	//
	// Deprecated: Do not use.
	grpc_timeout_offset?: string
	upgrade_configs?: [...#RouteAction_UpgradeConfig]
	// If present, Envoy will try to follow an upstream redirect response instead of proxying the
	// response back to the downstream. An upstream redirect response is defined
	// by :ref:`redirect_response_codes
	// <envoy_v3_api_field_config.route.v3.InternalRedirectPolicy.redirect_response_codes>`.
	internal_redirect_policy?: #InternalRedirectPolicy
	// Deprecated: Do not use.
	internal_redirect_action?: #RouteAction_InternalRedirectAction
	// An internal redirect is handled, iff the number of previous internal redirects that a
	// downstream request has encountered is lower than this value, and
	// :ref:`internal_redirect_action <envoy_v3_api_field_config.route.v3.RouteAction.internal_redirect_action>`
	// is set to :ref:`HANDLE_INTERNAL_REDIRECT
	// <envoy_v3_api_enum_value_config.route.v3.RouteAction.InternalRedirectAction.HANDLE_INTERNAL_REDIRECT>`
	// In the case where a downstream request is bounced among multiple routes by internal redirect,
	// the first route that hits this threshold, or has
	// :ref:`internal_redirect_action <envoy_v3_api_field_config.route.v3.RouteAction.internal_redirect_action>`
	// set to
	// :ref:`PASS_THROUGH_INTERNAL_REDIRECT
	// <envoy_v3_api_enum_value_config.route.v3.RouteAction.InternalRedirectAction.PASS_THROUGH_INTERNAL_REDIRECT>`
	// will pass the redirect back to downstream.
	//
	// If not specified, at most one redirect will be followed.
	//
	// Deprecated: Do not use.
	max_internal_redirects?: uint32
	// Indicates that the route has a hedge policy. Note that if this is set,
	// it'll take precedence over the virtual host level hedge policy entirely
	// (e.g.: policies are not merged, most internal one becomes the enforced policy).
	hedge_policy?: #HedgePolicy
	// Specifies the maximum stream duration for this route.
	max_stream_duration?: #RouteAction_MaxStreamDuration
}

// HTTP retry :ref:`architecture overview <arch_overview_http_routing_retry>`.
// [#next-free-field: 14]
#RetryPolicy: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RetryPolicy"
	// Specifies the conditions under which retry takes place. These are the same
	// conditions documented for :ref:`config_http_filters_router_x-envoy-retry-on` and
	// :ref:`config_http_filters_router_x-envoy-retry-grpc-on`.
	retry_on?: string
	// Specifies the allowed number of retries. This parameter is optional and
	// defaults to 1. These are the same conditions documented for
	// :ref:`config_http_filters_router_x-envoy-max-retries`.
	num_retries?: uint32
	// Specifies a non-zero upstream timeout per retry attempt (including the initial attempt). This
	// parameter is optional. The same conditions documented for
	// :ref:`config_http_filters_router_x-envoy-upstream-rq-per-try-timeout-ms` apply.
	//
	// .. note::
	//
	//   If left unspecified, Envoy will use the global
	//   :ref:`route timeout <envoy_v3_api_field_config.route.v3.RouteAction.timeout>` for the request.
	//   Consequently, when using a :ref:`5xx <config_http_filters_router_x-envoy-retry-on>` based
	//   retry policy, a request that times out will not be retried as the total timeout budget
	//   would have been exhausted.
	per_try_timeout?: string
	// Specifies an upstream idle timeout per retry attempt (including the initial attempt). This
	// parameter is optional and if absent there is no per try idle timeout. The semantics of the per
	// try idle timeout are similar to the
	// :ref:`route idle timeout <envoy_v3_api_field_config.route.v3.RouteAction.timeout>` and
	// :ref:`stream idle timeout
	// <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.stream_idle_timeout>`
	// both enforced by the HTTP connection manager. The difference is that this idle timeout
	// is enforced by the router for each individual attempt and thus after all previous filters have
	// run, as opposed to *before* all previous filters run for the other idle timeouts. This timeout
	// is useful in cases in which total request timeout is bounded by a number of retries and a
	// :ref:`per_try_timeout <envoy_v3_api_field_config.route.v3.RetryPolicy.per_try_timeout>`, but
	// there is a desire to ensure each try is making incremental progress. Note also that similar
	// to :ref:`per_try_timeout <envoy_v3_api_field_config.route.v3.RetryPolicy.per_try_timeout>`,
	// this idle timeout does not start until after both the entire request has been received by the
	// router *and* a connection pool connection has been obtained. Unlike
	// :ref:`per_try_timeout <envoy_v3_api_field_config.route.v3.RetryPolicy.per_try_timeout>`,
	// the idle timer continues once the response starts streaming back to the downstream client.
	// This ensures that response data continues to make progress without using one of the HTTP
	// connection manager idle timeouts.
	per_try_idle_timeout?: string
	// Specifies an implementation of a RetryPriority which is used to determine the
	// distribution of load across priorities used for retries. Refer to
	// :ref:`retry plugin configuration <arch_overview_http_retry_plugins>` for more details.
	retry_priority?: #RetryPolicy_RetryPriority
	// Specifies a collection of RetryHostPredicates that will be consulted when selecting a host
	// for retries. If any of the predicates reject the host, host selection will be reattempted.
	// Refer to :ref:`retry plugin configuration <arch_overview_http_retry_plugins>` for more
	// details.
	retry_host_predicate?: [...#RetryPolicy_RetryHostPredicate]
	// Retry options predicates that will be applied prior to retrying a request. These predicates
	// allow customizing request behavior between retries.
	// [#comment: add [#extension-category: envoy.retry_options_predicates] when there are built-in extensions]
	retry_options_predicates?: [...v31.#TypedExtensionConfig]
	// The maximum number of times host selection will be reattempted before giving up, at which
	// point the host that was last selected will be routed to. If unspecified, this will default to
	// retrying once.
	host_selection_retry_max_attempts?: int64
	// HTTP status codes that should trigger a retry in addition to those specified by retry_on.
	retriable_status_codes?: [...uint32]
	// Specifies parameters that control exponential retry back off. This parameter is optional, in which case the
	// default base interval is 25 milliseconds or, if set, the current value of the
	// ``upstream.base_retry_backoff_ms`` runtime parameter. The default maximum interval is 10 times
	// the base interval. The documentation for :ref:`config_http_filters_router_x-envoy-max-retries`
	// describes Envoy's back-off algorithm.
	retry_back_off?: #RetryPolicy_RetryBackOff
	// Specifies parameters that control a retry back-off strategy that is used
	// when the request is rate limited by the upstream server. The server may
	// return a response header like ``Retry-After`` or ``X-RateLimit-Reset`` to
	// provide feedback to the client on how long to wait before retrying. If
	// configured, this back-off strategy will be used instead of the
	// default exponential back off strategy (configured using ``retry_back_off``)
	// whenever a response includes the matching headers.
	rate_limited_retry_back_off?: #RetryPolicy_RateLimitedRetryBackOff
	// HTTP response headers that trigger a retry if present in the response. A retry will be
	// triggered if any of the header matches match the upstream response headers.
	// The field is only consulted if 'retriable-headers' retry policy is active.
	retriable_headers?: [...#HeaderMatcher]
	// HTTP headers which must be present in the request for retries to be attempted.
	retriable_request_headers?: [...#HeaderMatcher]
}

// HTTP request hedging :ref:`architecture overview <arch_overview_http_routing_hedging>`.
#HedgePolicy: {
	"@type": "type.googleapis.com/envoy.config.route.v3.HedgePolicy"
	// Specifies the number of initial requests that should be sent upstream.
	// Must be at least 1.
	// Defaults to 1.
	// [#not-implemented-hide:]
	initial_requests?: uint32
	// Specifies a probability that an additional upstream request should be sent
	// on top of what is specified by initial_requests.
	// Defaults to 0.
	// [#not-implemented-hide:]
	additional_request_chance?: v33.#FractionalPercent
	// Indicates that a hedged request should be sent when the per-try timeout is hit.
	// This means that a retry will be issued without resetting the original request, leaving multiple upstream requests in flight.
	// The first request to complete successfully will be the one returned to the caller.
	//
	// * At any time, a successful response (i.e. not triggering any of the retry-on conditions) would be returned to the client.
	// * Before per-try timeout, an error response (per retry-on conditions) would be retried immediately or returned ot the client
	//   if there are no more retries left.
	// * After per-try timeout, an error response would be discarded, as a retry in the form of a hedged request is already in progress.
	//
	// Note: For this to have effect, you must have a :ref:`RetryPolicy <envoy_v3_api_msg_config.route.v3.RetryPolicy>` that retries at least
	// one error code and specifies a maximum number of retries.
	//
	// Defaults to false.
	hedge_on_per_try_timeout?: bool
}

// [#next-free-field: 10]
#RedirectAction: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RedirectAction"
	// The scheme portion of the URL will be swapped with "https".
	https_redirect?: bool
	// The scheme portion of the URL will be swapped with this value.
	scheme_redirect?: string
	// The host portion of the URL will be swapped with this value.
	host_redirect?: string
	// The port value of the URL will be swapped with this value.
	port_redirect?: uint32
	// The path portion of the URL will be swapped with this value.
	// Please note that query string in path_redirect will override the
	// request's query string and will not be stripped.
	//
	// For example, let's say we have the following routes:
	//
	// - match: { path: "/old-path-1" }
	//   redirect: { path_redirect: "/new-path-1" }
	// - match: { path: "/old-path-2" }
	//   redirect: { path_redirect: "/new-path-2", strip-query: "true" }
	// - match: { path: "/old-path-3" }
	//   redirect: { path_redirect: "/new-path-3?foo=1", strip_query: "true" }
	//
	// 1. if request uri is "/old-path-1?bar=1", users will be redirected to "/new-path-1?bar=1"
	// 2. if request uri is "/old-path-2?bar=1", users will be redirected to "/new-path-2"
	// 3. if request uri is "/old-path-3?bar=1", users will be redirected to "/new-path-3?foo=1"
	path_redirect?: string
	// Indicates that during redirection, the matched prefix (or path)
	// should be swapped with this value. This option allows redirect URLs be dynamically created
	// based on the request.
	//
	// .. attention::
	//
	//   Pay attention to the use of trailing slashes as mentioned in
	//   :ref:`RouteAction's prefix_rewrite <envoy_v3_api_field_config.route.v3.RouteAction.prefix_rewrite>`.
	prefix_rewrite?: string
	// Indicates that during redirect, portions of the path that match the
	// pattern should be rewritten, even allowing the substitution of capture
	// groups from the pattern into the new path as specified by the rewrite
	// substitution string. This is useful to allow application paths to be
	// rewritten in a way that is aware of segments with variable content like
	// identifiers.
	//
	// Examples using Google's `RE2 <https://github.com/google/re2>`_ engine:
	//
	// * The path pattern ``^/service/([^/]+)(/.*)$`` paired with a substitution
	//   string of ``\2/instance/\1`` would transform ``/service/foo/v1/api``
	//   into ``/v1/api/instance/foo``.
	//
	// * The pattern ``one`` paired with a substitution string of ``two`` would
	//   transform ``/xxx/one/yyy/one/zzz`` into ``/xxx/two/yyy/two/zzz``.
	//
	// * The pattern ``^(.*?)one(.*)$`` paired with a substitution string of
	//   ``\1two\2`` would replace only the first occurrence of ``one``,
	//   transforming path ``/xxx/one/yyy/one/zzz`` into ``/xxx/two/yyy/one/zzz``.
	//
	// * The pattern ``(?i)/xxx/`` paired with a substitution string of ``/yyy/``
	//   would do a case-insensitive match and transform path ``/aaa/XxX/bbb`` to
	//   ``/aaa/yyy/bbb``.
	regex_rewrite?: v32.#RegexMatchAndSubstitute
	// The HTTP status code to use in the redirect response. The default response
	// code is MOVED_PERMANENTLY (301).
	response_code?: #RedirectAction_RedirectResponseCode
	// Indicates that during redirection, the query portion of the URL will
	// be removed. Default value is false.
	strip_query?: bool
}

#DirectResponseAction: {
	"@type": "type.googleapis.com/envoy.config.route.v3.DirectResponseAction"
	// Specifies the HTTP response status to be returned.
	status?: uint32
	// Specifies the content of the response body. If this setting is omitted,
	// no body is included in the generated response.
	//
	// .. note::
	//
	//   Headers can be specified using ``response_headers_to_add`` in the enclosing
	//   :ref:`envoy_v3_api_msg_config.route.v3.Route`, :ref:`envoy_v3_api_msg_config.route.v3.RouteConfiguration` or
	//   :ref:`envoy_v3_api_msg_config.route.v3.VirtualHost`.
	body?: v31.#DataSource
}

// [#not-implemented-hide:]
#NonForwardingAction: {
	"@type": "type.googleapis.com/envoy.config.route.v3.NonForwardingAction"
}

#Decorator: {
	"@type": "type.googleapis.com/envoy.config.route.v3.Decorator"
	// The operation name associated with the request matched to this route. If tracing is
	// enabled, this information will be used as the span name reported for this request.
	//
	// .. note::
	//
	//   For ingress (inbound) requests, or egress (outbound) responses, this value may be overridden
	//   by the :ref:`x-envoy-decorator-operation
	//   <config_http_filters_router_x-envoy-decorator-operation>` header.
	operation?: string
	// Whether the decorated details should be propagated to the other party. The default is true.
	propagate?: bool
}

#Tracing: {
	"@type": "type.googleapis.com/envoy.config.route.v3.Tracing"
	// Target percentage of requests managed by this HTTP connection manager that will be force
	// traced if the :ref:`x-client-trace-id <config_http_conn_man_headers_x-client-trace-id>`
	// header is set. This field is a direct analog for the runtime variable
	// 'tracing.client_sampling' in the :ref:`HTTP Connection Manager
	// <config_http_conn_man_runtime>`.
	// Default: 100%
	client_sampling?: v33.#FractionalPercent
	// Target percentage of requests managed by this HTTP connection manager that will be randomly
	// selected for trace generation, if not requested by the client or not forced. This field is
	// a direct analog for the runtime variable 'tracing.random_sampling' in the
	// :ref:`HTTP Connection Manager <config_http_conn_man_runtime>`.
	// Default: 100%
	random_sampling?: v33.#FractionalPercent
	// Target percentage of requests managed by this HTTP connection manager that will be traced
	// after all other sampling checks have been applied (client-directed, force tracing, random
	// sampling). This field functions as an upper limit on the total configured sampling rate. For
	// instance, setting client_sampling to 100% but overall_sampling to 1% will result in only 1%
	// of client requests with the appropriate headers to be force traced. This field is a direct
	// analog for the runtime variable 'tracing.global_enabled' in the
	// :ref:`HTTP Connection Manager <config_http_conn_man_runtime>`.
	// Default: 100%
	overall_sampling?: v33.#FractionalPercent
	// A list of custom tags with unique tag name to create tags for the active span.
	// It will take effect after merging with the :ref:`corresponding configuration
	// <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.Tracing.custom_tags>`
	// configured in the HTTP connection manager. If two tags with the same name are configured
	// each in the HTTP connection manager and the route level, the one configured here takes
	// priority.
	custom_tags?: [...v34.#CustomTag]
}

// A virtual cluster is a way of specifying a regex matching rule against
// certain important endpoints such that statistics are generated explicitly for
// the matched requests. The reason this is useful is that when doing
// prefix/path matching Envoy does not always know what the application
// considers to be an endpoint. Thus, it’s impossible for Envoy to generically
// emit per endpoint statistics. However, often systems have highly critical
// endpoints that they wish to get “perfect” statistics on. Virtual cluster
// statistics are perfect in the sense that they are emitted on the downstream
// side such that they include network level failures.
//
// Documentation for :ref:`virtual cluster statistics <config_http_filters_router_vcluster_stats>`.
//
// .. note::
//
//    Virtual clusters are a useful tool, but we do not recommend setting up a virtual cluster for
//    every application endpoint. This is both not easily maintainable and as well the matching and
//    statistics output are not free.
#VirtualCluster: {
	"@type": "type.googleapis.com/envoy.config.route.v3.VirtualCluster"
	// Specifies a list of header matchers to use for matching requests. Each specified header must
	// match. The pseudo-headers ``:path`` and ``:method`` can be used to match the request path and
	// method, respectively.
	headers?: [...#HeaderMatcher]
	// Specifies the name of the virtual cluster. The virtual cluster name as well
	// as the virtual host name are used when emitting statistics. The statistics are emitted by the
	// router filter and are documented :ref:`here <config_http_filters_router_stats>`.
	name?: string
}

// Global rate limiting :ref:`architecture overview <arch_overview_global_rate_limit>`.
// Also applies to Local rate limiting :ref:`using descriptors <config_http_filters_local_rate_limit_descriptors>`.
#RateLimit: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit"
	// Refers to the stage set in the filter. The rate limit configuration only
	// applies to filters with the same stage number. The default stage number is
	// 0.
	//
	// .. note::
	//
	//   The filter supports a range of 0 - 10 inclusively for stage numbers.
	stage?: uint32
	// The key to be set in runtime to disable this rate limit configuration.
	disable_key?: string
	// A list of actions that are to be applied for this rate limit configuration.
	// Order matters as the actions are processed sequentially and the descriptor
	// is composed by appending descriptor entries in that sequence. If an action
	// cannot append a descriptor entry, no descriptor is generated for the
	// configuration. See :ref:`composing actions
	// <config_http_filters_rate_limit_composing_actions>` for additional documentation.
	actions?: [...#RateLimit_Action]
	// An optional limit override to be appended to the descriptor produced by this
	// rate limit configuration. If the override value is invalid or cannot be resolved
	// from metadata, no override is provided. See :ref:`rate limit override
	// <config_http_filters_rate_limit_rate_limit_override>` for more information.
	limit?: #RateLimit_Override
}

// .. attention::
//
//   Internally, Envoy always uses the HTTP/2 ``:authority`` header to represent the HTTP/1 ``Host``
//   header. Thus, if attempting to match on ``Host``, match on ``:authority`` instead.
//
// .. attention::
//
//   To route on HTTP method, use the special HTTP/2 ``:method`` header. This works for both
//   HTTP/1 and HTTP/2 as Envoy normalizes headers. E.g.,
//
//   .. code-block:: json
//
//     {
//       "name": ":method",
//       "exact_match": "POST"
//     }
//
// .. attention::
//   In the absence of any header match specifier, match will default to :ref:`present_match
//   <envoy_v3_api_field_config.route.v3.HeaderMatcher.present_match>`. i.e, a request that has the :ref:`name
//   <envoy_v3_api_field_config.route.v3.HeaderMatcher.name>` header will match, regardless of the header's
//   value.
//
//  [#next-major-version: HeaderMatcher should be refactored to use StringMatcher.]
// [#next-free-field: 15]
#HeaderMatcher: {
	"@type": "type.googleapis.com/envoy.config.route.v3.HeaderMatcher"
	// Specifies the name of the header in the request.
	name?: string
	// If specified, header match will be performed based on the value of the header.
	// This field is deprecated. Please use :ref:`string_match <envoy_v3_api_field_config.route.v3.HeaderMatcher.string_match>`.
	//
	// Deprecated: Do not use.
	exact_match?: string
	// If specified, this regex string is a regular expression rule which implies the entire request
	// header value must match the regex. The rule will not match if only a subsequence of the
	// request header value matches the regex.
	// This field is deprecated. Please use :ref:`string_match <envoy_v3_api_field_config.route.v3.HeaderMatcher.string_match>`.
	//
	// Deprecated: Do not use.
	safe_regex_match?: v32.#RegexMatcher
	// If specified, header match will be performed based on range.
	// The rule will match if the request header value is within this range.
	// The entire request header value must represent an integer in base 10 notation: consisting of
	// an optional plus or minus sign followed by a sequence of digits. The rule will not match if
	// the header value does not represent an integer. Match will fail for empty values, floating
	// point numbers or if only a subsequence of the header value is an integer.
	//
	// Examples:
	//
	// * For range [-10,0), route will match for header value -1, but not for 0, ``somestring``, 10.9,
	//   ``-1somestring``
	range_match?: v33.#Int64Range
	// If specified as true, header match will be performed based on whether the header is in the
	// request. If specified as false, header match will be performed based on whether the header is absent.
	present_match?: bool
	// If specified, header match will be performed based on the prefix of the header value.
	// Note: empty prefix is not allowed, please use present_match instead.
	// This field is deprecated. Please use :ref:`string_match <envoy_v3_api_field_config.route.v3.HeaderMatcher.string_match>`.
	//
	// Examples:
	//
	// * The prefix ``abcd`` matches the value ``abcdxyz``, but not for ``abcxyz``.
	//
	// Deprecated: Do not use.
	prefix_match?: string
	// If specified, header match will be performed based on the suffix of the header value.
	// Note: empty suffix is not allowed, please use present_match instead.
	// This field is deprecated. Please use :ref:`string_match <envoy_v3_api_field_config.route.v3.HeaderMatcher.string_match>`.
	//
	// Examples:
	//
	// * The suffix ``abcd`` matches the value ``xyzabcd``, but not for ``xyzbcd``.
	//
	// Deprecated: Do not use.
	suffix_match?: string
	// If specified, header match will be performed based on whether the header value contains
	// the given value or not.
	// Note: empty contains match is not allowed, please use present_match instead.
	// This field is deprecated. Please use :ref:`string_match <envoy_v3_api_field_config.route.v3.HeaderMatcher.string_match>`.
	//
	// Examples:
	//
	// * The value ``abcd`` matches the value ``xyzabcdpqr``, but not for ``xyzbcdpqr``.
	//
	// Deprecated: Do not use.
	contains_match?: string
	// If specified, header match will be performed based on the string match of the header value.
	string_match?: v32.#StringMatcher
	// If specified, the match result will be inverted before checking. Defaults to false.
	//
	// Examples:
	//
	// * The regex ``\d{3}`` does not match the value ``1234``, so it will match when inverted.
	// * The range [-10,0) will match the value -1, so it will not match when inverted.
	invert_match?: bool
	// If specified, for any header match rule, if the header match rule specified header
	// does not exist, this header value will be treated as empty. Defaults to false.
	//
	// Examples:
	//
	// * The header match rule specified header "header1" to range match of [0, 10],
	//   :ref:`invert_match <envoy_v3_api_field_config.route.v3.HeaderMatcher.invert_match>`
	//   is set to true and :ref:`treat_missing_header_as_empty <envoy_v3_api_field_config.route.v3.HeaderMatcher.treat_missing_header_as_empty>`
	//   is set to true; The "header1" header is not present. The match rule will
	//   treat the "header1" as an empty header. The empty header does not match the range,
	//   so it will match when inverted.
	// * The header match rule specified header "header2" to range match of [0, 10],
	//   :ref:`invert_match <envoy_v3_api_field_config.route.v3.HeaderMatcher.invert_match>`
	//   is set to true and :ref:`treat_missing_header_as_empty <envoy_v3_api_field_config.route.v3.HeaderMatcher.treat_missing_header_as_empty>`
	//   is set to false; The "header2" header is not present and the header
	//   matcher rule for "header2" will be ignored so it will not match.
	// * The header match rule specified header "header3" to a string regex match
	//   ``^$`` which means an empty string, and
	//   :ref:`treat_missing_header_as_empty <envoy_v3_api_field_config.route.v3.HeaderMatcher.treat_missing_header_as_empty>`
	//   is set to true; The "header3" header is not present.
	//   The match rule will treat the "header3" header as an empty header so it will match.
	// * The header match rule specified header "header4" to a string regex match
	//   ``^$`` which means an empty string, and
	//   :ref:`treat_missing_header_as_empty <envoy_v3_api_field_config.route.v3.HeaderMatcher.treat_missing_header_as_empty>`
	//   is set to false; The "header4" header is not present.
	//   The match rule for "header4" will be ignored so it will not match.
	treat_missing_header_as_empty?: bool
}

// Query parameter matching treats the query string of a request's :path header
// as an ampersand-separated list of keys and/or key=value elements.
// [#next-free-field: 7]
#QueryParameterMatcher: {
	"@type": "type.googleapis.com/envoy.config.route.v3.QueryParameterMatcher"
	// Specifies the name of a key that must be present in the requested
	// ``path``'s query string.
	name?: string
	// Specifies whether a query parameter value should match against a string.
	string_match?: v32.#StringMatcher
	// Specifies whether a query parameter should be present.
	present_match?: bool
}

// HTTP Internal Redirect :ref:`architecture overview <arch_overview_internal_redirects>`.
#InternalRedirectPolicy: {
	"@type": "type.googleapis.com/envoy.config.route.v3.InternalRedirectPolicy"
	// An internal redirect is not handled, unless the number of previous internal redirects that a
	// downstream request has encountered is lower than this value.
	// In the case where a downstream request is bounced among multiple routes by internal redirect,
	// the first route that hits this threshold, or does not set :ref:`internal_redirect_policy
	// <envoy_v3_api_field_config.route.v3.RouteAction.internal_redirect_policy>`
	// will pass the redirect back to downstream.
	//
	// If not specified, at most one redirect will be followed.
	max_internal_redirects?: uint32
	// Defines what upstream response codes are allowed to trigger internal redirect. If unspecified,
	// only 302 will be treated as internal redirect.
	// Only 301, 302, 303, 307 and 308 are valid values. Any other codes will be ignored.
	redirect_response_codes?: [...uint32]
	// Specifies a list of predicates that are queried when an upstream response is deemed
	// to trigger an internal redirect by all other criteria. Any predicate in the list can reject
	// the redirect, causing the response to be proxied to downstream.
	// [#extension-category: envoy.internal_redirect_predicates]
	predicates?: [...v31.#TypedExtensionConfig]
	// Allow internal redirect to follow a target URI with a different scheme than the value of
	// x-forwarded-proto. The default is false.
	allow_cross_scheme_redirect?: bool
}

// A simple wrapper for an HTTP filter config. This is intended to be used as a wrapper for the
// map value in
// :ref:`VirtualHost.typed_per_filter_config<envoy_v3_api_field_config.route.v3.VirtualHost.typed_per_filter_config>`,
// :ref:`Route.typed_per_filter_config<envoy_v3_api_field_config.route.v3.Route.typed_per_filter_config>`,
// or :ref:`WeightedCluster.ClusterWeight.typed_per_filter_config<envoy_v3_api_field_config.route.v3.WeightedCluster.ClusterWeight.typed_per_filter_config>`
// to add additional flags to the filter.
// [#not-implemented-hide:]
#FilterConfig: {
	"@type": "type.googleapis.com/envoy.config.route.v3.FilterConfig"
	// The filter config.
	config?: _
	// If true, the filter is optional, meaning that if the client does
	// not support the specified filter, it may ignore the map entry rather
	// than rejecting the config.
	is_optional?: bool
}

// [#next-free-field: 13]
#WeightedCluster_ClusterWeight: {
	"@type": "type.googleapis.com/envoy.config.route.v3.WeightedCluster_ClusterWeight"
	// Only one of ``name`` and ``cluster_header`` may be specified.
	// [#next-major-version: Need to add back the validation rule: (validate.rules).string = {min_len: 1}]
	// Name of the upstream cluster. The cluster must exist in the
	// :ref:`cluster manager configuration <config_cluster_manager>`.
	name?: string
	// Only one of ``name`` and ``cluster_header`` may be specified.
	// [#next-major-version: Need to add back the validation rule: (validate.rules).string = {min_len: 1 }]
	// Envoy will determine the cluster to route to by reading the value of the
	// HTTP header named by cluster_header from the request headers. If the
	// header is not found or the referenced cluster does not exist, Envoy will
	// return a 404 response.
	//
	// .. attention::
	//
	//   Internally, Envoy always uses the HTTP/2 ``:authority`` header to represent the HTTP/1
	//   ``Host`` header. Thus, if attempting to match on ``Host``, match on ``:authority`` instead.
	//
	// .. note::
	//
	//   If the header appears multiple times only the first value is used.
	cluster_header?: string
	// The weight of the cluster. This value is relative to the other clusters'
	// weights. When a request matches the route, the choice of an upstream cluster
	// is determined by its weight. The sum of weights across all
	// entries in the clusters array must be greater than 0.
	weight?: uint32
	// Optional endpoint metadata match criteria used by the subset load balancer. Only endpoints in
	// the upstream cluster with metadata matching what is set in this field will be considered for
	// load balancing. Note that this will be merged with what's provided in
	// :ref:`RouteAction.metadata_match <envoy_v3_api_field_config.route.v3.RouteAction.metadata_match>`, with
	// values here taking precedence. The filter name should be specified as ``envoy.lb``.
	metadata_match?: v31.#Metadata
	// Specifies a list of headers to be added to requests when this cluster is selected
	// through the enclosing :ref:`envoy_v3_api_msg_config.route.v3.RouteAction`.
	// Headers specified at this level are applied before headers from the enclosing
	// :ref:`envoy_v3_api_msg_config.route.v3.Route`, :ref:`envoy_v3_api_msg_config.route.v3.VirtualHost`, and
	// :ref:`envoy_v3_api_msg_config.route.v3.RouteConfiguration`. For more information, including details on
	// header value syntax, see the documentation on :ref:`custom request headers
	// <config_http_conn_man_headers_custom_request_headers>`.
	request_headers_to_add?: [...v31.#HeaderValueOption]
	// Specifies a list of HTTP headers that should be removed from each request when
	// this cluster is selected through the enclosing :ref:`envoy_v3_api_msg_config.route.v3.RouteAction`.
	request_headers_to_remove?: [...string]
	// Specifies a list of headers to be added to responses when this cluster is selected
	// through the enclosing :ref:`envoy_v3_api_msg_config.route.v3.RouteAction`.
	// Headers specified at this level are applied before headers from the enclosing
	// :ref:`envoy_v3_api_msg_config.route.v3.Route`, :ref:`envoy_v3_api_msg_config.route.v3.VirtualHost`, and
	// :ref:`envoy_v3_api_msg_config.route.v3.RouteConfiguration`. For more information, including details on
	// header value syntax, see the documentation on :ref:`custom request headers
	// <config_http_conn_man_headers_custom_request_headers>`.
	response_headers_to_add?: [...v31.#HeaderValueOption]
	// Specifies a list of headers to be removed from responses when this cluster is selected
	// through the enclosing :ref:`envoy_v3_api_msg_config.route.v3.RouteAction`.
	response_headers_to_remove?: [...string]
	// The per_filter_config field can be used to provide weighted cluster-specific configurations
	// for filters.
	// The key should match the :ref:`filter config name
	// <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpFilter.name>`.
	// The canonical filter name (e.g., ``envoy.filters.http.buffer`` for the HTTP buffer filter) can also
	// be used for the backwards compatibility. If there is no entry referred by the filter config name, the
	// entry referred by the canonical filter name will be provided to the filters as fallback.
	//
	// Use of this field is filter specific;
	// see the :ref:`HTTP filter documentation <config_http_filters>` for if and how it is utilized.
	// [#comment: An entry's value may be wrapped in a
	// :ref:`FilterConfig<envoy_v3_api_msg_config.route.v3.FilterConfig>`
	// message to specify additional options.]
	typed_per_filter_config?: [string]: _
	// Indicates that during forwarding, the host header will be swapped with
	// this value.
	host_rewrite_literal?: string
}

#RouteMatch_GrpcRouteMatchOptions: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteMatch_GrpcRouteMatchOptions"
}

#RouteMatch_TlsContextMatchOptions: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteMatch_TlsContextMatchOptions"
	// If specified, the route will match against whether or not a certificate is presented.
	// If not specified, certificate presentation status (true or false) will not be considered when route matching.
	presented?: bool
	// If specified, the route will match against whether or not a certificate is validated.
	// If not specified, certificate validation status (true or false) will not be considered when route matching.
	validated?: bool
}

// An extensible message for matching CONNECT requests.
#RouteMatch_ConnectMatcher: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteMatch_ConnectMatcher"
}

// The router is capable of shadowing traffic from one cluster to another. The current
// implementation is "fire and forget," meaning Envoy will not wait for the shadow cluster to
// respond before returning the response from the primary cluster. All normal statistics are
// collected for the shadow cluster making this feature useful for testing.
//
// During shadowing, the host/authority header is altered such that ``-shadow`` is appended. This is
// useful for logging. For example, ``cluster1`` becomes ``cluster1-shadow``.
//
// .. note::
//
//   Shadowing will not be triggered if the primary cluster does not exist.
//
// .. note::
//
//   Shadowing doesn't support Http CONNECT and upgrades.
// [#next-free-field: 6]
#RouteAction_RequestMirrorPolicy: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteAction_RequestMirrorPolicy"
	// Only one of ``cluster`` and ``cluster_header`` can be specified.
	// [#next-major-version: Need to add back the validation rule: (validate.rules).string = {min_len: 1}]
	// Specifies the cluster that requests will be mirrored to. The cluster must
	// exist in the cluster manager configuration.
	cluster?: string
	// Only one of ``cluster`` and ``cluster_header`` can be specified.
	// Envoy will determine the cluster to route to by reading the value of the
	// HTTP header named by cluster_header from the request headers. Only the first value in header is used,
	// and no shadow request will happen if the value is not found in headers. Envoy will not wait for
	// the shadow cluster to respond before returning the response from the primary cluster.
	//
	// .. attention::
	//
	//   Internally, Envoy always uses the HTTP/2 ``:authority`` header to represent the HTTP/1
	//   ``Host`` header. Thus, if attempting to match on ``Host``, match on ``:authority`` instead.
	//
	// .. note::
	//
	//   If the header appears multiple times only the first value is used.
	cluster_header?: string
	// If not specified, all requests to the target cluster will be mirrored.
	//
	// If specified, this field takes precedence over the ``runtime_key`` field and requests must also
	// fall under the percentage of matches indicated by this field.
	//
	// For some fraction N/D, a random number in the range [0,D) is selected. If the
	// number is <= the value of the numerator N, or if the key is not present, the default
	// value, the request will be mirrored.
	runtime_fraction?: v31.#RuntimeFractionalPercent
	// Determines if the trace span should be sampled. Defaults to true.
	trace_sampled?: bool
}

// Specifies the route's hashing policy if the upstream cluster uses a hashing :ref:`load balancer
// <arch_overview_load_balancing_types>`.
// [#next-free-field: 7]
#RouteAction_HashPolicy: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteAction_HashPolicy"
	// Header hash policy.
	header?: #RouteAction_HashPolicy_Header
	// Cookie hash policy.
	cookie?: #RouteAction_HashPolicy_Cookie
	// Connection properties hash policy.
	connection_properties?: #RouteAction_HashPolicy_ConnectionProperties
	// Query parameter hash policy.
	query_parameter?: #RouteAction_HashPolicy_QueryParameter
	// Filter state hash policy.
	filter_state?: #RouteAction_HashPolicy_FilterState
	// The flag that short-circuits the hash computing. This field provides a
	// 'fallback' style of configuration: "if a terminal policy doesn't work,
	// fallback to rest of the policy list", it saves time when the terminal
	// policy works.
	//
	// If true, and there is already a hash computed, ignore rest of the
	// list of hash polices.
	// For example, if the following hash methods are configured:
	//
	//  ========= ========
	//  specifier terminal
	//  ========= ========
	//  Header A  true
	//  Header B  false
	//  Header C  false
	//  ========= ========
	//
	// The generateHash process ends if policy "header A" generates a hash, as
	// it's a terminal policy.
	terminal?: bool
}

// Allows enabling and disabling upgrades on a per-route basis.
// This overrides any enabled/disabled upgrade filter chain specified in the
// HttpConnectionManager
// :ref:`upgrade_configs
// <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.upgrade_configs>`
// but does not affect any custom filter chain specified there.
#RouteAction_UpgradeConfig: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteAction_UpgradeConfig"
	// The case-insensitive name of this upgrade, e.g. "websocket".
	// For each upgrade type present in upgrade_configs, requests with
	// Upgrade: [upgrade_type] will be proxied upstream.
	upgrade_type?: string
	// Determines if upgrades are available on this route. Defaults to true.
	enabled?: bool
	// Configuration for sending data upstream as a raw data payload. This is used for
	// CONNECT requests, when forwarding CONNECT payload as raw TCP.
	// Note that CONNECT support is currently considered alpha in Envoy.
	// [#comment: TODO(htuch): Replace the above comment with an alpha tag.]
	connect_config?: #RouteAction_UpgradeConfig_ConnectConfig
}

#RouteAction_MaxStreamDuration: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteAction_MaxStreamDuration"
	// Specifies the maximum duration allowed for streams on the route. If not specified, the value
	// from the :ref:`max_stream_duration
	// <envoy_v3_api_field_config.core.v3.HttpProtocolOptions.max_stream_duration>` field in
	// :ref:`HttpConnectionManager.common_http_protocol_options
	// <envoy_v3_api_field_extensions.filters.network.http_connection_manager.v3.HttpConnectionManager.common_http_protocol_options>`
	// is used. If this field is set explicitly to zero, any
	// HttpConnectionManager max_stream_duration timeout will be disabled for
	// this route.
	max_stream_duration?: string
	// If present, and the request contains a `grpc-timeout header
	// <https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-HTTP2.md>`_, use that value as the
	// ``max_stream_duration``, but limit the applied timeout to the maximum value specified here.
	// If set to 0, the ``grpc-timeout`` header is used without modification.
	grpc_timeout_header_max?: string
	// If present, Envoy will adjust the timeout provided by the ``grpc-timeout`` header by
	// subtracting the provided duration from the header. This is useful for allowing Envoy to set
	// its global timeout to be less than that of the deadline imposed by the calling client, which
	// makes it more likely that Envoy will handle the timeout instead of having the call canceled
	// by the client. If, after applying the offset, the resulting timeout is zero or negative,
	// the stream will timeout immediately.
	grpc_timeout_header_offset?: string
}

#RouteAction_HashPolicy_Header: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteAction_HashPolicy_Header"
	// The name of the request header that will be used to obtain the hash
	// key. If the request header is not present, no hash will be produced.
	header_name?: string
	// If specified, the request header value will be rewritten and used
	// to produce the hash key.
	regex_rewrite?: v32.#RegexMatchAndSubstitute
}

// Envoy supports two types of cookie affinity:
//
// 1. Passive. Envoy takes a cookie that's present in the cookies header and
//    hashes on its value.
//
// 2. Generated. Envoy generates and sets a cookie with an expiration (TTL)
//    on the first request from the client in its response to the client,
//    based on the endpoint the request gets sent to. The client then
//    presents this on the next and all subsequent requests. The hash of
//    this is sufficient to ensure these requests get sent to the same
//    endpoint. The cookie is generated by hashing the source and
//    destination ports and addresses so that multiple independent HTTP2
//    streams on the same connection will independently receive the same
//    cookie, even if they arrive at the Envoy simultaneously.
#RouteAction_HashPolicy_Cookie: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteAction_HashPolicy_Cookie"
	// The name of the cookie that will be used to obtain the hash key. If the
	// cookie is not present and ttl below is not set, no hash will be
	// produced.
	name?: string
	// If specified, a cookie with the TTL will be generated if the cookie is
	// not present. If the TTL is present and zero, the generated cookie will
	// be a session cookie.
	ttl?: string
	// The name of the path for the cookie. If no path is specified here, no path
	// will be set for the cookie.
	path?: string
}

#RouteAction_HashPolicy_ConnectionProperties: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteAction_HashPolicy_ConnectionProperties"
	// Hash on source IP address.
	source_ip?: bool
}

#RouteAction_HashPolicy_QueryParameter: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteAction_HashPolicy_QueryParameter"
	// The name of the URL query parameter that will be used to obtain the hash
	// key. If the parameter is not present, no hash will be produced. Query
	// parameter names are case-sensitive.
	name?: string
}

#RouteAction_HashPolicy_FilterState: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteAction_HashPolicy_FilterState"
	// The name of the Object in the per-request filterState, which is an
	// Envoy::Hashable object. If there is no data associated with the key,
	// or the stored object is not Envoy::Hashable, no hash will be produced.
	key?: string
}

// Configuration for sending data upstream as a raw data payload. This is used for
// CONNECT or POST requests, when forwarding request payload as raw TCP.
#RouteAction_UpgradeConfig_ConnectConfig: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RouteAction_UpgradeConfig_ConnectConfig"
	// If present, the proxy protocol header will be prepended to the CONNECT payload sent upstream.
	proxy_protocol_config?: v31.#ProxyProtocolConfig
	// If set, the route will also allow forwarding POST payload as raw TCP.
	allow_post?: bool
}

#RetryPolicy_RetryPriority: {
	"@type":       "type.googleapis.com/envoy.config.route.v3.RetryPolicy_RetryPriority"
	name?:         string
	typed_config?: _
}

#RetryPolicy_RetryHostPredicate: {
	"@type":       "type.googleapis.com/envoy.config.route.v3.RetryPolicy_RetryHostPredicate"
	name?:         string
	typed_config?: _
}

#RetryPolicy_RetryBackOff: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RetryPolicy_RetryBackOff"
	// Specifies the base interval between retries. This parameter is required and must be greater
	// than zero. Values less than 1 ms are rounded up to 1 ms.
	// See :ref:`config_http_filters_router_x-envoy-max-retries` for a discussion of Envoy's
	// back-off algorithm.
	base_interval?: string
	// Specifies the maximum interval between retries. This parameter is optional, but must be
	// greater than or equal to the ``base_interval`` if set. The default is 10 times the
	// ``base_interval``. See :ref:`config_http_filters_router_x-envoy-max-retries` for a discussion
	// of Envoy's back-off algorithm.
	max_interval?: string
}

#RetryPolicy_ResetHeader: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RetryPolicy_ResetHeader"
	// The name of the reset header.
	//
	// .. note::
	//
	//   If the header appears multiple times only the first value is used.
	name?: string
	// The format of the reset header.
	format?: #RetryPolicy_ResetHeaderFormat
}

// A retry back-off strategy that applies when the upstream server rate limits
// the request.
//
// Given this configuration:
//
// .. code-block:: yaml
//
//   rate_limited_retry_back_off:
//     reset_headers:
//     - name: Retry-After
//       format: SECONDS
//     - name: X-RateLimit-Reset
//       format: UNIX_TIMESTAMP
//     max_interval: "300s"
//
// The following algorithm will apply:
//
//  1. If the response contains the header ``Retry-After`` its value must be on
//     the form ``120`` (an integer that represents the number of seconds to
//     wait before retrying). If so, this value is used as the back-off interval.
//  2. Otherwise, if the response contains the header ``X-RateLimit-Reset`` its
//     value must be on the form ``1595320702`` (an integer that represents the
//     point in time at which to retry, as a Unix timestamp in seconds). If so,
//     the current time is subtracted from this value and the result is used as
//     the back-off interval.
//  3. Otherwise, Envoy will use the default
//     :ref:`exponential back-off <envoy_v3_api_field_config.route.v3.RetryPolicy.retry_back_off>`
//     strategy.
//
// No matter which format is used, if the resulting back-off interval exceeds
// ``max_interval`` it is discarded and the next header in ``reset_headers``
// is tried. If a request timeout is configured for the route it will further
// limit how long the request will be allowed to run.
//
// To prevent many clients retrying at the same point in time jitter is added
// to the back-off interval, so the resulting interval is decided by taking:
// ``random(interval, interval * 1.5)``.
//
// .. attention::
//
//   Configuring ``rate_limited_retry_back_off`` will not by itself cause a request
//   to be retried. You will still need to configure the right retry policy to match
//   the responses from the upstream server.
#RetryPolicy_RateLimitedRetryBackOff: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RetryPolicy_RateLimitedRetryBackOff"
	// Specifies the reset headers (like ``Retry-After`` or ``X-RateLimit-Reset``)
	// to match against the response. Headers are tried in order, and matched case
	// insensitive. The first header to be parsed successfully is used. If no headers
	// match the default exponential back-off is used instead.
	reset_headers?: [...#RetryPolicy_ResetHeader]
	// Specifies the maximum back off interval that Envoy will allow. If a reset
	// header contains an interval longer than this then it will be discarded and
	// the next header will be tried. Defaults to 300 seconds.
	max_interval?: string
}

// [#next-free-field: 11]
#RateLimit_Action: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Action"
	// Rate limit on source cluster.
	source_cluster?: #RateLimit_Action_SourceCluster
	// Rate limit on destination cluster.
	destination_cluster?: #RateLimit_Action_DestinationCluster
	// Rate limit on request headers.
	request_headers?: #RateLimit_Action_RequestHeaders
	// Rate limit on remote address.
	remote_address?: #RateLimit_Action_RemoteAddress
	// Rate limit on a generic key.
	generic_key?: #RateLimit_Action_GenericKey
	// Rate limit on the existence of request headers.
	header_value_match?: #RateLimit_Action_HeaderValueMatch
	// Rate limit on dynamic metadata.
	//
	// .. attention::
	//   This field has been deprecated in favor of the :ref:`metadata <envoy_v3_api_field_config.route.v3.RateLimit.Action.metadata>` field
	//
	// Deprecated: Do not use.
	dynamic_metadata?: #RateLimit_Action_DynamicMetaData
	// Rate limit on metadata.
	metadata?: #RateLimit_Action_MetaData
	// Rate limit descriptor extension. See the rate limit descriptor extensions documentation.
	//
	// :ref:`HTTP matching input functions <arch_overview_matching_api>` are
	// permitted as descriptor extensions. The input functions are only
	// looked up if there is no rate limit descriptor extension matching
	// the type URL.
	//
	// [#extension-category: envoy.rate_limit_descriptors]
	extension?: v31.#TypedExtensionConfig
	// Rate limit on masked remote address.
	masked_remote_address?: #RateLimit_Action_MaskedRemoteAddress
}

#RateLimit_Override: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Override"
	// Limit override from dynamic metadata.
	dynamic_metadata?: #RateLimit_Override_DynamicMetadata
}

// The following descriptor entry is appended to the descriptor:
//
// .. code-block:: cpp
//
//   ("source_cluster", "<local service cluster>")
//
// <local service cluster> is derived from the :option:`--service-cluster` option.
#RateLimit_Action_SourceCluster: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Action_SourceCluster"
}

// The following descriptor entry is appended to the descriptor:
//
// .. code-block:: cpp
//
//   ("destination_cluster", "<routed target cluster>")
//
// Once a request matches against a route table rule, a routed cluster is determined by one of
// the following :ref:`route table configuration <envoy_v3_api_msg_config.route.v3.RouteConfiguration>`
// settings:
//
// * :ref:`cluster <envoy_v3_api_field_config.route.v3.RouteAction.cluster>` indicates the upstream cluster
//   to route to.
// * :ref:`weighted_clusters <envoy_v3_api_field_config.route.v3.RouteAction.weighted_clusters>`
//   chooses a cluster randomly from a set of clusters with attributed weight.
// * :ref:`cluster_header <envoy_v3_api_field_config.route.v3.RouteAction.cluster_header>` indicates which
//   header in the request contains the target cluster.
#RateLimit_Action_DestinationCluster: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Action_DestinationCluster"
}

// The following descriptor entry is appended when a header contains a key that matches the
// ``header_name``:
//
// .. code-block:: cpp
//
//   ("<descriptor_key>", "<header_value_queried_from_header>")
#RateLimit_Action_RequestHeaders: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Action_RequestHeaders"
	// The header name to be queried from the request headers. The header’s
	// value is used to populate the value of the descriptor entry for the
	// descriptor_key.
	header_name?: string
	// The key to use in the descriptor entry.
	descriptor_key?: string
	// If set to true, Envoy skips the descriptor while calling rate limiting service
	// when header is not present in the request. By default it skips calling the
	// rate limiting service if this header is not present in the request.
	skip_if_absent?: bool
}

// The following descriptor entry is appended to the descriptor and is populated using the
// trusted address from :ref:`x-forwarded-for <config_http_conn_man_headers_x-forwarded-for>`:
//
// .. code-block:: cpp
//
//   ("remote_address", "<trusted address from x-forwarded-for>")
#RateLimit_Action_RemoteAddress: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Action_RemoteAddress"
}

// The following descriptor entry is appended to the descriptor and is populated using the
// masked address from :ref:`x-forwarded-for <config_http_conn_man_headers_x-forwarded-for>`:
//
// .. code-block:: cpp
//
//   ("masked_remote_address", "<masked address from x-forwarded-for>")
#RateLimit_Action_MaskedRemoteAddress: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Action_MaskedRemoteAddress"
	// Length of prefix mask len for IPv4 (e.g. 0, 32).
	// Defaults to 32 when unset.
	// For example, trusted address from x-forwarded-for is ``192.168.1.1``,
	// the descriptor entry is ("masked_remote_address", "192.168.1.1/32");
	// if mask len is 24, the descriptor entry is ("masked_remote_address", "192.168.1.0/24").
	v4_prefix_mask_len?: uint32
	// Length of prefix mask len for IPv6 (e.g. 0, 128).
	// Defaults to 128 when unset.
	// For example, trusted address from x-forwarded-for is ``2001:abcd:ef01:2345:6789:abcd:ef01:234``,
	// the descriptor entry is ("masked_remote_address", "2001:abcd:ef01:2345:6789:abcd:ef01:234/128");
	// if mask len is 64, the descriptor entry is ("masked_remote_address", "2001:abcd:ef01:2345::/64").
	v6_prefix_mask_len?: uint32
}

// The following descriptor entry is appended to the descriptor:
//
// .. code-block:: cpp
//
//   ("generic_key", "<descriptor_value>")
#RateLimit_Action_GenericKey: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Action_GenericKey"
	// The value to use in the descriptor entry.
	descriptor_value?: string
	// An optional key to use in the descriptor entry. If not set it defaults
	// to 'generic_key' as the descriptor key.
	descriptor_key?: string
}

// The following descriptor entry is appended to the descriptor:
//
// .. code-block:: cpp
//
//   ("header_match", "<descriptor_value>")
#RateLimit_Action_HeaderValueMatch: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Action_HeaderValueMatch"
	// The key to use in the descriptor entry. Defaults to ``header_match``.
	descriptor_key?: string
	// The value to use in the descriptor entry.
	descriptor_value?: string
	// If set to true, the action will append a descriptor entry when the
	// request matches the headers. If set to false, the action will append a
	// descriptor entry when the request does not match the headers. The
	// default value is true.
	expect_match?: bool
	// Specifies a set of headers that the rate limit action should match
	// on. The action will check the request’s headers against all the
	// specified headers in the config. A match will happen if all the
	// headers in the config are present in the request with the same values
	// (or based on presence if the value field is not in the config).
	headers?: [...#HeaderMatcher]
}

// The following descriptor entry is appended when the
// :ref:`dynamic metadata <well_known_dynamic_metadata>` contains a key value:
//
// .. code-block:: cpp
//
//   ("<descriptor_key>", "<value_queried_from_dynamic_metadata>")
//
// .. attention::
//   This action has been deprecated in favor of the :ref:`metadata <envoy_v3_api_msg_config.route.v3.RateLimit.Action.MetaData>` action
#RateLimit_Action_DynamicMetaData: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Action_DynamicMetaData"
	// The key to use in the descriptor entry.
	descriptor_key?: string
	// Metadata struct that defines the key and path to retrieve the string value. A match will
	// only happen if the value in the dynamic metadata is of type string.
	metadata_key?: v35.#MetadataKey
	// An optional value to use if ``metadata_key`` is empty. If not set and
	// no value is present under the metadata_key then no descriptor is generated.
	default_value?: string
}

// The following descriptor entry is appended when the metadata contains a key value:
//
// .. code-block:: cpp
//
//   ("<descriptor_key>", "<value_queried_from_metadata>")
#RateLimit_Action_MetaData: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Action_MetaData"
	// The key to use in the descriptor entry.
	descriptor_key?: string
	// Metadata struct that defines the key and path to retrieve the string value. A match will
	// only happen if the value in the metadata is of type string.
	metadata_key?: v35.#MetadataKey
	// An optional value to use if ``metadata_key`` is empty. If not set and
	// no value is present under the metadata_key then no descriptor is generated.
	default_value?: string
	// Source of metadata
	source?: #RateLimit_Action_MetaData_Source
}

// Fetches the override from the dynamic metadata.
#RateLimit_Override_DynamicMetadata: {
	"@type": "type.googleapis.com/envoy.config.route.v3.RateLimit_Override_DynamicMetadata"
	// Metadata struct that defines the key and path to retrieve the struct value.
	// The value must be a struct containing an integer "requests_per_unit" property
	// and a "unit" property with a value parseable to :ref:`RateLimitUnit
	// enum <envoy_v3_api_enum_type.v3.RateLimitUnit>`
	metadata_key?: v35.#MetadataKey
}
