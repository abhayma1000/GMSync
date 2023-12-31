package structpb

// `NullValue` is a singleton enumeration to represent the null value for the
// `Value` type union.
//
//  The JSON representation for `NullValue` is JSON `null`.
#NullValue: "NULL_VALUE"

NullValue_NULL_VALUE: "NULL_VALUE"

// `Struct` represents a structured data value, consisting of fields
// which map to dynamically typed values. In some languages, `Struct`
// might be supported by a native representation. For example, in
// scripting languages like JS a struct is represented as an
// object. The details of that representation are described together
// with the proto support for the language.
//
// The JSON representation for `Struct` is JSON object.
#Struct: {
	"@type": "type.googleapis.com/google.golang.org.protobuf.types.known.structpb.Struct"
	// Unordered map of dynamically typed values.
	fields?: [string]: #Value
}

// `Value` represents a dynamically typed value which can be either
// null, a number, a string, a boolean, a recursive struct value, or a
// list of values. A producer of value is expected to set one of that
// variants, absence of any variant indicates an error.
//
// The JSON representation for `Value` is JSON value.
#Value: {
	"@type": "type.googleapis.com/google.golang.org.protobuf.types.known.structpb.Value"
	// Represents a null value.
	null_value?: #NullValue
	// Represents a double value.
	number_value?: float64
	// Represents a string value.
	string_value?: string
	// Represents a boolean value.
	bool_value?: bool
	// Represents a structured value.
	struct_value?: #Struct
	// Represents a repeated `Value`.
	list_value?: #ListValue
}

// `ListValue` is a wrapper around a repeated field of values.
//
// The JSON representation for `ListValue` is JSON array.
#ListValue: {
	"@type": "type.googleapis.com/google.golang.org.protobuf.types.known.structpb.ListValue"
	// Repeated field of dynamically typed values.
	values?: [...#Value]
}
