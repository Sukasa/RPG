/mob/verb/Say(var/Text as text)
	Text = "<[name]> [Text]"
	Broadcast(Text, client.BroadcastChannels)

/proc/Broadcast(var/Text as text, var/Channel = ChannelAll)
	for(var/mob/M in world)
		if (!M.client)
			continue
		var/client/C = M.client
		if (C.SubscribedChannels & Channel)
			C.Chatbox.WriteLine(Text)
