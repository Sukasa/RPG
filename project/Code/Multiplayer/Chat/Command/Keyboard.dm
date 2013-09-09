/datum/ChatCommand/KeyUp
	Command = "keyup"

/datum/ChatCommand/KeyDown
	Command = "keydown"

/datum/ChatCommand/KeyUp/Execute(var/mob/Player, var/CommandText)
	var/Handler = Player.client.GetKeyboardHandler()
	Handler:KeyUp(CommandText, Player)

/datum/ChatCommand/KeyDown/Execute(var/mob/Player, var/CommandText)
	var/Handler = Player.client.GetKeyboardHandler()
	Handler:KeyDown(CommandText, Player)