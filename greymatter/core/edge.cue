// Edge configuration for enterprise mesh-segmentation. This is a dedicated
// edge proxy that provides north/south network traffic to services in this
// repository in the mesh. This edge would be separate from the default
// greymatter edge that is deployed via enterprise-level configuration in
// the gitops-core git repository.
package my_test_init_project

import (
	gsl "greymatter.io/gsl/spec/v1"

	"my_test_init_project.module/greymatter:globals"
)

Edge: gsl.#Edge & {
	// A context provides global information from globals.cue
	// to your service definitions.
	context: Edge.#NewContext & globals

	name:              "edge"
	display_name:      "My Test Init Project Edge"
	version:           "v1.8.1"
	description:       "Edge ingress for my-test-init-project"
	business_impact:   "high"
	owner:             "My Test Init Project"
	capability:        ""
	health_options: {
		tls: gsl.#MTLSUpstream
	}
	ingress: {
		// Edge -> HTTP ingress to your container
		(name): {
			gsl.#HTTPListener
			gsl.#MTLSListener
			port: 10809
			filters: [
				gsl.#InheadersFilter
            ]	
		}
	}
}

exports: "edge-my-test-init-project": Edge
