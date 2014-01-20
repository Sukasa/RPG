ConditionalCommand/Else
	Command = "else"

ConditionalCommand/Else/Execute(var/mob/Player, var/CommandText, var/ScriptExecutionContext/Context)
	if (RequireContext() || RequireConditional())
		return

	var/C = !Context.PopConditional()
	Context.PushConditional(Context.AllConditionals() && C)