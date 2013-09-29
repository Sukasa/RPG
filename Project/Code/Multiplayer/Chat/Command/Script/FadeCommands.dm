/datum/ChatCommand/FadeIn
	Command = "fadein"

/datum/ChatCommand/FadeIn/Execute(var/mob/Player, var/CommandText)
	Config.Events.FadeIn()



/datum/ChatCommand/FadeOut
	Command = "fadeout"

/datum/ChatCommand/FadeOut/Execute(var/mob/Player, var/CommandText)
	Config.Events.FadeOut()



/datum/ChatCommand/Blackout
	Command = "blackout"

/datum/ChatCommand/Blackout/Execute(var/mob/Player, var/CommandText)
	Config.Events.Set()



/datum/ChatCommand/Clear
	Command = "clear"

/datum/ChatCommand/Clear/Execute(var/mob/Player, var/CommandText)
	Config.Events.Set(ColorBlack, 0)