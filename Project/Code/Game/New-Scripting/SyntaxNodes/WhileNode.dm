/ASTNode/While

	Execute()
		var/ASTNode/Condition = SubNodes[1]
		var/ASTNode/Executor = SubNodes[2]
		while (Condition.Execute())
			Executor.Execute()