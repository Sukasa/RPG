client
	show_popup_menus = FALSE
	var
		obj/Runtime/Chatbox/Chatbox = new()
		obj/Runtime/HUD/HUDController/HUD

		BroadcastChannels = ChannelAll
		SubscribedChannels = ChannelAll

/client/New()
	if (!Ticker || Ticker.AllowJoin()) // Either late join & allowed, or no round in effect
		// Either reconnect the client to their mob, or create a new one

		..()  //Standard mob creation: Soldier; name and gender set to BYOND user info
		HUD = new/obj/Runtime/HUD/HUDController/SoldierHUD(src)
	else
		// Create as spectator - The round is already going and doesn't allow late (re)joins.
		var/mob/Spectator/S = new()
		S.name = key
		mob = S

	// Init UI
	screen += Chatbox
	if (HUD)
		HUD.Initialize()

	// Set Mob team, if appropriate
	if (istype(usr, /mob/Spectator))
		Teams[TeamSpectators] += usr




	// Set mob position

	src.mob.x = 10
	src.mob.y = 12


/client/Move()
	return
