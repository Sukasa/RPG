/ChatCommand/SetVar
	Command = "set"
	var
		list/Operations = list()

/ChatCommand/SetVar/Execute(var/Executor, var/CommandText)
	if (RequireContext())
		return

	var/list/Params = ParamList(CommandText)

	if (Params.len < 3)
		ErrorText("Incorrect parameter count to /set, must have params (VarDest) (Operand) (Value)")
		Context.PrintStackTrace()
		Context.AbortScriptExecution = TRUE
		return

	var/VariableType = text2ascii(Params[1])
	// Ensure var can be set (i.e. is $ or %)
	if (!(VariableType in list(36, 37)))
		ErrorText("Unrecognized identifier for /set VarDest")
		Context.PrintStackTrace()
		return

	var/SetOp/Op = Operations[Params[2]]

	if (!Op)
		ErrorText("Unknown /set operator [Params[2]]")
		Context.PrintStackTrace()
		return

	if (Op.type == /SetOp) // Support stuff like "set $MyText = Some string with $Variable here." without breaking "set $MyVar = 2"
		for(var/X = 4; X <= Params.len; X++)
			Params[3] = Parse(Params[3])
			Params[3] = "[Params[3]] [Parse(Params[X])]"

	var/NewValue = "[Op.Operation(Parse(Params[1]), Parse(Params[3]))]"
	if (VariableType == 36)
		Context.Variables[copytext(Params[1], 2)] = NewValue
	else
		Config.Globals[copytext(Params[1], 2)] = NewValue

/ChatCommand/SetVar/New()
	..()
	for(var/Type in typesof(/SetOp))
		var/SetOp/S = new Type()
		world.log << S.Opcode
		Operations[S.Opcode] = S