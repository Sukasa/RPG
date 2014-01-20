ConditionalCommand/Parenthesis
	Command = "("

ConditionalCommand/Parenthesis/Execute(var/mob/Player, var/CommandText, var/ScriptExecutionContext/Context)
	if (RequireContext())
		return

	Context.PushConditional(TRUE)

ConditionalCommand/EndParenthesis
	Command = ")"

ConditionalCommand/EndParenthesis/Execute(var/mob/Player, var/CommandText, var/ScriptExecutionContext/Context)
	if (RequireContext() || RequireConditional())
		return

	Context.ApplyCondition(Context.PopConditional())


ConditionalCommand/EndNotParenthesis
	Command = "!)"

ConditionalCommand/EndNotParenthesis/Execute(var/mob/Player, var/CommandText, var/ScriptExecutionContext/Context)
	if (RequireContext() || RequireConditional())
		return

	Context.ApplyCondition(!Context.PopConditional())