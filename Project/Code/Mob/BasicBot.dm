/mob/Soldier/bot
	name = "Test bot"

	var/shoot = 0
	var/move = 0
	var/TagA = "A"
	var/TagB = "B"

/mob/Soldier/bot/SlowTick()
	..()

	if(move)
		if(src in range(locate(TagA),2))
			Destination = new /Point(locate("B"))
		else if(src in range(locate(TagB),2))
			Destination = new /Point(locate("A"))
