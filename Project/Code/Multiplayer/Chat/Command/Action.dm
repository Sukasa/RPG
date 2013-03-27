/datum/ChatCommand/Action
	Command = "me"
	MinPowerLevel = RankPlayer

/datum/ChatCommand/Action/Execute(var/mob/Player, var/CommandText)
	Broadcast("\magenta * [Player.name] [CommandText]", Player.BroadcastChannels)