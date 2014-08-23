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