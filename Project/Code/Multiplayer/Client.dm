client
	show_popup_menus = FALSE
	var
		obj/Runtime/Chatbox/Chatbox = new()
		obj/Runtime/HUD/HUDController/HUD

		list/Keys = list( )
		list/Pressed = list( )

		EnableMouse = FALSE
		EnableCursor = FALSE

		EnableKeyboard = TRUE
		EnableKeyboardMovement = TRUE

		KeyboardHandler = null

/client/proc/Send(var/Text)
	ASSERT(Chatbox)
	Chatbox.WriteLine(Text)

/client/New()
	if (Ticker.AllowJoin()) // Either late join & allowed, or no round in effect
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

	if (EnableKeyboard)
		InitializeKeyboardMacros()

	if (HUD)
		HUD.Initialize()

	// Set Mob team, if appropriate
	if (istype(usr, /mob/Spectator))
		Config.Teams[TeamSpectators] += usr

	Ticker.Mode.OnPlayerJoin(mob)

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

/client/proc/GetKeyboardHandler()
	return KeyboardHandler || src

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
	for(var/k in list("0","1","2","3","4","5","6","7","8","9","q","w","e","r","t","y","u","i","o","p","a","s","d","f",
					  "g","h","j","k","l","z","x","c","v","b","n","m","west","east","north","south","northeast",
					  "northwest","southeast","southwest","space","shift","ctrl","alt","escape","return","center",
					  "tab","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12",))

		winset(src, "[k]", "parent=Macros;name=[k];command=Say+/keydown+[k]")
		winset(src, "[k]UP", "parent=Macros;name=[k]+UP;command=Say+/keyup+[k]")