/mob/verb/Say(var/Text as text)
	if (findtext(Text, "/", 1, 2))
		var/Space = findtext(Text, " ", 2)
		var/Command = lowertext(copytext(Text, 2, Space))
		if (Config.Commands.IsValidCommand(Command))
			Config.Commands.Execute(src, Command, copytext(Text, Space + 1))
		else if (Command in Ticker.Mode.Commands)
			Ticker.Mode.Command(src, Command, copytext(Text, Space + 1))
		else
			SendUser("\red Command [Command] not found")
	else
		Say("/say " + Text)

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

proc/SendUser(var/mob/User = usr, var/Text)
	if (istext(User))
		Text = User
		User = usr
	if (User && User.client)
		User.client.Send(Text)