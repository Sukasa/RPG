/datum/Menu

	var

		list/StaticElements = list( )
		list/DynamicElements = list( )
		client/Client = null

		const
			ControlUp = 1
			ControlDown = 2
			ControlLeft = 3
			ControlRight = 4
			ControlEnter = 5
			ControlEscape = 6
			ControlReleased = 16

//
// Processing
//

/datum/Menu/proc/Init()
	Show()

/datum/Menu/proc/Tick()
	// Implemented by child classes

/datum/Menu/proc/DeInit()
	Hide()
	ClearDynamicElements()
	ClearStaticElements()

/datum/Menu/proc/Hide()
	for(var/atom/A in DynamicElements)
		A.invisibility = 101
	for(var/atom/A in StaticElements)
		A.invisibility = 101

	Client.KeyboardHandler = null

/datum/Menu/proc/Show()
	for(var/atom/A in DynamicElements)
		A.invisibility = 0
		Client.screen |= A
	for(var/atom/A in StaticElements)
		A.invisibility = 0
		Client.screen |= A

	Client.KeyboardHandler = src



//
// Utility Functions
//

/datum/Menu/proc/ShowElementToClients(var/Element)
	Client.screen += Element

/datum/Menu/proc/ClearDynamicElements()
	for (var/atom/A in DynamicElements)
		del A
	DynamicElements = list( )

/datum/Menu/proc/ClearStaticElements()
	for (var/atom/A in StaticElements)
		del A
	StaticElements = list( )


//
// Input Handling
//

/datum/Menu/proc/Input(var/Input)
	// Implemented by child classes


//
// Keyboard Handling
//

/datum/Menu/proc/KeyChange(var/Key, var/Modifier = 0)

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

/datum/Menu/proc/KeyUp(var/Key)
	KeyChange(Key, ControlReleased)

/datum/Menu/proc/KeyDown(var/Key)
	KeyChange(Key)