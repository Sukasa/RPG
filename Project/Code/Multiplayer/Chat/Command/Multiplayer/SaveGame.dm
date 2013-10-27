/ChatCommand/Save
	Command = "save"

/ChatCommand/Save/Execute(var/mob/Player, var/CommandText)
	var/Savegame/S = new()
	S.ImportCurrentState()
	S.Save()
	del S