
/obj/Item/ranged/
	name = "Ranged item"
	UseOnSelf = FALSE

/obj/Item/ranged/proc/Shoot(var/atom/Target)


	//Shooting a mob works in an interesting way.  There are three checks needed before a mob is shot:
	//First, a raycast is done.  If the ray terminates within 1 block of the target (i.e. either hitting them or their cover),
	//the raycast check passes and the cover check is done

	//The cover check gets the target's cover value, determined by their immediate surroundings and the angle of incidence
	//plus any penalties.  If prob() on the result passes, the cover check succeeds

	//Lastly, a prob() on the weapon spread is conducted.  If THAT passes, the bullet hit the target.

	//Depending on the cover value, the target either takes a glancing blow, a major blow, or is just stunned from a very near miss.



	//TODO initial raycast

	var/atom/owner = Owner()

	if(!Target.CanTarget)
		world << "Random gunshot"
		return

	if(!owner)
		return

	if(istype(Target,/mob))
		var/mob/mTarget = Target

		var/list/CoverInfo = mTarget.GetCover()
		var/Angle = mTarget.GetAngleTo(src)

		var/AngleIndex = Angle2Index(Angle, CardinalAngles8)

		Angle = (Angle % 45) / 45 //We don't need the firing angle anymore, so reuse the var as the interpolation factor

		var/CoverValue = (CoverInfo[AngleIndex] * (1 - Angle)) + (CoverInfo[AngleIndex + 1] * Angle)

		//Do cover penalties here

		var/strike = prob(100-CoverValue)

		if (strike)
			world << "Target hit"
			src.Hit_Ranged(Target,rand(0,(100-CoverValue)))

		//TODO spread check

	return


/obj/Item/ranged/proc/Hit_Ranged(var/atom/Target,var/hit_severity)
	return


/obj/Item/ranged/stunner
	name = "Stun projecter"
	icon = 'gun.dmi'
	icon_state = "ionrifle"

/obj/Item/ranged/stunner/Hit_Ranged(var/atom/Target,var/hit_severity)
	world << "Hit_ranged"
	if(istype(Target,/mob))
		var/mob/mob = Target
		world << "Target is a mob"
		mob.Stun(hit_severity*5)