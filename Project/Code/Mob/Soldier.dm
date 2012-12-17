mob/Soldier
	name = "Soldier"



mob/Soldier/proc/Shoot(var/mob/Target)

	//Shooting a mob works in an interesting way.  First, a cover check is done.  If the mob is not in cover, or their cover value wasn't enough,
	//Then the cover check passes.  Then a check is done for weapon accuracy, and there is a chance of missing there.
	//The reason we do the accuracy check second is so that when dealing with someone at an awkward angle around a corner,
	//There is still a chance that they can be hit via the cover mechanic.  The accuracy mechanic would require a raycast if we did it first,
	//And that wouldn't mesh well with how BYOND's tiling and movement mechanics work.

	//Effectively, our solution solves our technical problems and makes for intuitive and understandable gameplay mechanics.

	var/list/CoverInfo = Target.GetCover()
	var/Angle = Target.GetAngleTo(src)
	var/AngleIndex = CoverIndexFromAngles(Angle, CardinalAngles8)

	Angle = (Angle % 45) / 45 //We don't need the firing angle anymore, so reuse the var as the interpolation factor

	var/CoverValue = (CoverInfo[AngleIndex] * (1 - Angle)) + (CoverInfo[AngleIndex + 1] * Angle)

	//Do cover penalties here

	if (prob(100 - CoverValue))
		world << "HIT!"

	return