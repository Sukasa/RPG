obj/Machinery/ParticleEmitter/GentleSmoke
	var
		Emit = FALSE
	step_y = 16

	SlowTick()
		Emit = (Emit + 1) % 4
		if (!Emit)
			EmitParticle(/ParticleBrain/GentleSmoke, TRUE)