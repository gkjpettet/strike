/**
 * TOML syntax highlighting.
 *
 * @author Garry Pettet
 * 2nd March 2024.
 */
 Rainbow.extend('toml', [		 
	{
		 name: "boolean",
		 pattern: /false|true/gm
	},
	 
	{
		name: "comment",
		pattern: /#.*$/gm
	},
	
	{
		name: "date",
		pattern: /(\d{4}-\d{2}-\d{2}T?\s*\d{2}:\d{2}:\d{2}([-+]\d{2}:\d{2})?)/gm
	},
	
	{
		name: "number",
		pattern: /\b[0-9]+(\.[0-9]+)?([eE]([+-])?[0-9]+)?\b/g
	},
	
	{
		name: "key",
		pattern: /\b"?([-a-zA-Z_.]+)"?\b\s*(?==)/gm
	},
	
	{
		name: "string",
		matches: [
			{
				matches: {
					1: "unicode8",
					2: "unicode4"
				},
				pattern: /(\\U[\da-fA-F]{8})|(\\u[\da-fA-F]{4})/g
			},
			{
				matches: {
					1: "escape"
				},
				pattern: /(\\b|\\t|\\n|\\f|\\r|\\"|\\\\)/g
			}
		],
		pattern: /(".*")/g
	},
	
	{
		name: "table",
		pattern: /\[+[-a-zA-Z_.]*\]+/gm
	}
]);