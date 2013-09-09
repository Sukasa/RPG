/datum/Menu

	var

		list/StaticElements = list( )
		list/DynamicElements = list( )

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
	// Implemented by child classes

/datum/Menu/proc/Tick()
	// Implemented by child classes

/datum/Menu/proc/DeInit()
	// Implemented by child classes


//
// Utility Functions
//

/datum/Menu/proc/ClearDynamicElements()
	for (var/atom/A in DynamicElements)
		del A
	DynamicElements = list( )


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
	if (Key == "north")
		Input(ControlUp + Modifier)
	if (Key == "south")
		Input(ControlDown + Modifier)
	if (Key == "west")
		Input(ControlLeft + Modifier)
	if (Key == "east")
		Input(ControlRight + Modifier)
	if (Key == "return")
		Input(ControlEnter + Modifier)
	if (Key == "escape")
		Input(ControlEscape + Modifier)

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