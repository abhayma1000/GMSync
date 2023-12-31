package v3

// This extension allows for the original downstream remote IP to be detected
// by reading the :ref:`config_http_conn_man_headers_x-forwarded-for` header.
//
// [#extension: envoy.http.original_ip_detection.xff]
#XffConfig: {
	"@type": "type.googleapis.com/envoy.extensions.http.original_ip_detection.xff.v3.XffConfig"
	// The number of additional ingress proxy hops from the right side of the
	// :ref:`config_http_conn_man_headers_x-forwarded-for` HTTP header to trust when
	// determining the origin client's IP address. The default is zero if this option
	// is not specified. See the documentation for
	// :ref:`config_http_conn_man_headers_x-forwarded-for` for more information.
	xff_num_trusted_hops?: uint32
}
