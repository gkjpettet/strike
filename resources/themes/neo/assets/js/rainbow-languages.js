Rainbow.extend('html', [
	{
		name: 'source.php.embedded',
		matches: {
			1: 'variable.language.php-tag',
			2: {
				language: 'php'
			},
			3: 'variable.language.php-tag'
		},
		pattern: /(&lt;\?php|&lt;\?=?(?!xml))([\s\S]*?)(\?&gt;)/gm
	},
	{
		name: 'source.css.embedded',
		matches: {
			1: {
				matches: {
					1: 'support.tag.style',
					2: [
						{
							name: 'entity.tag.style',
							pattern: /^style/g
						},
						{
							name: 'string',
							pattern: /('|")(.*?)(\1)/g
						},
						{
							name: 'entity.tag.style.attribute',
							pattern: /(\w+)/g
						}
					],
					3: 'support.tag.style'
				},
				pattern: /(&lt;\/?)(style.*?)(&gt;)/g
			},
			2: {
				language: 'css'
			},
			3: 'support.tag.style',
			4: 'entity.tag.style',
			5: 'support.tag.style'
		},
		pattern: /(&lt;style.*?&gt;)([\s\S]*?)(&lt;\/)(style)(&gt;)/gm
	},
	{
		name: 'source.js.embedded',
		matches: {
			1: {
				matches: {
					1: 'support.tag.script',
					2: [
						{
							name: 'entity.tag.script',
							pattern: /^script/g
						},

						{
							name: 'string',
							pattern: /('|")(.*?)(\1)/g
						},
						{
							name: 'entity.tag.script.attribute',
							pattern: /(\w+)/g
						}
					],
					3: 'support.tag.script'
				},
				pattern: /(&lt;\/?)(script.*?)(&gt;)/g
			},
			2: {
				language: 'javascript'
			},
			3: 'support.tag.script',
			4: 'entity.tag.script',
			5: 'support.tag.script'
		},
		pattern: /(&lt;script(?! src).*?&gt;)([\s\S]*?)(&lt;\/)(script)(&gt;)/gm
	},
	{
		name: 'comment.html',
		pattern: /&lt;\!--[\S\s]*?--&gt;/g
	},
	{
		matches: {
			1: 'support.tag.open',
			2: 'support.tag.close'
		},
		pattern: /(&lt;)|(\/?\??&gt;)/g
	},
	{
		name: 'support.tag',
		matches: {
			1: 'support.tag',
			2: 'support.tag.special',
			3: 'support.tag-name'
		},
		pattern: /(&lt;\??)(\/|\!?)(\w+)/g
	},
	{
		matches: {
			1: 'support.attribute'
		},
		pattern: /([a-z-]+)(?=\=)/gi
	},
	{
		matches: {
			1: 'support.operator',
			2: 'string.quote',
			3: 'string.value',
			4: 'string.quote'
		},
		pattern: /(=)('|")(.*?)(\2)/g
	},
	{
		matches: {
			1: 'support.operator',
			2: 'support.value'
		},
		pattern: /(=)([a-zA-Z\-0-9]*)\b/g
	},
	{
		matches: {
			1: 'support.attribute'
		},
		pattern: /\s([\w-]+)(?=\s|&gt;)(?![\s\S]*&lt;)/g
	}
]);

Rainbow.addAlias('xml', 'html');

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

 Rainbow.extend('swift', [
	{
		name: 'keyword',
		pattern: /\b(#available|#colorLiteral|#else|#elseif|#endif|#fileLiteral|#if|#imageLiteral|#keyPath|#selector|#sourceLocation|#unavailable|associatedtype|associativity|Any|as|await|break|case|catch|class|continue|convenience|default|defer|deinit|didSet|do|dynamic|else|enum|extension|fallthrough|false|fileprivate|final|for|func|get|guard|if|import|indirect|infix|init|inout|internal|in|is|lazy|left|let|mutating|nil|none|nonmutating|open|operator|optional|override|postfix|private|precedence|precedencegroup|prefix|protocol|Protocol|public|repeat|required|rethrows|return|right|self|Self|set|some|static|struct|subscript|super|switch|throws|throw|true|try|Type|typealias|unowned|var|weak|where|while|willSet)\b/g
	},
	
	{
		name: "number",
		pattern: /\b[0-9]+(\.[0-9]+)?([eE]([+-])?[0-9]+)?\b/g
	},
	
	{
		name: "comment",
		pattern: /\/\/.*$/gm
	},
	
	{
		name: "string",
		matches: [{
			matches: {
				1: "interpolation"
			},
			pattern: /(\\\(.+?\))/gi // \(code)
		}],
		pattern: /(".*?")/g
	},
	
	{
		name: "entity.identifier",
		pattern: /\b([a-z](\w|_)*)\b/g
	},
	
	{
		name: "entity.class",
		pattern: /\b([A-Z](\w|_)*)\b/g
	}
	
]);

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

 Rainbow.extend('xojo', [
	 {
		 name: "keyword.directive",
		 pattern: /#Bad|#Else|#Elseif|#Endif|#If|#Pragma|#Ta/gi
	 },
	 
	{
		name: 'keyword',
		pattern: /\b(AddHandler|AddressOf|Aggregates|And|Array|As|Assigns|Async|Attributes|Await|Break|ByRef|ByVal|Call|Case|Catch|Class|Const|Continue|CType|Declare|Delegate|Dim|Do|DownTo|Each|Else|ElseIf|End|Enum|Event|Exception|Exit|Extends|False|Finally|For|Function|Global|GoTo|Handles|If|Implements|In|Inherits|Interface|Is|IsA|Lib|Loop|Me|Mod|Module|Namespace|New|Next|Nil|Not|Object|Of|Optional|Or|ParamArray|Private|Property|Protected|Public|Raise|RaiseEvent|Redim|Rem|RemoveHandler|Return|Select|Self|Shared|Soft|Static|Step|Structure|Sub|Super|Then|To|True|Try|Until|Using|Var|WeakAddressOf|Wend|While|With|Xor)\b/gi
	},
	
	{
		name: "string",
		pattern: /(".*?")/g
	},
	
	{
		name: "comment.slash",
		pattern: /\/\/.*$/gm
	},
	
	{
		name: "comment.apostrophe",
		pattern: /\'.*$/gm
	},
	
	{
		name: "comment.rem",
		pattern: /rem .*$/gmi
	},
	
	{
		name: "number.integer",
		pattern: /\b[0-9]+([eE]([+])?[0-9]+)?\b/g
	},
	
	{
		name: "number.double",
		pattern: /\b[0-9]+\.[0-9]+([eE]([+-])?[0-9]+)?\b/g
	},
	
	{
		name: "number.hex",
		pattern: /&amp;h[\da-f]+\b/gi
	},
	
	{
		name: "number.binary",
		pattern: /&amp;b[01]+\b/gi
	},

	{
		name: "number.octal",
		pattern: /&amp;o[0-7]+\b/gi
	},
	
	{
		name: "color",
		matches: [{
			matches: {
				1: "red",
				2: "green",
				3: "blue", 
				4: "alpha"
			},
			pattern: /&amp;c([\da-f]{2})([\da-f]{2})([\da-f]{2})([\da-f]{2})?/gi
		}],
		pattern: /&amp;c[\da-f]+\b/gi
	},
	
	{
		name: 'entity.identifier',
		pattern: /\b([a-z](\w|_)*)\b/gi
	},
]);