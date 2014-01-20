/ASTNode/IfThen

	Execute()
		var/ASTNode/Node = SubNodes[1]
		Node = SubNodes[Node.Execute() ? 2 : 3]
		Node.Execute()