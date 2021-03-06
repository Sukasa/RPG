/mob/Soldier
	name = "Soldier"
	icon = 'PlayerMale.dmi'
	icon_state = "Stand"

	bound_width = 21
	bound_height = 28
	bound_x = 14
	//bound_y = 12

	// Should probably make these fit the coding style
	var/dmg_major = 0
	var/dmg_minor = 0
	var/dmg_blood = 100
	var/RecoveryTimeout = 120
	var/sound/PlayingSound

/mob/Soldier/New()
	..()
	Stats = new/MobStats/PlayerStats()
	ScriptVariables["player"] = src

/mob/Soldier/Respawn()
	..()
	dmg_major = initial(dmg_major)
	dmg_minor = initial(dmg_minor)
	dmg_blood = initial(dmg_blood)

/mob/Soldier/FastTick()
	..()
	var/SetDir = 0
	if (client && !FreezeTime && !client.KeyboardHandler && client.EnableKeyboardMovement && !Config.InputSuspended)

		if (!StunTime)
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

		if (SetDir)
			icon_state = "Walk"
			dir = SetDir
		else
			icon_state = "Stand"

		if (client.Pressed[Config.CommandKeys[ButtonInteract]])
			Use()