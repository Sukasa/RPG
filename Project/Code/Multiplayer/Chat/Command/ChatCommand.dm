/datum/ChatCommand
	var/Command = ""
	var/MinPowerLevel = RankModerator

/datum/ChatCommand/New(var/datum/CommandController/Master)
	if (Command != "")
		Master.AllCommands[Command] = src

/datum/ChatCommand/proc/Execute(var/mob/Player, var/CommandText)
	return

/datum/ChatCommand/proc/PlayerByName(var/PlayerName)
	for(var/mob/M in world)
		if (M.name == PlayerName)
			return M