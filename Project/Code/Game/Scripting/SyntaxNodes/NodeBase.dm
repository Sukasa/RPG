/ASTNode
	var
		list/SubNodes = list()
		ScriptLine = 0
		global
			ScriptExecutionContext/Context

	proc/Execute()

	proc/Output()
		world.log << "[type] Node: [SubNodes.len] leaves"
		for(var/ASTNode/Node in SubNodes)
			Node.Output()