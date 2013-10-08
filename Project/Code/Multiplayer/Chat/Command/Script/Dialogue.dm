/ChatCommand/QueueDialogue
	Command = "queuedialogue"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/QueueDialogue/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)
	if (Params.len < 1)
		ErrorText("Not enough parameters to /queuedialogue \[[CommandText]]")
		return
	var/QueuedDialogue/QD = new()
	QD.Text = Params[1]
	if (Params.len > 1)
		QD.Name = Params[2]

	Config.Events.Dialogue(Player, QD)

/ChatCommand/QueuePrompt
	Command = "queueprompt"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/QueuePrompt/Execute(var/mob/Player, var/CommandText)
	var/list/Params = ParamList(CommandText)
	if (Params.len < 3)
		ErrorText("Not enough parameters to /queueprompt \[[CommandText]]")
		return
	var/QueuedDialogue/QD = new()
	QD.Text = Params[1]
	QD.ScriptYes = Params[2]
	QD.ScriptNo = Params[3]
	if (Params.len > 3)
		QD.Name = Params[4]

	Config.Events.Dialogue(Player, QD)

/ChatCommand/WaitDialogue
	Command = "waitdialogue"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/WaitDialogue/Execute(var/mob/Player, var/CommandText)
	while (istype(Config.Menus.CurrentMenus[Player], /Menu/Dialogue))
		sleep(1)