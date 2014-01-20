/ASTNode/VariableNode
	var/list/Ref
	var/VariableName

	New(var/Name, var/UseRef)
		if (UseRef == "%")
			Ref = Config.Globals
		else
			Ref = Context.Variables

	Execute()
		if (SubNodes.len == 1)
			var/list/L = Ref[VariableName]
			var/ASTNode/Node = SubNodes[1]
			return L[Node.Execute()]
		else
			return Ref[VariableName]

	proc/Set(var/NewValue)
		if (SubNodes.len == 1)
			var/list/L = Ref[VariableName]
			var/ASTNode/Node = SubNodes[1]
			L[Node.Execute()] = NewValue
		else
			Ref[VariableName] = NewValue
