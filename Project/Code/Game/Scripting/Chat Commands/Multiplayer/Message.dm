/ChatCommand/Message
	Command = "msg"
	MinPowerLevel = RankPlayer

/ChatCommand/Message/Execute(var/mob/Player, var/CommandText)
	var/Space = findtext(CommandText, " ")
	var/TargetName = copytext(CommandText, 1, Space)

	var/Target = PlayerByName(TargetName)
	if (Target)
		SendUser(Target, "\blue \[[Player.name]] [copytext(CommandText, Space + 1)]")
	else
		SendUser("\red No user by the name [TargetName] is online")