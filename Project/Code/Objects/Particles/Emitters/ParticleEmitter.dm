obj/Machinery/ParticleEmitter

obj/Machinery/ParticleEmitter/SlowTick()
	return

obj/Machinery/ParticleEmitter/proc/EmitParticle(var/Controller, var/IgnoreScreenCheck)
	if(IgnoreScreenCheck || IsOnScreen(1))
		var/obj/Runtime/Particle/P = Config.Particles.GetParticle()
		P.Instantiate(Config.Particles.Brains[Controller])
		P.WarpTo(src)