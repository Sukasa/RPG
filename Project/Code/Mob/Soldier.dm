mob/Soldier
	name = "Soldier"
	icon = 'Human.dmi'
	icon_state = "man"

	bound_width = 12
	bound_height = 27


mob/Soldier/proc/Shoot(var/mob/Target)

	//Shooting a mob works in an interesting way.  There are three checks needed before a mob is shot:
	//First, a raycast is done.  If the ray terminates within 1 block of the target (i.e. either hitting them or their cover),
	//the raycast check passes and the cover check is done

	//The cover check gets the target's cover value, determined by their immediate surroundings and the angle of incidence
	//plus any penalties.  If prob() on the result passes, the cover check succeeds

	//Lastly, a prob() on the weapon spread is conducted.  If THAT passes, the bullet hit the target.

	//Depending on the cover value, the target either takes a glancing blow, a major blow, or is just stunned from a very near miss.

	var/list/CoverInfo = Target.GetCover()
	var/Angle = Target.GetAngleTo(src)

	//world << "Angle is [Angle]"

	var/AngleIndex = Angle2Index(Angle, CardinalAngles8)

	//world << "AngleIndex [AngleIndex] means ref of [CardinalAngles8[AngleIndex]] ([CardinalAngles8[AngleIndex]])"

	Angle = (Angle % 45) / 45 //We don't need the firing angle anymore, so reuse the var as the interpolation factor

	var/CoverValue = (CoverInfo[AngleIndex] * (1 - Angle)) + (CoverInfo[AngleIndex + 1] * Angle)

	//world << "Cover Value: [CoverValue]"

	//Do cover penalties here

	if (prob(100 - CoverValue))
		world << "The shot connects!"

	return


/mob/Soldier/Click()
	if (usr == src)
		return //No shooting yourself!
	world << "[usr] shoots at [src]!"
	if(istype(usr,/mob/Soldier))
		var/mob/Soldier/a = usr
		a.Shoot(src)
