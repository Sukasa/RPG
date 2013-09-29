/datum/ChatCommand/Flash
	Command = "flash"
	MinPowerLevel = RankPlayer

/datum/ChatCommand/Flash/Execute(var/mob/Player, var/CommandText)
	Player.client.Flash.FlashBlocking(ColorWhite, 0.5, 1.5)
	Player.client.Flash.FlashBlocking(ColorWhite, 1, 3.5)
	Player.client.Flash.FlashBlocking(ColorRed, 2, 8.5)