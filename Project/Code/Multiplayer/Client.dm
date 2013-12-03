client
	show_popup_menus = FALSE
	control_freak = TRUE
	perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE

	var
		obj/Runtime/Chatbox/Chatbox = new()
		HUD/HUD
		obj/Runtime/Flash/Flash = new()


		list/Keys = list( )
		list/Pressed = list( )
		Queue/QueuedDialogue = new()

		EnableMouse = FALSE
		EnableCursor = FALSE

		EnableKeyboard = TRUE
		EnableKeyboardMovement = TRUE

		KeyboardHandler = null


/client/proc/Send(var/Text)
	ASSERT(Chatbox)
	Chatbox.WriteLine(Text)

/client/Del()
	Config.Clients -= src
	..()

/client/New()
	Config.Clients += src
	if (!Debug)
		winset(src, "mainsplitter", "splitter=100;lock=true;show-splitter=false;height=625")
		winset(src, "input1", "is-visible=0")

	Flash.Init(src)

	if (Ticker.AllowJoin()) // Either late join & allowed, or no round in effect
		// Either reconnect the client to their mob, or create a new one

		..()  //Standard mob creation: Soldier; name and gender set to BYOND user info
		//HUD = new/obj/Runtime/HUD/HUDController/SoldierHUD(src)
	else
		// Create as spectator - The round is already going and doesn't allow late (re)joins.
		var/mob/Spectator/S = new()
		S.name = key
		mob = S

	// Init UI
	screen += Chatbox

	if (EnableKeyboard)
		InitializeKeyboardMacros()

	// Set Mob team, if appropriate
	if (istype(usr, /mob/Spectator))
		Config.Teams[TeamSpectators] += usr

	Ticker.Mode.OnPlayerJoin(mob)

	HUD = new/HUD()
	HUD.AttachedMob = mob

	// Set mob position
	mob.Respawn()


//*************************************
//*
//*			Keyboard Handling
//*
//*	  Initializes macros and provides
//*      a default keyboard handler
//*
//*************************************

/client/proc/ClearKeys()
	for (var/K in Keys)
		Keys[K] = KeyStateUp

/client/proc/GetKeyboardHandler()
	if (KeyboardHandler != null)
		return KeyboardHandler
	return src

/client/proc/KeyUp(K)
	Keys[K] = KeyStateUp

/client/proc/KeyDown(K)
	Keys[K] = (Keys[K] | KeyStatePressed) || KeyStatePressed

/client/proc/KeyTick()
	Pressed = list( )
	for (var/K in Keys)
		if (Keys[K] == KeyStatePressed)
			Pressed[K] = TRUE
			Keys[K] |= KeyStateDepressed


/client/proc/ButtonPressed(var/Button)
	return Keys[Config.CommandKeys[Button]]

/client/proc/InitializeKeyboardMacros()
	for(var/k in list("0","1","2","3","4","5","6","7","8","9","Q","W","E","R","T","Y","U","I","O","P","A","S","D","F",
					  "G","H","J","K","L","Z","X","C","V","B","N","M","West","East","North","South","Northeast",
					  "Northwest","Southeast","Southwest","Space","Shift","Ctrl","Alt","Escape","Return","Center",
					  "Tab","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12",".",",","`","\[","\]",
					  ";","'","/", "\\\\","-","=","Multiply","Divide","Subtract","Add","Numpad0","Numpad1","Numpad2",
					  "Numpad3","Numpad4","Numpad5","Numpad6","Numpad7","Numpad8","Numpad9","Decimal","Insert",
					  "Delete","Back","Apps","Pause"))

		winset(src, "[k]", "parent=Macros;name=\"[k]\";command=\"Say /keydown [k]\"")
		winset(src, "[k]UP", "parent=Macros;name=\"[k]+UP\";command=\"Say /keyup [k]\"")