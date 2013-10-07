/ChatCommand/FadeIn
	Command = "fadein"

/ChatCommand/FadeIn/Execute(var/mob/Player, var/CommandText)
	Config.Events.FadeIn()



/ChatCommand/FadeOut
	Command = "fadeout"

/ChatCommand/FadeOut/Execute(var/mob/Player, var/CommandText)
	Config.Events.FadeOut()



/ChatCommand/Blackout
	Command = "blackout"

/ChatCommand/Blackout/Execute(var/mob/Player, var/CommandText)
	Config.Events.Set()



/ChatCommand/Clear
	Command = "clear"

/ChatCommand/Clear/Execute(var/mob/Player, var/CommandText)
	Config.Events.Set(ColorBlack, 0)