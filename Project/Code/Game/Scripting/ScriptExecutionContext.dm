ScriptExecutionContext
	var
		Stack/Conditionals = new()
		ScriptExecutionContext/Parent = null
		list/Variables = list( )

		AbortScriptExecution = FALSE
		StopAbortPropagation = FALSE
		ScriptName = ""
		ScriptLine = 0

	New()
		Variables |= ScriptVariables

	// TODO remove the below

	proc/PrintStackTrace()
		var/ScriptExecutionContext/Context = src
		while (Context)
			ErrorText("..at [ScriptName]: line [ScriptLine]")
			Context = Context.Parent

	proc/Abort(var/UpChain = FALSE)
		var/ScriptExecutionContext/Context = src
		do
			Context.AbortScriptExecution = TRUE
			Context = Context.Parent
		while (UpChain && Context && !Context.StopAbortPropagation)

	proc/AllConditionals()
		. = TRUE
		if (!Conditionals.IsEmpty())
			for(var/X in Conditionals.Peek())
				. = . && X

	proc/AnyConditional()
		. = FALSE
		if (!Conditionals.IsEmpty())
			for(var/X in Conditionals.Peek())
				. = . || X

	proc/GetSubConditional()
		var/list/C = Conditionals.Pop();
		. = AllConditionals()
		Conditionals.Push(C);

	proc/ApplyCondition(var/Value)
		var/list/L = Conditionals.Peek()
		L += !!Value // Convert to boolean representation

	proc/PushConditional(var/Value)
		Conditionals.Push(list(!!Value))

	proc/PopConditional()
		. = AllConditionals()
		Conditionals.Pop()