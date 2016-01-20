ParticleBrain/GentleSmoke
	Think(var/obj/Runtime/Particle/Particle)
		Particle.MoveBy((((Particle.Age * 2) + Particle.Lifetime) / Particle.Lifetime) * cos(Particle.Age * 4 + Particle.ExtraData) / 2 + (Particle.Age / (4 * Particle.Lifetime)), 0.3)
		if (Particle.Lifetime - Particle.Age < world.fps)
			Particle.alpha = 255 * ((Particle.Lifetime - Particle.Age) / world.fps);

	Init(var/obj/Runtime/Particle/Particle)
		Particle.icon_state = "smokepuff"
		Particle.layer += 0.5
		Particle.Lifetime = world.fps * 9
		Particle.ExtraData = rand(0, 360)