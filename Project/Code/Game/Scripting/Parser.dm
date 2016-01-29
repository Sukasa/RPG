/*

	Script parser.  Uses the lexer to build an Abstract Syntax Tree out of a script, so that it can be interpreted later.  (Or compiled down, whatever).
	Really messy because it has to "bubble up" errors.  If Lummox/Tom ever get around to implementing exceptions this code would be so much better.

	// TODO I'm running 508 so I need to start cleaning this up

*/

/Parser
	var
		Lexer/Tokens


		const
			TrinaryStart = "?"
			TrinaryMid = ":"

			BeginStatementBlock = "{"
			EndStatementBlock = "}"

			BeginParenthesis = "("
			EndParenthesis = ")"

			BeginIndexer = "\["
			EndIndexer = "]"

			EndStatement = ";"

			Numeric = "0123456789."
			StringCap = "\""

			ArgumentSeparator = ","

			Newline = "\n"

			ParameterMarker = "."

		list
			Binary6 = list("*", "/", "%")
			Binary5 = list("+", "-")
			Binary4 = list(">>", "<<")
			Binary3 = list("|", "&", "^")
			Binary2 = list("||", "&&")
			Binary1 = list("==", "!=", "<", "<=", ">=", ">")
			Binary0 = list("=", "+=", "-=", "*=", "/=", "<<=", ">>=", "^=", "|=", "&=", "%=")

			VariableStarts = list("$", "%")
			Unary = list("~", "!", "-")

			FollowsBlock = list(null, "}")

			// Compound lists
			BinaryAll
			Binaries

			// Exported Functions
			Functions = list( )

			// Exported Constants
			Constants = list( )

	New()
		BinaryAll = Binary6 | Binary5 | Binary4 | Binary3 | Binary2 | Binary1 | Binary0
		Binaries = list(Binary1, Binary2, Binary3, Binary4, Binary5, Binary6)

	// ----------------------------

	proc/ParseScript(var/ScriptName)
		try
			Tokens = new/Lexer(new/StreamReader(Config.Events.GetScript(ScriptName) || ScriptName))
			. = Block()
		catch (var/ScriptCompilationException/ex)
			ErrorText(ex.GetFormattedMessage())

	proc/ParseLine(var/Script)
		try
			Tokens = new/Lexer(new/StreamReader(Script, TRUE))
			. = Line()
		catch (var/ScriptCompilationException/ex)
			ErrorText(ex.GetFormattedMessage())


	// -----------------------------

	proc/Line()
		if (Expect("/"))
			if (Is(Functions))
				var/ASTNode/FunctionNode/Node = new(Functions[Tokens.Consume()])
				. = Node
				while (Tokens.Current())
					Node.SubNodes += new/ASTNode/ValueLeaf(Tokens.Consume())
			else
				return Statement()


	proc/Block()
		var/ASTNode/BlockNode/Node = new()
		Node.ScriptLine = Tokens.Line
		. = Node
		SkipEOLs()
		while(!(Tokens.Current() in FollowsBlock))
			var/B = SubBlock()
			if (!B)
				throw new/ScriptCompilationException("Empty SubBlock", Tokens.Line)
			Node.SubNodes += B
			SkipEOLs()
		if(Node.SubNodes.len == 1)
			return Node.SubNodes[1]


	proc/SubBlock()
		. = list()
		if (Tokens.Current() == BeginStatementBlock)
			Tokens.Consume()
			var/B = Block()
			if (!B)
				throw new/ScriptCompilationException("Missing Block", Tokens.Line)
			. += B
			if (Tokens.Current() != EndStatementBlock)
				throw new/ScriptCompilationException("Unexpected symbol in SubBlock, expected }", Tokens.Line)
			else
				Tokens.Consume()
		else
			var/S = Statement()
			if (!S)
				throw new/ScriptCompilationException("Missing Statement", Tokens.Line)
			. += S


	proc/Statement()
		SkipEOLs()
		switch(Tokens.Current())
			if(EndStatement, Newline)
				Tokens.Consume()
				return list() // list(), so that no nodes are added to whatever called Statement()
			if("if")
				Tokens.Consume()
				return If()
			if("while")
				Tokens.Consume()
				return While()
			if("do")
				Tokens.Consume()
				. = Do()
			else
				// Expression() will incidentally consume all EOLs trying to see if a statement crosses the newline
				// This is a problem if you tried to use a newline to terminate.  Since EOLs and semicolons after that
				// will get parsed out as empty statements, just return Expression().
				return Expression()


		if (!(Tokens.Current() in list("}", null)) && !Expect(EndStatement, Newline))
			throw new/ScriptCompilationException("Erroneous continuation of statement", Tokens.Line)


	proc/Expression(var/Level = 0)
		var/S = SubExpression()

		if (!S)
			throw new/ScriptCompilationException("Missing expression", Tokens.Line)

		. = S

		if (Expect(TrinaryStart))
			// Handle trinary
			var/ASTNode/Trinary/Node = new()
			Node.ScriptLine = Tokens.Line
			. = Node
			Node.SubNodes += S
			S = Expression()
			if (!S)
				throw new/ScriptCompilationException("Missing true-side body in trinary expression", Tokens.Line)
			if(!Expect(TrinaryMid))
				throw new/ScriptCompilationException("Unexpected symbol in trinary operator, expected :", Tokens.Line)
			Node.SubNodes += S
			S = Expression()
			if (!S)
				throw new/ScriptCompilationException("Missing false-side body in trinary expression", Tokens.Line)
			Node.SubNodes += S


		else if (Tokens.Current() in BinaryAll)
			var/ASTNode/Binary/Node = new()
			Node.ScriptLine = Tokens.Line



			// This is the fun part.  Apply rules for operator precedence

			// Handle Binary
			for (var/TestLevel = 6; TestLevel > Level; TestLevel--)
				while (Tokens.Current() in Binaries[TestLevel])
					if (Node.SubNodes.len == 2)
						Node = new()
						Node.ScriptLine = Tokens.Line
					Node.Op = Tokens.Consume()
					Node.SubNodes += .
					. = Node
					S = Expression(TestLevel)
					if (!S)
						throw new/ScriptCompilationException("Missing left-hand side to [Node.Op] operator", Tokens.Line)
					Node.SubNodes += S


			// Assignment operators are right-associative instead of left-associative
			while (Level <= 0 && (Tokens.Current() in Binary0))
				if (Node.SubNodes.len == 2)
					Node = new()
					Node.ScriptLine = Tokens.Line
				Node.Op = Tokens.Consume()
				Node.SubNodes += .
				. = Node
				S = Expression(Level)
				if (!S)
					throw new/ScriptCompilationException("Missing left-hand expression in [Node.Op] assignment", Tokens.Line)
				Node.SubNodes += S


	proc/SubExpression()
		if (Tokens.Current() == BeginParenthesis)
			Tokens.Consume()
			. = Expression()
			if (!Expect(EndParenthesis))
				throw new/ScriptCompilationException("Unexpected symbol in expression, expected )", Tokens.Line)

		else if (Is(Unary))
			. = Unary()

		else
			. = Value()


	proc/Unary()
		var/ASTNode/Unary/Node = new()
		Node.ScriptLine = Tokens.Line
		. = Node
		Node.UnaryType = Tokens.Consume()
		Node.SubNodes += Expression()
		if (Node.SubNodes[1] == null)
			throw new/ScriptCompilationException("Malformed unary node", Tokens.Line)


	proc/Value()
		if (findtext(Numeric, copytext(Tokens.Current(), 1, 2)))
			. = new/ASTNode/ValueLeaf(Tokens.Consume())

		else if (Tokens.Current() == StringCap)
			Tokens.Consume()
			var/Line = Tokens.Line
			. = new/ASTNode/ValueLeaf(Tokens.Consume())
			if (!Expect(StringCap))
				throw new/ScriptCompilationException("Unterminated string constant", Line)

		else if (Is(VariableStarts))
			var/VarType = Tokens.Consume()
			var/ASTNode/VariableNode/Node = new(Tokens.Consume(), VarType)
			Node.ScriptLine = Tokens.Line
			. = Node
			if (Expect(BeginIndexer))
				var/E = Expression()
				if (!E)
					return null
				Node.SubNodes += E
				if (!Expect(EndIndexer))
					throw new/ScriptCompilationException("Unexpected symbol in array index, expected ]", Tokens.Line)
			else if (Tokens.Current() == ParameterMarker)
				while (Expect(ParameterMarker))
					Node.Members += Tokens.Consume()
				if (Tokens.Current() == BeginParenthesis)
					Node.Arguments = ArgumentList()
					if (!Node.Arguments)
						throw new/ScriptCompilationException("No arguments in member function call", Tokens.Line)

		else if (Is(Functions))
			var/ASTNode/FunctionNode/Node = new(Functions[Tokens.Consume()])
			Node.ScriptLine = Tokens.Line
			. = Node

			Node.SubNodes = ArgumentList()

			if(!Node.SubNodes)
				throw new/ScriptCompilationException("No arguments to function", Tokens.Line)

		else if (Is(Constants))
			. = new/ASTNode/ValueLeaf(Constants[Tokens.Consume()])

	proc/ArgumentList()
		. = list()

		if (!Expect(BeginParenthesis))
			throw new/ScriptCompilationException("Unexpected symbol in function call, expected (", Tokens.Line)

		while (Tokens.Current() && Tokens.Current() != EndParenthesis)
			if (Tokens.Current() == ArgumentSeparator)
				throw new/ScriptCompilationException("Unexpected argument separator in argument list", Tokens.Line)

			var/E = Expression()
			if (!E)
				throw new/ScriptCompilationException("Invalid or malformed argument in argument list", Tokens.Line)
			. += E

			if (!Expect(ArgumentSeparator))
				if (Tokens.Current() == EndParenthesis)
					break
				throw new/ScriptCompilationException("Unexpected symbol in argument list, expected argument separator", Tokens.Line)

		if (!Expect(EndParenthesis))
			throw new/ScriptCompilationException("Unexpected symbol in argument list, expected )", Tokens.Line)

	proc/If()
		var/E = Clause()

		if (!E)
			throw new/ScriptCompilationException("Missing clause in if statement", Tokens.Line)

		var/ASTNode/IfThen/Node = new()
		Node.ScriptLine = Tokens.Line
		. = Node

		Node.SubNodes += E

		E = SubBlock()

		if (!E)
			throw new/ScriptCompilationException("Missing body in if statement", Tokens.Line)

		Node.SubNodes += E

		if (Expect("else"))
			E = Else()

			if (!E)
				return null

			Node.SubNodes += E



	proc/Clause()

		if (!Expect(BeginParenthesis))
			return null


		var/E = Expression()


		if (!E)
			throw new/ScriptCompilationException("Missing expression in clause", Tokens.Line)

		. = E

		if (!Expect(EndParenthesis))
			throw new/ScriptCompilationException("Unexpected symbol in clause, expected )", Tokens.Line)

	proc/Else()
		if (Expect("if"))
			return If()
		return SubBlock()

	proc/While()
		var/E = Clause()

		if (!E)
			throw new/ScriptCompilationException("Missing clause for while loop", Tokens.Line)

		var/ASTNode/While/Node = new()
		Node.ScriptLine = Tokens.Line
		. = Node

		Node.SubNodes += E

		E = SubBlock()
		if (!E)
			throw new/ScriptCompilationException("While loop has no body", Tokens.Line)

		Node.SubNodes += E


	proc/Do()

		if (!Expect(BeginStatementBlock))
			throw new/ScriptCompilationException("Unexpected symbol in do loop, expected {", Tokens.Line)

		var/E = SubBlock()

		if (!E || !Expect(EndStatementBlock))
			throw new/ScriptCompilationException("Malformed do loop body or missing }", Tokens.Line)

		var/S = Expect("while","until")

		if (!S)
			throw new/ScriptCompilationException("Do loop has no repeat condition", Tokens.Line)

		var/ASTNode/Do/Node = new(S)
		Node.ScriptLine = Tokens.Line
		. = Node
		Node.SubNodes += E

		E = Clause()

		if (!E)
			throw new/ScriptCompilationException("Do loop has no repeat clause", Tokens.Line)

		Node.SubNodes += E


	proc/SkipEOLs()
		while (Tokens.Current() && Tokens.Current() == Newline)
			Tokens.Consume()

	proc/Expect()
		if (!(Newline in args))
			SkipEOLs()
		if (Tokens.Current() in args)
			. = Tokens.Consume()

	proc/Is(var/list/L)
		if (!(Newline in args) && (!IsList(L) || !(Newline in L)))
			SkipEOLs()
		var/T = Tokens.Current()
		. = (T in L) || (T in args)