package v2

import (
	_struct "envoyproxy.io/envoy-cue/spec/deps/golang/protobuf/ptypes/struct"
	core "envoyproxy.io/envoy-cue/spec/api/v2/core"
	matcher "envoyproxy.io/envoy-cue/spec/type/matcher"
)

// Configuration for pluggable stats sinks.
#StatsSink: {
	"@type": "type.googleapis.com/envoy.config.metrics.v2.StatsSink"
	// The name of the stats sink to instantiate. The name must match a supported
	// stats sink. The built-in stats sinks are:
	//
	// * :ref:`envoy.stat_sinks.statsd <envoy_api_msg_config.metrics.v2.StatsdSink>`
	// * :ref:`envoy.stat_sinks.dog_statsd <envoy_api_msg_config.metrics.v2.DogStatsdSink>`
	// * :ref:`envoy.stat_sinks.metrics_service <envoy_api_msg_config.metrics.v2.MetricsServiceConfig>`
	// * :ref:`envoy.stat_sinks.hystrix <envoy_api_msg_config.metrics.v2.HystrixSink>`
	//
	// Sinks optionally support tagged/multiple dimensional metrics.
	name?: string
	// Deprecated: Do not use.
	config?:       _struct.#Struct
	typed_config?: _
}

// Statistics configuration such as tagging.
#StatsConfig: {
	"@type": "type.googleapis.com/envoy.config.metrics.v2.StatsConfig"
	// Each stat name is iteratively processed through these tag specifiers.
	// When a tag is matched, the first capture group is removed from the name so
	// later :ref:`TagSpecifiers <envoy_api_msg_config.metrics.v2.TagSpecifier>` cannot match that
	// same portion of the match.
	stats_tags?: [...#TagSpecifier]
	// Use all default tag regexes specified in Envoy. These can be combined with
	// custom tags specified in :ref:`stats_tags
	// <envoy_api_field_config.metrics.v2.StatsConfig.stats_tags>`. They will be processed before
	// the custom tags.
	//
	// .. note::
	//
	//   If any default tags are specified twice, the config will be considered
	//   invalid.
	//
	// See :repo:`well_known_names.h <source/common/config/well_known_names.h>` for a list of the
	// default tags in Envoy.
	//
	// If not provided, the value is assumed to be true.
	use_all_default_tags?: bool
	// Inclusion/exclusion matcher for stat name creation. If not provided, all stats are instantiated
	// as normal. Preventing the instantiation of certain families of stats can improve memory
	// performance for Envoys running especially large configs.
	//
	// .. warning::
	//   Excluding stats may affect Envoy's behavior in undocumented ways. See
	//   `issue #8771 <https://github.com/envoyproxy/envoy/issues/8771>`_ for more information.
	//   If any unexpected behavior changes are observed, please open a new issue immediately.
	stats_matcher?: #StatsMatcher
}

// Configuration for disabling stat instantiation.
#StatsMatcher: {
	"@type": "type.googleapis.com/envoy.config.metrics.v2.StatsMatcher"
	// If `reject_all` is true, then all stats are disabled. If `reject_all` is false, then all
	// stats are enabled.
	reject_all?: bool
	// Exclusive match. All stats are enabled except for those matching one of the supplied
	// StringMatcher protos.
	exclusion_list?: matcher.#ListStringMatcher
	// Inclusive match. No stats are enabled except for those matching one of the supplied
	// StringMatcher protos.
	inclusion_list?: matcher.#ListStringMatcher
}

// Designates a tag name and value pair. The value may be either a fixed value
// or a regex providing the value via capture groups. The specified tag will be
// unconditionally set if a fixed value, otherwise it will only be set if one
// or more capture groups in the regex match.
#TagSpecifier: {
	"@type": "type.googleapis.com/envoy.config.metrics.v2.TagSpecifier"
	// Attaches an identifier to the tag values to identify the tag being in the
	// sink. Envoy has a set of default names and regexes to extract dynamic
	// portions of existing stats, which can be found in :repo:`well_known_names.h
	// <source/common/config/well_known_names.h>` in the Envoy repository. If a :ref:`tag_name
	// <envoy_api_field_config.metrics.v2.TagSpecifier.tag_name>` is provided in the config and
	// neither :ref:`regex <envoy_api_field_config.metrics.v2.TagSpecifier.regex>` or
	// :ref:`fixed_value <envoy_api_field_config.metrics.v2.TagSpecifier.fixed_value>` were specified,
	// Envoy will attempt to find that name in its set of defaults and use the accompanying regex.
	//
	// .. note::
	//
	//   It is invalid to specify the same tag name twice in a config.
	tag_name?: string
	// Designates a tag to strip from the tag extracted name and provide as a named
	// tag value for all statistics. This will only occur if any part of the name
	// matches the regex provided with one or more capture groups.
	//
	// The first capture group identifies the portion of the name to remove. The
	// second capture group (which will normally be nested inside the first) will
	// designate the value of the tag for the statistic. If no second capture
	// group is provided, the first will also be used to set the value of the tag.
	// All other capture groups will be ignored.
	//
	// Example 1. a stat name ``cluster.foo_cluster.upstream_rq_timeout`` and
	// one tag specifier:
	//
	// .. code-block:: json
	//
	//   {
	//     "tag_name": "envoy.cluster_name",
	//     "regex": "^cluster\\.((.+?)\\.)"
	//   }
	//
	// Note that the regex will remove ``foo_cluster.`` making the tag extracted
	// name ``cluster.upstream_rq_timeout`` and the tag value for
	// ``envoy.cluster_name`` will be ``foo_cluster`` (note: there will be no
	// ``.`` character because of the second capture group).
	//
	// Example 2. a stat name
	// ``http.connection_manager_1.user_agent.ios.downstream_cx_total`` and two
	// tag specifiers:
	//
	// .. code-block:: json
	//
	//   [
	//     {
	//       "tag_name": "envoy.http_user_agent",
	//       "regex": "^http(?=\\.).*?\\.user_agent\\.((.+?)\\.)\\w+?$"
	//     },
	//     {
	//       "tag_name": "envoy.http_conn_manager_prefix",
	//       "regex": "^http\\.((.*?)\\.)"
	//     }
	//   ]
	//
	// The two regexes of the specifiers will be processed in the definition order.
	//
	// The first regex will remove ``ios.``, leaving the tag extracted name
	// ``http.connection_manager_1.user_agent.downstream_cx_total``. The tag
	// ``envoy.http_user_agent`` will be added with tag value ``ios``.
	//
	// The second regex will remove ``connection_manager_1.`` from the tag
	// extracted name produced by the first regex
	// ``http.connection_manager_1.user_agent.downstream_cx_total``, leaving
	// ``http.user_agent.downstream_cx_total`` as the tag extracted name. The tag
	// ``envoy.http_conn_manager_prefix`` will be added with the tag value
	// ``connection_manager_1``.
	regex?: string
	// Specifies a fixed tag value for the ``tag_name``.
	fixed_value?: string
}

// Stats configuration proto schema for built-in *envoy.stat_sinks.statsd* sink. This sink does not support
// tagged metrics.
// [#extension: envoy.stat_sinks.statsd]
#StatsdSink: {
	"@type": "type.googleapis.com/envoy.config.metrics.v2.StatsdSink"
	// The UDP address of a running `statsd <https://github.com/etsy/statsd>`_
	// compliant listener. If specified, statistics will be flushed to this
	// address.
	address?: core.#Address
	// The name of a cluster that is running a TCP `statsd
	// <https://github.com/etsy/statsd>`_ compliant listener. If specified,
	// Envoy will connect to this cluster to flush statistics.
	tcp_cluster_name?: string
	// Optional custom prefix for StatsdSink. If
	// specified, this will override the default prefix.
	// For example:
	//
	// .. code-block:: json
	//
	//   {
	//     "prefix" : "envoy-prod"
	//   }
	//
	// will change emitted stats to
	//
	// .. code-block:: cpp
	//
	//   envoy-prod.test_counter:1|c
	//   envoy-prod.test_timer:5|ms
	//
	// Note that the default prefix, "envoy", will be used if a prefix is not
	// specified.
	//
	// Stats with default prefix:
	//
	// .. code-block:: cpp
	//
	//   envoy.test_counter:1|c
	//   envoy.test_timer:5|ms
	prefix?: string
}

// Stats configuration proto schema for built-in *envoy.stat_sinks.dog_statsd* sink.
// The sink emits stats with `DogStatsD <https://docs.datadoghq.com/guides/dogstatsd/>`_
// compatible tags. Tags are configurable via :ref:`StatsConfig
// <envoy_api_msg_config.metrics.v2.StatsConfig>`.
// [#extension: envoy.stat_sinks.dog_statsd]
#DogStatsdSink: {
	"@type": "type.googleapis.com/envoy.config.metrics.v2.DogStatsdSink"
	// The UDP address of a running DogStatsD compliant listener. If specified,
	// statistics will be flushed to this address.
	address?: core.#Address
	// Optional custom metric name prefix. See :ref:`StatsdSink's prefix field
	// <envoy_api_field_config.metrics.v2.StatsdSink.prefix>` for more details.
	prefix?: string
}

// Stats configuration proto schema for built-in *envoy.stat_sinks.hystrix* sink.
// The sink emits stats in `text/event-stream
// <https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events>`_
// formatted stream for use by `Hystrix dashboard
// <https://github.com/Netflix-Skunkworks/hystrix-dashboard/wiki>`_.
//
// Note that only a single HystrixSink should be configured.
//
// Streaming is started through an admin endpoint :http:get:`/hystrix_event_stream`.
// [#extension: envoy.stat_sinks.hystrix]
#HystrixSink: {
	"@type": "type.googleapis.com/envoy.config.metrics.v2.HystrixSink"
	// The number of buckets the rolling statistical window is divided into.
	//
	// Each time the sink is flushed, all relevant Envoy statistics are sampled and
	// added to the rolling window (removing the oldest samples in the window
	// in the process). The sink then outputs the aggregate statistics across the
	// current rolling window to the event stream(s).
	//
	// rolling_window(ms) = stats_flush_interval(ms) * num_of_buckets
	//
	// More detailed explanation can be found in `Hystrix wiki
	// <https://github.com/Netflix/Hystrix/wiki/Metrics-and-Monitoring#hystrixrollingnumber>`_.
	num_buckets?: int64
}
