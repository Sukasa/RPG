mob/Soldier
	name = "Soldier"
	icon = 'Human.dmi'
	icon_state = "man"

	bound_width = 12
	bound_height = 12

	// Should probably make these fit the coding style
	var/dmg_major = 0
	var/dmg_minor = 0
	var/dmg_blood = 100
	var/RecoveryTimeout = 120

/mob/Soldier/New()
	..()
	Stats = new/MobStats/PlayerStats()

/mob/Soldier/Respawn()
	..()
	dmg_major = initial(dmg_major)
	dmg_minor = initial(dmg_minor)
	dmg_blood = initial(dmg_blood)

/mob/Soldier/FastTick()
	..()
	var/SetDir = 0
	if (client && !client.KeyboardHandler && client.EnableKeyboardMovement && !Config.InputSuspended)

		if (client.Keys[Config.CommandKeys[ButtonSouth]] || client.Keys["South"])
			step(src, SOUTH, MoveSpeed())
			SetDir |= SOUTH

		if (client.Keys[Config.CommandKeys[ButtonEast]] || client.Keys["East"])
			step(src, EAST, MoveSpeed())
			SetDir |= EAST

		if (client.Keys[Config.CommandKeys[ButtonWest]] || client.Keys["West"])
			step(src, WEST, MoveSpeed())
			SetDir |= WEST

		if (client.Keys[Config.CommandKeys[ButtonNorth]] || client.Keys["North"])
			step(src, NORTH, MoveSpeed())
			SetDir |= NORTH

		if (SetDir && client.Keys["Shift"] && Stats.Stamina > 0)
			Stats.Stamina--
			RecoveryTimeout = initial(RecoveryTimeout)
		else if (!client.Keys["Shift"] && Stats.Stamina < Stats.MaxStamina && (RecoveryTimeout-- <= 0))
			Stats.Stamina++

		dir = SetDir

		if (client.Pressed[Config.CommandKeys[ButtonInteract]])
			Use()