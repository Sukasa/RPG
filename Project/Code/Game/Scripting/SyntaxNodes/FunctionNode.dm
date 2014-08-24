/ASTNode/FunctionNode
	var/FunctionRef

	New(var/Ref)
		FunctionRef = Ref

	Execute()
		//world.log << "Executing function node: [FunctionRef]"
		. = list()
		var/SavedContext = Context
		for(var/ASTNode/Node in SubNodes)
			. += Node.Execute()
		if(istype(FunctionRef, /list))
			var/list/L = FunctionRef
			. = call(L[1], L[2])(arglist(.))
		else
			//var/list/L = .
			//world.log << "Calling [FunctionRef] with [L.len] arguments"
			. = call(FunctionRef)(arglist(.))
		Context = SavedContext

	Output()
		//world.log << "Function Node: [FunctionRef] with [SubNodes.len] params:"
		for(var/ASTNode/Node in SubNodes)
			Node.Output()
