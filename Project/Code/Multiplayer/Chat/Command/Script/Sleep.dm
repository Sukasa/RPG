/ChatCommand/Sleep
	Command = "sleep"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/Sleep/Execute(var/mob/Player, var/CommandText)
	sleep(text2num(CommandText))