/ASTNode/VariableNode
	var/list/Ref
	var/VariableName
	var/list/Members = list()
	var/list/Arguments

	New(var/Name, var/UseRef)
		if (UseRef == "%")
			Ref = Config.Globals
		VariableName = Name

	Execute()
		var/list/Container = Ref

		if (Container != Config.Globals)
			Container = Context.Variables


		var/datum/D = Container[VariableName]
		. = D

		var/X = 0
		var/Member

		for(X = 1; X < Members.len; X++)
			if (!istype(D, /datum)) // Lists are apparently not datums.
				ErrorText("Attempt to index member [Members[X]] of non-object '[D]' in script [Context.ScriptName]")
				return null

			Member = Members[X]

			if(Member in D.vars)
				D = D.vars[Member]
			else
				ErrorText("Unknown member [Member] of [D] in script [Context.ScriptName]")
				return null

		if (X)
			Member = Members[X]
			if(!(Member in D.vars))
				ErrorText("Unknown member [Member] of [D] in script [Context.ScriptName]")
				return null

		if (X && Member in D.vars)
			D = D.vars[Member]
			. = D
		else if (X && hascall(D, Member))
			if (Arguments)
				var/list/L = list()
				for(var/ASTNode/Node in Arguments)
					L += Node.Execute()
				return call(D, Member)(L)
			else
				ErrorText("Attempt to use function ref [Member] as variable in script [Context.ScriptName]")
				return null

		if (SubNodes.len == 1)
			if (istype(D, /list))
				var/ASTNode/Node = SubNodes[1]
				. = D[Node.Execute()]
			else
				ErrorText("Attempt to index non-list as list in script [Context.ScriptName]")
				return null


	proc/Set(var/NewValue)
		if (Arguments)
			ErrorText("Attempt to assign to function in script [Context.ScriptName]")

		var/list/Container = Ref
		if (Container != Config.Globals)
			Container = Context.Variables

		var/datum/D = Container[VariableName]

		var/X = 0
		var/Member

		for(X =1; X < Members.len; X++)
			if (!istype(D, /datum)) // Lists are apparently not datums.
				ErrorText("Attempt to index member [Members[X]] of non-object '[D]' in script [Context.ScriptName]")
				return null

			Member = Members[X]

			if(Member in D.vars)
				D = D.vars[Member]
			else
				ErrorText("Unknown member [Member] of [D] in script [Context.ScriptName]")
				return null

		if (X)
			Member = Members[X]
			if(!(Member in D.vars))
				ErrorText("Unknown member [Member] of [D] in script [Context.ScriptName]")
				return null

		if (X && Member in D.vars)
			if (SubNodes.len == 1)
				var/list/L = D.vars[Member]
				if (istype(L))
					var/ASTNode/Node = SubNodes[1]
					L[Node.Execute()] = NewValue
				else
					ErrorText("Attempt to index non-list as list in script [Context.ScriptName]")
			else
				D.vars[Member] = NewValue

	Output()
		world.log << "Variable node: [VariableName]"
		if (SubNodes.len == 1)
			var/ASTNode/Node = SubNodes[1]
			world.log << "Has indexer node:"
			Node.Output()