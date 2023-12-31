package v2

#Redis: {
	"@type": "type.googleapis.com/envoy.config.health_checker.redis.v2.Redis"
	// If set, optionally perform ``EXISTS <key>`` instead of ``PING``. A return value
	// from Redis of 0 (does not exist) is considered a passing healthcheck. A return value other
	// than 0 is considered a failure. This allows the user to mark a Redis instance for maintenance
	// by setting the specified key to any value and waiting for traffic to drain.
	key?: string
}
