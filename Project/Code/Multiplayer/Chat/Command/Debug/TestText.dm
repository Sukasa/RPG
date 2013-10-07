/ChatCommand/TestText
	Command = "text"
	MinPowerLevel = RankPlayer

/ChatCommand/TestText/Execute(var/mob/Player, var/CommandText)
	var/obj/A = Config.Text.Create(Player.client, CommandText, Lines = 8, Width = 400)
	A.screen_loc = "2, 8"
	Player.client.screen += A
	spawn(90)
		del A

/ChatCommand/TestTextBig
	Command = "big"
	MinPowerLevel = RankPlayer

/ChatCommand/TestTextBig/Execute(var/mob/Player, var/CommandText)
	var/obj/A = Config.Text.Create(Player.client, CommandText, Lines = 8, Width = 400, FontFace = /datum/Font/LaconicShadow48)
	A.screen_loc = "2, 8"
	Player.client.screen += A
	spawn(90)
		del A