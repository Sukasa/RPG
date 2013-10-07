/ChatCommand/KeyUp
	Command = "keyup"

/ChatCommand/KeyDown
	Command = "keydown"

/ChatCommand/KeyUp/Execute(var/mob/Player, var/CommandText)
	var/Handler = Player.client.GetKeyboardHandler()
	Handler:KeyUp(CommandText, Player)

/ChatCommand/KeyDown/Execute(var/mob/Player, var/CommandText)
	var/Handler = Player.client.GetKeyboardHandler()
	Handler:KeyDown(CommandText, Player)