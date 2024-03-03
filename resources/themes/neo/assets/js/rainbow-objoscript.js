/**
 * ObjoScript syntax highlighting.
 *
 * @author Garry Pettet
 * 20 Feb 2024.
 */
 Rainbow.extend('objoscript', [
	{
		name: 'keyword',
		pattern: /\b(and|assert|as|breakpoint|class|continue|constructor|else|exit|export|false|foreach|foreign|for|function|if|import|in|is|nothing|not|or|return|static|super|then|this|true|var|while|xor)\b/g
	},
	
	{
		name: 'comment',
		pattern: /#.*$/gm
	},
	
	{
		name: "string",
		matches: [{
			matches: {
				1: "unicode8",
				2: "unicode4"
			},
			pattern: /(\\U[\da-fA-F]{8})|(\\u[\da-fA-F]{4})/g
		}],
		pattern: /(".*?")/g
	},
	  
	{
		name: "number",
		pattern: /\b[0-9]+(\.[0-9]+)?([eE]([+-])?[0-9]+)?\b/g
	},
	
	{
		name: "number.hex",
		pattern: /\b0x[\da-fA-F]+\b/g
	},
	
	{
		name: "number.binary",
		pattern: /\b0b[01]+\b/g
	},
	
	{
		name: "operator",
		pattern: /[-&.,=/><%|+*]/g
	},
	
	{
		name: 'entity.identifier',
		pattern: /\b([a-z](\w|_)*)\b/g
	},
	
	{
		name: "entity.field",
		pattern: /\b_[a-zA-Z][a-zA-Z_]*\b/g
	},
	
	{
		name: "entity.staticField",
		pattern: /\b__[a-zA-Z][a-zA-Z_]*\b/g
	},
	
	{
		name: 'entity.class',
		pattern: /\b([A-Z]\w*)\b/g
	},
]);