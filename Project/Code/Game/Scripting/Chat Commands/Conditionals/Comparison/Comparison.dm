/Comparison
	parent_type = /ConditionalCommand

Comparison/Execute(var/mob/Player, var/CommandText)
	if (RequireContext() || RequireConditional())
		return

	if (!Context.Conditionals.Peek())
		return	// If already false, don't waste time

	var/list/Params = ParamList(CommandText)

	if (Params.len != 2)
		ErrorText("Incorrect param count to /[Command].  Must be 2 params")
		Context.PrintStackTrace(Context)
		return

	Context.ApplyCondition(Compare(Parse(Params[0]), Parse(Params[1])))

Comparison/proc/Compare(var/One, var/Two)
	return FALSE