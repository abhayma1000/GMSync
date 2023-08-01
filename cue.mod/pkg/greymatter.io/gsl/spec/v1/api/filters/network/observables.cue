package network

#ObservablesTCPConfig: {
	// Whether to emit response (or otherwise just request)
	emitFullResponse?: bool
	topic?: string
	// Kafka topic to publish to.
	eventTopic?: string
	// File to store event to use (if not using Kafka)
	fileName?: string
	// Log level to use ("warn", "debug" or "info")
	logLevel?: string
	// Algorithm used to encrypt
	encryptionAlgorithm?: string
	// Key to encrypt event
	encryptionKey?:   string
	encryptionKeyID?: uint32
	// Decode
	decodeToProtocol?: string
	decodeSkipFail?:   bool

	// NATS Configuration
    streamName?: string // must be all caps
    retentionPolicy?: string // limits, workqueue, or interest
    servers?: [string]
    maxMessages?: int32
    duplicateWindows?: int32
}
