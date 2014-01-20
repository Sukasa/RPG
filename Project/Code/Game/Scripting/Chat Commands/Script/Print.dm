ChatCommand/Print
	Command = "print"

ChatCommand/Print/Execute(var/Executor, var/CommandText)
	var/list/Params = ParamList(CommandText)
	for(var/X = 2; X <= Params.len; X++)
		Params[1] = Parse(Params[1])
		Params[1] = "[Params[1]] [Parse(Params[X])]"

	DebugText(Params[1])