/*

	Script parser.  Uses the lexer to build an Abstract Syntax Tree out of a script, so taht it can be interpreted later.  (Or compiled down, whatever).

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

			Numeric = "0123456789"
			StringCap = "\""

			ArgumentSeparator = ","

			Newline = "\n"

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
		Tokens = new/Lexer(new/StreamReader(Config.Events.GetScript(ScriptName)))
		. = Block()
		if (!.)
			ErrorText("Failed to parse script [ScriptName]!")
			ErrorText("Unrecognized or unexpected token \"[Tokens.Current()]\" on line [Tokens.Line]")

	proc/ParseDialogLine(var/Script)
		Tokens = new/Lexer(new/StreamReader(Script))
		. = Line()
		if (!.)
			ErrorText("Error - Incorrect or malformed command")

	// -----------------------------

	proc/Line()
		if (Expect("/") && Is(Functions))
			var/ASTNode/FunctionNode/Node = new(Tokens.Consume())
			. = Node
			while (Tokens.Current())
				Node.SubNodes += new/ASTNode/ValueLeaf(Tokens.Consume())


	proc/Block()
		var/ASTNode/BlockNode/Node = new()
		. = Node
		while(!(Tokens.Current() in FollowsBlock))
			var/B = SubBlock()
			if (!B)
				return null
			Node.SubNodes += B


	proc/SubBlock()
		. = list()
		if (Tokens.Current() == BeginStatementBlock)
			Tokens.Consume()
			var/B = Block()
			if (!B)
				return null
			. += B
			if (Tokens.Current() != EndStatementBlock)
				return null
			else
				Tokens.Consume()
		else
			var/S = Statement()
			if (!S)
				return null
			. += S


	proc/Statement()
		SkipEOLs()
		switch(Tokens.Current())
			if(EndStatement)
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
				. = Expression()

		if (!Expect(EndStatement, Newline))
			. = null


	proc/Expression(var/Level = 0)
		var/S = SubExpression()

		if (!S)
			return null

		. = S

		if (Expect(TrinaryStart))
			// Handle trinary
			var/ASTNode/Trinary/Node = new()
			. = Node
			Node.SubNodes += S
			S = Expression()
			if (!S || !Expect(TrinaryMid))
				return null
			Node.SubNodes += S
			S = Expression()
			if (!S)
				return null
			Node.SubNodes += S


		else if (Tokens.Current() in BinaryAll)
			var/ASTNode/Binary/Node = new()
			. = Node

			// This is the fun part.  Apply rules for operator precedence

			// Handle Binary
			while (Level <= 6 && Level >= 1 && (Tokens.Current() in Binaries[Level]))
				Node.Op = Tokens.Consume()
				Node.SubNodes += S
				S = Expression(Level + 1)
				if (!S)
					return null
				Node.SubNodes += S

			// Assignment operators are right-associative instead of left-associative
			while (Level <= 0 && (Tokens.Current() in Binary0))
				Node.Op = Tokens.Consume()
				Node.SubNodes += S
				S = Expression(Level)
				if (!S)
					return null
				Node.SubNodes += S

	proc/SubExpression()
		if (Tokens.Current() == BeginParenthesis)
			Tokens.Consume()
			. = Expression()
			if (!Expect(EndParenthesis))
				. = null

		else if (Is(Unary))
			. = Unary()

		else
			. = Value()


	proc/Unary()
		var/ASTNode/Unary/Node = new()
		. = Node
		Node.UnaryType = Tokens.Consume()
		Node.SubNodes += Expression()
		if (Node.SubNodes[1] == null)
			return null


	proc/Value()
		if (findtext(Numeric, copytext(Tokens.Current(), 1, 2)))
			. = new/ASTNode/ValueLeaf(text2num(Tokens.Consume()))

		else if (Tokens.Current() == StringCap)
			Tokens.Consume()
			. = new/ASTNode/ValueLeaf(text2num(Tokens.Consume()))
			if (!Expect(StringCap))
				return null

		else if (Is(VariableStarts))
			var/VarType = Tokens.Consume()
			var/ASTNode/VariableNode/Node = new(Tokens.Consume(), VarType)
			. = Node
			if (Tokens.Current() == BeginIndexer)
				Tokens.Consume()
				var/E = Expression()
				if (!E)
					return null
				Node.SubNodes += E
			if (!Expect(EndIndexer))
				return null

		else if (Is(Functions))
			var/ASTNode/FunctionNode/Node = new(Functions[Tokens.Consume()])
			. = Node

			if (!Expect(BeginParenthesis))
				return null

			while (Tokens.Current() && Tokens.Current() != EndParenthesis)
				if (Tokens.Current() == ArgumentSeparator)
					return null

				var/E = Expression()
				if (!E)
					return null
				Node.SubNodes += E

				if (!Expect(ArgumentSeparator))
					return null

			if (!Expect(EndParenthesis))
				return null

		else if (Is(Constants))
			. = new/ASTNode/ValueLeaf(Constants[Tokens.Consume()])

		else
			return null

	proc/If()
		var/E = Clause()

		if (!E)
			return null

		var/ASTNode/IfThen/Node = new()
		. = Node

		Node.SubNodes += E

		E = SubBlock()

		if (!E)
			return null

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
			return null

	 	. = E

		if (!Expect(EndParenthesis))
			. = null

	proc/Else()
		if (Expect("if"))
			return If()
		return SubBlock()

	proc/While()
		var/E = Clause()

		if (!E)
			return null

		var/ASTNode/While/Node = new()
		. = Node

		Node.SubNodes += E

		E = SubBlock()
		if (!E)
			return null

		Node.SubNodes += E


	proc/Do()

		if (!Expect(BeginStatementBlock))
			return null

		var/E = SubBlock()

		if (!E || !Expect(EndStatementBlock))
			return null

		var/S = Expect("while","until")

		if (!S)
			return null

		var/ASTNode/Do/Node = new(S)
		. = Node
		Node.SubNodes += E

		E = Clause()

		if (!E)
			return null

		Node.SubNodes += E


	proc/SkipEOLs()
		while (Tokens.Current() && Tokens.Current() == Newline)
			Tokens.Consume()

	proc/Expect()
		SkipEOLs()
		if (Tokens.Current() in args)
			. = Tokens.Consume()

	proc/Is(var/list/L)
		SkipEOLs()
		var/T = Tokens.Current()
		. = (T in L) || (T in args)