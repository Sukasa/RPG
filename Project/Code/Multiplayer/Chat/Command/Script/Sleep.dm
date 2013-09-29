/datum/ChatCommand/Sleep
	Command = "sleep"
	MinPowerLevel = RankScriptsOnly

/datum/ChatCommand/Sleep/Execute(var/mob/Player, var/CommandText)
	sleep(text2num(CommandText))