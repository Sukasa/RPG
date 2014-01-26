/Menu

	var

		list/StaticElements = list( )
		list/DynamicElements = list( )
		list/PersistentElements = list( )
		client/Client = null
		mob/Player = null

		Terminated = FALSE

//
// Processing
//

/Menu/New(var/list/Params)
	..()

/Menu/proc/Init()
	Show()

/Menu/proc/Tick()
	// Implemented by child classes

/Menu/proc/DeInit()
	Hide()
	ClearDynamicElements()
	ClearStaticElements()

/Menu/proc/Hide()
	for(var/atom/A in DynamicElements | StaticElements | PersistentElements)
		A.invisibility = Invisible

	Client.KeyboardHandler = null

/Menu/proc/Show()
	for(var/atom/A in DynamicElements | StaticElements | PersistentElements)
		A.invisibility = Visible
		Client.screen |= A

	Client.KeyboardHandler = src
	Client.ClearKeys()

/Menu/proc/FadeOut(var/Time = 8)
	for(var/atom/A in DynamicElements | StaticElements | PersistentElements)
		animate(A, color = ColorBlack, time = Time)
	sleep(Time)

//
// Utility Functions
//

/Menu/proc/ExitMenu()
	Config.Menus.PopMenu(Client)

/Menu/proc/ShowElementToClient(var/Element)
	Client.screen += Element

/Menu/proc/ClearDynamicElements()
	for (var/atom/A in DynamicElements)
		del A
	DynamicElements = list( )

/Menu/proc/ClearStaticElements()
	for (var/atom/A in StaticElements)
		del A
	StaticElements = list( )


//
// Input Handling
//

/Menu/proc/Input(var/Input)
	// Implemented by child classes


//
// Keyboard Handling
//

/Menu/proc/KeyChange(var/Key, var/Modifier = 0)

	// Enforce a standard set of menu controls...
	if (Key == "North")
		Input(ControlUp + Modifier)
		return
	if (Key == "South")
		Input(ControlDown + Modifier)
		return
	if (Key == "West")
		Input(ControlLeft + Modifier)
		return
	if (Key == "East")
		Input(ControlRight + Modifier)
		return
	if (Key == "Return")
		Input(ControlEnter + Modifier)
		return
	if (Key == "Escape")
		Input(ControlEscape + Modifier)
		return

	// ... before using the customized key set
	if (Key == Config.CommandKeys[ButtonNorth])
		Input(ControlUp + Modifier)
	if (Key == Config.CommandKeys[ButtonSouth])
		Input(ControlDown + Modifier)
	if (Key == Config.CommandKeys[ButtonWest])
		Input(ControlLeft + Modifier)
	if (Key == Config.CommandKeys[ButtonEast])
		Input(ControlRight + Modifier)
	if (Key == Config.CommandKeys[ButtonUse] || Key == Config.CommandKeys[ButtonInteract])
		Input(ControlEnter + Modifier)
	if (Key == Config.CommandKeys[ButtonMenu])
		Input(ControlEscape + Modifier)

/Menu/proc/KeyUp(var/Key)
	KeyChange(Key, ControlReleased)

/Menu/proc/KeyDown(var/Key)
	KeyChange(Key)