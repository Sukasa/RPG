/mob/Soldier/bot
	name = "Test bot"

	var/shoot = 0
	var/move = 0
	var/TagA = "A"
	var/TagB = "B"

/mob/Soldier/bot/SlowTick()
	..()

	if(shoot)
		if(prob(3))
			for(var/mob/Soldier/S in view(src))
				if(S.client)
					var/obj/Item/Ranged/gun = SelectedItem()
					gun.Shoot(S)


	if(move)
		if(src in range(locate(TagA),2))
			Destination = new /datum/Point(locate("B"))
		else if(src in range(locate(TagB),2))
			Destination = new /datum/Point(locate("A"))
