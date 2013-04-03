/datum/ChatCommand/Say
	Command = "say"
	MinPowerLevel = RankPlayer

/datum/ChatCommand/Say/Execute(var/mob/Player, var/CommandText)
	Broadcast("<[Player.name]> [CommandText]")