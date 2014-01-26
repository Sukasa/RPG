/ASTNode/FunctionNode
	var/FunctionRef

	New(var/Ref)
		FunctionRef = Ref

	Execute()
		. = list()
		for(var/ASTNode/Node in SubNodes)
			. += Node.Execute()
		if(istype(FunctionRef, /list))
			var/list/L = FunctionRef
			. = call(L[1], L[2])(.)
		else
			. = call(FunctionRef)(.)

	Output()
		world.log << "Function Node: [FunctionRef] with [SubNodes.len] params:"
		for(var/ASTNode/Node in SubNodes)
			Node.Output()
