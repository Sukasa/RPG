obj/Machinery/ParticleEmitter/GentleSmoke
	var
		Emit = FALSE
	step_y = 16

	SlowTick()
		Emit = !Emit
		if (Emit)
			EmitParticle(/ParticleBrain/GentleSmoke, TRUE)