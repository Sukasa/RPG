/ChatCommand/Save
	Command = "save"

/ChatCommand/Save/Execute(var/mob/Player, var/CommandText)
	var/Savegame/S = new()
	S.ImportCurrentState()
	S.Save()

	Config.Events.Dialogue(Player, "Saved")