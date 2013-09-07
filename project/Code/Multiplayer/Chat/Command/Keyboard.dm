/datum/ChatCommand/KeyUp
	Command = "keyup"

/datum/ChatCommand/KeyUp/Execute(var/mob/Player, var/CommandText)
	var/Handler = Player.client.GetKeyboardHandler()
	Handler:KeyUp(CommandText)



/datum/ChatCommand/KeyDown
	Command = "keydown"

/datum/ChatCommand/KeyDown/Execute(var/mob/Player, var/CommandText)
	var/Handler = Player.client.GetKeyboardHandler()
	Handler:KeyDown(CommandText)