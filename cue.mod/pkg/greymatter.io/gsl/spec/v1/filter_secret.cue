package v1

#FilterSecret: {
	filter: string
	path:   string
	type:   string
	(#KubernetesSecret | #PlaintextSecret | #VaultSecret)
}

#KubernetesSecret: {
	type:      "kubernetes"
	filter:    string
	path:      string

	namespace: string
	name:      string
	key:      string
}

#VaultSecret: {
	type:   "vault"
	filter: string
	path:   string

	path: string
	mountPath: string
	key: string
	version: uint & >1 | *1
}

#PlaintextSecret: {
	type:   "plaintext"
	filter: string
	path:   string

	secret: string
}
