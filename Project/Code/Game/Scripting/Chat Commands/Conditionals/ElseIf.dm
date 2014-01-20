ConditionalCommand/ElseIf
	Command = "elseif"

ConditionalCommand/ElseIf/Execute(var/mob/Player, var/CommandText, var/ScriptExecutionContext/Context)
	if (RequireContext() || RequireConditional())
		return

	if (Context.AllConditionals())
		Context.PopConditional()
		Context.PushConditional(FALSE)
	else if (Context.GetSubConditional())
		if (CommandText == "")
			Context.PopConditional()
			Context.PushConditional(TRUE)
		else
			Context.PopConditional()
			Context.PushConditional(Parse(CommandText))