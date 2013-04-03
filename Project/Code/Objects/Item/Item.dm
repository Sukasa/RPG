//An Item, able to be picked up. Similar to SS13's item system, but designed to be easier to use.

/obj/Item
	var/Size = SizeMedium
	var/BaseDamage = 2
	var/BaseDamageType = DamageTypeBlunt
	var/MinRange = 0
	var/MaxRange = 1.1
	var/Targets = TargetMap
	var/BypassCover = TRUE //Melee weapons ignore cover

/obj/Item/proc/TargetCursor(var/atom/Target)
	if (istype(Target, /obj/Runtime/HUD))
		return null
	if (!IsMovable(Target))
		return null
	if (CanTarget(Target))
		return CursorObject.icon
	return GetCursor(CursorInvalid)

/obj/Item/proc/CanTarget(var/atom/Target)
	if (!IsMovable(Target))
		return FALSE

	if (ismob(Target))
		var/mob/Owner = Owner()
		var/mob/TargetMob = Target
		if (TargetMob.Team == Owner.Team)
			return Targets & TargetAllies
		if (TargetMob.Team != Owner.Team)
			return Targets & TargetEnemies

	if (IsObj(Target))
		if (!(Targets & TargetTerrain))
			return FALSE

	var/Dist = GetDistanceTo(Target)
	return Dist >= MinRange && Dist <= MaxRange

/obj/Item/proc/Owner()
	return loc

/obj/Item/proc/AttackTarget(var/atom/Target)
	return

/obj/Item/Interact(var/mob/User)
	User.GrabItem(src)
	return TRUE