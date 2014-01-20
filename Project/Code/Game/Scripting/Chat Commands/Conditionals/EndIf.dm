ConditionalCommand/EndIf
	Command = "endif"

ConditionalCommand/EndIf/Execute(var/mob/Player, var/CommandText, var/ScriptExecutionContext/Context)
	if (RequireContext() || RequireConditional())
		return

	Context.PopConditional()