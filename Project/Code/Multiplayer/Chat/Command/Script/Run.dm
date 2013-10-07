/ChatCommand/Run
	Command = "run"
	MinPowerLevel = RankProgrammer

/ChatCommand/Run/Execute(var/mob/Player, var/CommandText)
	// Get script

	var/StreamReader/Reader = new(Config.Events.GetScript(CommandText) || CommandText)
	Reader.StripCarriageReturns()

	// Loop through each line, executing it as you go
	while (!Reader.EOF())
		var/ScriptCommand = Reader.TakeUntil(Space, LineFeed)
		if (!lentext(ScriptCommand))
			Reader.Advance()
			continue
		if (Reader.EOF() || Reader.Char() == LineFeed)
			Config.Commands.Execute(Player, ScriptCommand)
		else
			Reader.Advance()
			var/ScriptCommandText = Reader.TakeUntil(LineFeed)
			Config.Commands.Execute(Player, ScriptCommand, ScriptCommandText)
		Reader.Advance()

/ChatCommand/RunAs
	Command = "as"
	MinPowerLevel = RankScriptsOnly

/ChatCommand/RunAs/Execute(var/mob/Player, var/CommandText)
	var/Space = findtext(CommandText, " ")
	var/RunAs = Config.Clients[text2num(copytext(CommandText, 1, Space))]
	RunAs = RunAs:mob
	var/LSpace = Space
	Space = findtext(CommandText, " ", Space + 1)
	var/Command = copytext(CommandText, LSpace + 1, Space)
	Config.Commands.Execute(RunAs, Command, copytext(CommandText, Space + 1))