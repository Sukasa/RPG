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

/mob/Soldier/Attack(var/datum/Mouse/Mouse, var/ForceAttack)

	var/obj/Item/item = src.SelectedItem()

	if(!item)
		return

	if(istype(item,/obj/Item/ranged))
		var/obj/Item/ranged/gun = item

		if ((src == Mouse.Highlighted && !item.UseOnSelf) || !IsMovable(Mouse.Highlighted))
			return //No shooting yourself!

		world << "[src] shoots at \icon [Mouse.Highlighted][Mouse.Highlighted]!"
		gun.Shoot(Mouse.Highlighted)

/mob/Soldier/Stun(var/severity)
	stunned = min(1000,stunned+severity)
	world << "[src] got hit by a stunner and is now stunned for [stunned]"
	flash_screen()


/mob/Soldier/New()
	..()
	var/obj/Item/ranged/stunner/stungun = new(src)
	Grab_Item(stungun, 1)
	SetCursor('TargetRed.dmi')
	SetClientCursor(src, 'TargetInvalid.dmi')
	spawn(0)
		if (client && client.HUD)
			client.HUD.Update()


/mob/Soldier/FastTick()
	..()
	stunned = max(stunned-2,0)



/mob/Soldier/SlowTick()
	if(client && stunned) //DEBUG!
		client << "Stunned for [stunned]"

	..()