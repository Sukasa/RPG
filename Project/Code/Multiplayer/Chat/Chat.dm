/mob/verb/Say(var/Text as text)
	world.log << "SAY"
	if (findtext(Text, "/", 1, 2))
		var/Parser/Parser = new()

		Parser.Functions = ScriptFunctions
		Parser.Constants = ScriptConstants

		world.log << "Parsing text [Text]"

		var/ASTNode/Node = Parser.ParseLine(Text)

		world.log << "Executing Node [Node]"

		if (Node)
			Node.Context = new /ScriptExecutionContext()
			Node.Execute()
	else
		Broadcast(Text)


/mob/verb/KeyDown(var/Key as text)
	var/Handler = client.GetKeyboardHandler()
	Handler:KeyDown(Key, src)


/mob/verb/KeyUp(var/Key as text)
	var/Handler = client.GetKeyboardHandler()
	Handler:KeyUp(Key, src)


/proc/Broadcast(var/Text as text, var/Channel = -1)
	if (Channel == -1)
		Channel = Debug ? ChannelAll : usr.BroadcastChannels | Config.RankChannels[usr.Rank] | (Config.Alltalk ? ChannelAllChat : Config.TxTeamChannels[usr.Team] )
	for(var/mob/M in world)
		if (!M.client)
			continue
		if ((M.SubscribedChannels | Config.RankChannels[M.Rank] | Config.RxTeamChannels[M.Team]) & Channel)
			M.client.Send(Text)


/proc/DebugText(var/Text as text)
#ifdef DEBUG
	Broadcast("\green[Text]", ChannelDebug)
	world.log << Text
#endif


/proc/ErrorText(var/Text as text)
#ifdef DEBUG
	Broadcast("\red[Text]", ChannelDebug)
	world.log << Text
#endif


/proc/InfoText(var/Text as text)
	Broadcast("\cyan[Text]", ChannelInfo)
	world.log << Text


/proc/AdminText(var/Text as text)
	Broadcast("\cyan[Text]", ChannelAdmin)
	world.log << Text


/proc/GameText(var/Text as text)
	Broadcast("\white[Text]", ChannelGame)
	world.log << Text


/proc/SendUser(var/mob/User = usr, var/Text)
	if (istext(User))
		Text = User
		User = usr
	if (User && User.client)
		User.client.Send(Text)