/ASTNode/Do
	var/Inversion

	New(var/Type)
		Inversion = Type == "until"

	Execute()
		var/ASTNode/Executor = SubNodes[1]
		var/ASTNode/Condition = SubNodes[2]

		do
			Executor.Execute()
		while ((!!Condition.Execute()) ^ Inversion)