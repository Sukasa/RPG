/ChatCommand
	var/Command = ""
	var/MinPowerLevel = RankModerator

/ChatCommand/New(var/CommandController/Master)
	ASSERT(Command != "")
	Master.AllCommands[Command] = src

/ChatCommand/proc/Execute(var/mob/Player, var/CommandText)
	return

/ChatCommand/proc/PlayerByName(var/PlayerName)
	for(var/mob/M in world)
		if (lowertext(M.name) == lowertext(PlayerName))
			return M

/ChatCommand/proc/ParamList(var/CommandText)
	. = list( )
	var/LastPos = 1
	var/Pos = findtext(CommandText, " ")
	while (Pos)
		if (Pos - LastPos > 1)
			. += copytext(CommandText, LastPos, Pos)
		LastPos = Pos + 1
		Pos = findtext(CommandText, " ", LastPos)
	. += copytext(CommandText, LastPos)