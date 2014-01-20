/ASTNode/Unary
	var/UnaryType

	Execute()
		switch(UnaryType)
			if("-")
				var/ASTNode/Node = SubNodes[1]
				. = -Node.Execute()
			if ("!")
				var/ASTNode/Node = SubNodes[1]
				. = !Node.Execute()
			if ("~")
				var/ASTNode/Node = SubNodes[1]
				. = ~Node.Execute()