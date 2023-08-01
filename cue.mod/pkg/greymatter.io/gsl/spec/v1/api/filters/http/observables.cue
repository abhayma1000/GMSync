package http

#ObservablesConfig: {
	// Whether to emit response (or otherwise just request)
	emitFullResponse?: bool
	// The topic name to embed in the event.
	topic?: string
	// File to store event to use (if not using Kafka)
	fileName?: string
	// Log level to use ("warn", "debug" or "info")
	logLevel?: string
	// Algorithm used to encrypt
	encryptionAlgorithm?: string
	// Key to encrypt event
	encryptionKey?:   string
	encryptionKeyID?: uint32

	// NATS Configuration
    streamName?: string // must be all caps
    retentionPolicy?: string // limits, workqueue, or interest
    servers?: [string]
    maxMessages?: int32
    duplicateWindows?: int32
}

#ObservablesRouteConfig: {
	emitFullResponse?: bool
}
