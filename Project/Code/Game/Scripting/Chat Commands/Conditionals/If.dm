ConditionalCommand/If
	Command = "if"

ConditionalCommand/If/Execute(var/mob/Player, var/CommandText, var/ScriptExecutionContext/Context)
	if (RequireContext())
		return

	if (CommandText == "")
		Context.PushConditional(Context.AllConditionals())
	else
		Context.PushConditional(Parse(CommandText))