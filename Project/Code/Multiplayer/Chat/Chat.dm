/mob/verb/Say(var/Text as text)
	if (findtext(Text, "/", 1, 2))
		var/Space = findtext(Text, " ", 2)
		var/Command = lowertext(copytext(Text, 2, Space))
		if (Config.Commands.IsValidCommand(Command))
			Config.Commands.Execute(src, Command, copytext(Text, Space + 1))
		else
			SendUser("\red Command [Command] not found")
	else
		Say("/say " + Text)

/proc/Broadcast(var/Text as text, var/Channel = ChannelAll)
	for(var/mob/M in world)
		if (!M.client)
			continue
		if (M.SubscribedChannels & Channel)
			M.client.Send(Text)

/proc/DebugText(var/Text as text)
#ifdef DEBUG
	Broadcast("\green" + Text, ChannelDebug)
#endif

/proc/InfoText(var/Text as text)
	Broadcast("\cyan" + Text, ChannelInfo)

/proc/GameText(var/Text as text)
	Broadcast("\white" + Text, ChannelGame)

proc/SendUser(var/mob/User = usr, var/Text)
	if (istext(User))
		Text = User
		User = usr
	if (User && User.client)
		User.client.Send(Text)