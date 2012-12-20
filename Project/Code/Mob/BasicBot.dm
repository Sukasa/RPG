/mob/Soldier/bot
	name = "Test bot"

	var/shoot = 0
	var/move = 0
	var/TagA = "A"
	var/TagB = "B"

/mob/Soldier/bot/SlowTick()
	..()

	if(shoot)
		//world << "boop"
		if(prob(10))
			for(var/mob/Soldier/S in view(src))
				if(S.client)
					world << "Target [S]"
					var/obj/Item/ranged/gun = SelectedItem()
					gun.Shoot(S)


	if(move)

		if(src.loc in range(locate(TagA),2))

			src.Destination = new /datum/Point(locate("B"))

		else if(src.loc in range(locate(TagB),2))

			src.Destination = new /datum/Point(locate("A"))
