/obj/Item/tank
	name = "Oxygen tank"
	icon = 'tank.dmi'
	icon_state = "oxygen"

	BaseDamage = 10


/obj/Item/canister
	name = "Gas canister"
	icon = 'tank.dmi'
	icon_state = "canister"
	BaseDamage = 3


/obj/Item/medkit
	name = "Medkit"
	icon = 'storage.dmi'
	icon_state = "firstaid"
	BaseDamage = -50
	Targets = TargetAllies
	AttackTarget(var/atom/Target)
		if(istype(Target,/mob))
			var/mob/mTarget = Target
			mTarget.stunned = 0