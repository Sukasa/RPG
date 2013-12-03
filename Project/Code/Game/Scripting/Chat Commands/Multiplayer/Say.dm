/ChatCommand/Say
	Command = "say"
	MinPowerLevel = RankPlayer

/ChatCommand/Say/Execute(var/mob/Player, var/CommandText)
	if (Player)
		Broadcast("<[Player.name]> [CommandText]")
	else
		Broadcast(CommandText)