/ASTNode
	var
		list/SubNodes = list()
		global
			ScriptExecutionContext/Context

	proc/Execute()

	proc/Output()
		world.log << "[type] Node: [SubNodes.len] leaves"
		for(var/ASTNode/Node in SubNodes)
			Node.Output()