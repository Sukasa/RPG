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

/mob/Soldier/Respawn()
	..()
	dmg_major = initial(dmg_major)
	dmg_minor = initial(dmg_minor)
	dmg_blood = initial(dmg_blood)

/mob/Soldier/Stun(var/severity)
	stunned = min(1000,stunned+severity)
	world << "[src] got hit by a stunner and is now stunned for [stunned]"
	flash_screen()


/mob/Soldier/New()
	..()
	spawn(0)
		if (client && client.HUD)
			client.HUD.Update()

/mob/Soldier/FastTick()
	..()
	stunned = max(stunned-2,0)
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

		dir = SetDir

		if (client.Pressed[Config.CommandKeys[ButtonInteract]])
			Use()


/mob/Soldier/SlowTick()
	if(client && stunned) //DEBUG!
		client << "Stunned for [stunned]"

	..()