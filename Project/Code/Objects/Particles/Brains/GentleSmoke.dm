ParticleBrain/GentleSmoke
	Think(var/obj/Runtime/Particle/Particle)
		var/X = min((Particle.Age / Particle.Lifetime), 0.75) * sin(world.time)
		Particle.MoveBy(0.1, 0.3)
		if (Particle.Lifetime - Particle.Age < world.fps)
			Particle.alpha = 255 * ((Particle.Lifetime - Particle.Age) / world.fps);
		//world.log << "\ref[Particle] [Particle.step_x + Particle.SubStepX], [Particle.step_y + Particle.SubStepY]"

	Init(var/obj/Runtime/Particle/Particle)
		Particle.icon_state = "smokepoly"
		Particle.layer += 0.5
		Particle.Lifetime = world.fps * 9
		Particle.ExtraData = rand(-180, 180) / 3600