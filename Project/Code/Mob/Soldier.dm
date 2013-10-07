mob/Soldier
	name = "Soldier"
	icon = 'Human.dmi'
	icon_state = "man"

	bound_width = 12
	bound_height = 12
	bound_x = 10
	bound_y = 10

	// Should probably make these fit the coding style
	var/dmg_major = 0
	var/dmg_minor = 0
	var/dmg_blood = 100

/mob/Soldier/Respawn()
	..()
	dmg_major = initial(dmg_major)
	dmg_minor = initial(dmg_minor)
	dmg_blood = initial(dmg_blood)


/mob/Soldier/Interact(var/datum/Mouse/Mouse, var/ForceAttack)
	if (!ForceAttack && IsObj(Mouse.Highlighted) && Mouse.Highlighted.UserInRange())
		var/obj/A = Mouse.Highlighted
		if (!A.Interact(src))
			UseItem(Mouse)
	else
		UseItem(Mouse)


/mob/Soldier/proc/UseItem(var/datum/Mouse/Mouse)
	var/obj/Item/SelectedItem = src.SelectedItem()

	if(!SelectedItem)
		return

	if (!SelectedItem.CanTarget(Mouse.Highlighted))
		return

	SelectedItem.AttackTarget(Mouse.Highlighted)


/mob/Soldier/Stun(var/severity)
	stunned = min(1000,stunned+severity)
	world << "[src] got hit by a stunner and is now stunned for [stunned]"
	flash_screen()


/mob/Soldier/New()
	..()
	var/obj/Item/Ranged/Stunner/stungun = new(src)
	GrabItem(stungun, 1)
	spawn(0)
		if (client && client.HUD)
			client.HUD.Update()

/mob/Soldier/FastTick()
	..()
	stunned = max(stunned-2,0)
	if (client && client.EnableKeyboardMovement && !Config.InputSuspended)
		if (client.Keys["S"] || client.Keys["South"])
			step(src, SOUTH, MoveSpeed())
		if (client.Keys["D"] || client.Keys["East"])
			step(src, EAST, MoveSpeed())
		if (client.Keys["A"] || client.Keys["West"])
			step(src, WEST, MoveSpeed())
		if (client.Keys["W"] || client.Keys["North"])
			step(src, NORTH, MoveSpeed())

/mob/Soldier/SlowTick()
	if(client && stunned) //DEBUG!
		client << "Stunned for [stunned]"

	..()