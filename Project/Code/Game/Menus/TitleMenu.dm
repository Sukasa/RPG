/datum/Menu/TitleScreen
	var
		EnterState = 0

/datum/Menu/TitleScreen/Input(var/Control)
	if (Control == ControlEnter)
		EnterState |= 1

/datum/Menu/TitleScreen/Tick()
	if (EnterState)
		EnterState++
	if (EnterState == 15)
		return //TODO: Change to second menu