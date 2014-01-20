/ASTNode/Trinary

	Execute()
		var/ASTNode/Condition = SubNodes[1]
		var/ASTNode/Executor = Condition ? SubNodes[2] : SubNodes[3]
		. = Executor.Execute()