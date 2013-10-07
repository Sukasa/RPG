/ChatCommand/Action
	Command = "me"
	MinPowerLevel = RankPlayer

/ChatCommand/Action/Execute(var/mob/Player, var/CommandText)
	Broadcast("\magenta * [Player.name] [CommandText]")