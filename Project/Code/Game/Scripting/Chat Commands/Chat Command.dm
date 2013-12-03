ChatCommand
	var/Command = ""
	var/MinPowerLevel = RankModerator

ChatCommand/New(var/CommandController/Master)
	ASSERT(Command != "")
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

ChatCommand/proc/ShouldExecute(var/datum/ScriptExecutionContext/Context)
	return !Context || Context.Conditionals.IsEmpty() || Context.Conditionals.Peek()

ChatCommand/proc/Parse(var/StringComponent, var/datum/ScriptExecutionContext/Context)
	if (text2ascii(StringComponent) == 36) // 36 == $
		. = Context.Variables[copytext(StringComponent, 2)] // Context variable
	else if (text2ascii(StringComponent) == 37) // 37 == $
		. = Config.Globals[copytext(StringComponent, 2)] // Global variable
	else
		. = text2num(StringComponent) || StringComponent // Literal