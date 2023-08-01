package globals

import (
	gsl "greymatter.io/gsl/spec/v1"
)

globals: gsl.#DefaultContext & {
	edge_host: ""
	namespace: "my-test-init-project"
	
	// Please contact your mesh administrators as to what
	// values must be set per your mesh deployment.
	mesh: {
		name: string
	}
}
