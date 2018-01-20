/turf/simulated
	name = "station"
	can_bloody = 1
	var/wet = 0
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/dirt = 0

/turf/simulated/New()
	..()
	levelupdate()

/turf/simulated/Entered(atom/A, atom/OL)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		usr << "\red Movement is admin-disabled." //This is to identify lag problems
		return

	if (istype(A,/mob/living/carbon))
		var/mob/living/carbon/M = A
		if(M.lying)
			..()
			return
		/*
		dirt++
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, src)
		if (dirt >= 50)
			if (!dirtoverlay)
				dirtoverlay = new/obj/effect/decal/cleanable/dirt(src)
				dirtoverlay.alpha = 15
			else if (dirt > 50)
				dirtoverlay.alpha = min(dirtoverlay.alpha+5, 255)
		*/
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			/*
			if(istype(H.shoes, /obj/item/clothing/shoes/clown_shoes))
				var/obj/item/clothing/shoes/clown_shoes/O = H.shoes
				if(H.m_intent == "run")
					if(O.footstep >= 2)
						O.footstep = 0
						playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
					else
						O.footstep++
				else
					playsound(src, "clownstep", 20, 1)
			*/
			// Tracking blood
			var/list/bloodDNA = null
			var/bloodcolor=""
			if(H.shoes)
				var/obj/item/clothing/shoes/S = H.shoes
				if(S.track_blood && S.blood_DNA)
					bloodDNA = S.blood_DNA
					bloodcolor=S.blood_color
					S.track_blood--
			else
				if(H.track_blood && H.feet_blood_DNA)
					bloodDNA = H.feet_blood_DNA
					bloodcolor=H.feet_blood_color
					H.track_blood--

			if (bloodDNA)
				src.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,H.dir,0,bloodcolor) // Coming
				var/turf/simulated/from = get_step(H,reverse_direction(H.dir))
				if(istype(from) && from)
					from.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,0,H.dir,bloodcolor) // Going

				bloodDNA = null

		if(M.buckled && istype(M.buckled,/obj/structure/bed/chair))
			return

		switch (src.wet)
			if(1)
				if(!M.slip(null, 5, 3, TRUE))
					M.inertia_dir = 0
					return

			if(2) //lube
				if(M.slip(null, 10, 10, FALSE, TRUE, 4))
					M.take_limb_damage(2)

			if(3) // Ice
				if(!M.slip("icy floor", 4, 3, FALSE, TRUE, 1))
					M.inertia_dir = 0
					return

	..()

