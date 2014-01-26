proc/ScriptSaveGame()
	var/Savegame/S = new()
	S.ImportCurrentState()
	S.Save()

	var/QueuedDialogue/QD = CreateDialogue()

	QD.Text = "Saved"

	Config.Events.Dialogue(QD)