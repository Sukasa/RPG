/ASTNode/Binary
	var/Op

	Execute()
		var/ASTNode/Node = SubNodes[1]
		var/Side1 = Node.Execute()

		Node = SubNodes[2]
		var/Side2 = Node.Execute()

		switch (Op)
			if ("+")
				return Side1 + Side2
			if ("-")
				return Side1 - Side2
			if ("*")
				return Side1 * Side2
			if ("/")
				return Side1 / Side2
			if ("^")
				return Side1 ^ Side2
			if ("%")
				return Side1 % Side2
			if ("|")
				return Side1 | Side2
			if ("&")
				return Side1 & Side2
			if ("||")
				return Side1 || Side2
			if ("&&")
				return Side1 && Side2
			if (">>")
				return Side1 >> Side2
			if ("<<")
				return Side1 << Side2
			if ("==")
				return Side1 == Side2
			if ("!=")
				return Side1 != Side2
			if (">")
				return Side1 > Side2
			if (">=")
				return Side1 >= Side2
			if ("<")
				return Side1 < Side2
			if ("<=")
				return Side1 <= Side2

			if ("=")
			if ("+=")
			if ("-=")
			if ("*=")
			if ("/=")
			if ("<<=")
			if (">>=")
			if ("^=")
			if ("|=")
			if ("&=")
			if ("%=")
			if ("*")
			if ("*")