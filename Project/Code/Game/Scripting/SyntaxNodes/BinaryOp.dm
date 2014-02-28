/ASTNode/Binary
	var/Op

	Output()
		world.log << "Binary node: Operation is [Op]"
		for(var/ASTNode/Node in SubNodes)
			Node.Output()

	Execute()
		var/ASTNode/VariableNode/Node = SubNodes[2]
		var/Side2 = Node.Execute()

		Node = SubNodes[1]
		var/Side1 = Node.Execute()

		var/Assignment = FALSE
		if (Op != "==" && Op != "!=" && Op != "<=" && Op != ">=" && findtextEx(Op, "=", -1))
			Assignment = TRUE

		switch (Assignment ? copytext(Op, 1, length(Op)) : Op)
			if ("+")
				. = Side1 + Side2
			if ("-")
				. = Side1 - Side2
			if ("*")
				. = Side1 * Side2
			if ("/")
				. = Side1 / Side2
			if ("^")
				. = Side1 ^ Side2
			if ("%")
				. = Side1 % Side2
			if ("|")
				. = Side1 | Side2
			if ("&")
				. = Side1 & Side2
			if ("**")
				. = Side1 ** Side2
			if ("||")
				. = Side1 || Side2
			if ("&&")
				. = Side1 && Side2
			if (">>")
				. = Side1 >> Side2
			if ("<<")
				. = Side1 << Side2
			if ("==")
				. = Side1 == Side2
			if ("!=")
				. = Side1 != Side2
			if (">")
				. = Side1 > Side2
			if (">=")
				. = Side1 >= Side2
			if ("<")
				. = Side1 < Side2
			if ("<=")
				. = Side1 <= Side2

		if (Assignment)
			if (Op == "=")
				. = Side2
			Node.Set(.)