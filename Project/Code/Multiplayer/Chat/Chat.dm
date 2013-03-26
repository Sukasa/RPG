/mob/verb/Say(var/Text as text)
	if (findtext(Text, "/me", 1, 4))
		Text = "\magenta * [name] [copytext(Text, 4)]"
	else
		Text = "<[name]> [Text]"
	Broadcast(Text, client.BroadcastChannels)

/proc/Broadcast(var/Text as text, var/Channel = ChannelAll)
	for(var/mob/M in world)
		if (!M.client)
			continue
		var/client/C = M.client
		if (C.SubscribedChannels & Channel)
			C.Chatbox.WriteLine(Text)

/proc/DebugText(var/Text as text)
	#ifdef DEBUG
	Broadcast(Text, ChannelDebug)
	#endif

/proc/InfoText(var/Text as text)
	Broadcast(Text, ChannelInfo)

/proc/GameText(var/Text as text)
	Broadcast(Text, ChannelGame)