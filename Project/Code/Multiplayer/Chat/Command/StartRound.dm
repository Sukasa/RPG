/datum/ChatCommand/StartRound
	Command = "start"
	MinPowerLevel = RankModerator

/datum/ChatCommand/StartRound/Execute(var/mob/Player, var/CommandText)
	InfoText("([Player.name]) Starting the Round")
	Ticker.Mode.Command("StartRound")