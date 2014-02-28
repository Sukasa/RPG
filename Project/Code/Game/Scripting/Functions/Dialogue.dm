proc/CreateDialogue(var/Player)
	var/QueuedDialogue/T = new()
	T.Player = Player || ScriptVariables["player"]
	return T

proc/ScriptQueueDialogue(var/QueuedDialogue/QD)
	if (!QD.Player)
		ErrorText("Cannot enequeue dialogue without player ref!")
		return
	Config.Events.Dialogue(QD)