/**
 * Swift syntax highlighting.
 *
 * @author Garry Pettet
 * 22 Feb 2024.
 */
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
