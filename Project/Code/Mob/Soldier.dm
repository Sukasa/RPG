mob/Soldier
	name = "Soldier"
	icon = 'Human.dmi'
	icon_state = "man"

	bound_width = 12
	bound_height = 27


	var/dmg_major = 0
	var/dmg_minor = 0
	var/dmg_blood = 100






/*
mob/Soldier/proc/Shoot(var/mob/Target)

	//Shooting a mob works in an interesting way.  There are three checks needed before a mob is shot:
	//First, a raycast is done.  If the ray terminates within 1 block of the target (i.e. either hitting them or their cover),
	//the raycast check passes and the cover check is done

	//The cover check gets the target's cover value, determined by their immediate surroundings and the angle of incidence
	//plus any penalties.  If prob() on the result passes, the cover check succeeds

	//Lastly, a prob() on the weapon spread is conducted.  If THAT passes, the bullet hit the target.

	//Depending on the cover value, the target either takes a glancing blow, a major blow, or is just stunned from a very near miss.



	//TODO initial raycast


	var/list/CoverInfo = Target.GetCover()
	var/Angle = Target.GetAngleTo(src)

	var/AngleIndex = Angle2Index(Angle, CardinalAngles8)

	Angle = (Angle % 45) / 45 //We don't need the firing angle anymore, so reuse the var as the interpolation factor

	var/CoverValue = (CoverInfo[AngleIndex] * (1 - Angle)) + (CoverInfo[AngleIndex + 1] * Angle)

	//Do cover penalties here

	if (prob(100 - CoverValue))
		world << "The shot connects!"

	//TODO spread check

	return
*/

/mob/Soldier/Attack(var/datum/Mouse/Mouse)

	var/obj/item/item = src.SelectedItem()
	if(!item)
		return


	if(istype(item,/obj/item/ranged))
		var/obj/item/ranged/gun = item

		if (src == Mouse.Highlighted || !IsMovable(Mouse.Highlighted))
			return //No shooting yourself!

		world << "[src] shoots at \icon [Mouse.Highlighted][Mouse.Highlighted]!"
		gun.Shoot(Mouse.Highlighted)

/mob/Soldier/Stun(var/severity)
	stunned = min(1000,stunned+severity)
	world << "[src] got hit by a stunner and is now stunned for [stunned]"
	flash_screen()


/mob/Soldier/New()
	..()
	var/obj/item/ranged/stunner/stungun = new /obj/item/ranged/stunner(src)
	Grab_Item(stungun,1)


/mob/Soldier/FastTick()
	..()
	stunned = max(stunned-2,0)



/mob/Soldier/SlowTick()
	if(client) //DEBUG!
		world << "Stunned for [stunned]"

	..()