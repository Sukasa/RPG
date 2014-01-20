ChatCommand
	var
		Command = ""
		MinPowerLevel = RankModerator
		ScriptExecutionContext/Context = null

ChatCommand/New(var/CommandController/Master)
	if (Command != "")
		Master.AllCommands[Command] = src

ChatCommand/proc/Execute(var/mob/Player, var/CommandText)
	return

ChatCommand/proc/PlayerByName(var/PlayerName)
	for(var/mob/M in world)
		if (lowertext(M.name) == lowertext(PlayerName))
			return M

ChatCommand/proc/ParamList(var/CommandText)
	. = list( )
	var/LastPos = 1
	var/Pos = findtext(CommandText, " ")
	while (Pos)
		if (Pos - LastPos > 1)
			. += copytext(CommandText, LastPos, Pos)
		LastPos = Pos + 1
		Pos = findtext(CommandText, " ", LastPos)
	. += copytext(CommandText, LastPos)

ChatCommand/proc/ShouldExecute(var/ScriptExecutionContext/Context)
	return !Context || Context.AllConditionals()

ChatCommand/proc/Parse(var/StringComponent)
	if (text2ascii(StringComponent) == 36 && Context) // 36 == $
		. = Context.Variables[copytext(StringComponent, 2)] // Context variable
	else if (text2ascii(StringComponent) == 37) // 37 == %
		. = Config.Globals[copytext(StringComponent, 2)] // Global variable
	else
		. = StringComponent // Literal
	. = text2num(.) || (. == "0" ? 0 : .) // Now process for if it's a number or not

	var/T = copytext(., 1, 3)
	if (T == "\\$" || T == "\\%")
		. = copytext(., 2)

ChatCommand/proc/RequireContext()
	if (!Context)
		ErrorText("Cannot execute [Command] without context")
		return TRUE
	return FALSE

ChatCommand/proc/RequireConditional()
	if (!Context)
		return TRUE
	if (Context.Conditionals.IsEmpty())
		ErrorText("Cannot execute [Command] on empty conditional stack")
		Context.PrintStackTrace(Context)
		return TRUE
	return FALSE