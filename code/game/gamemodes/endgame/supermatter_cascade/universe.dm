var/global/universe_has_ended = 0


/datum/universal_state/supermatter_cascade
 	name = "Supermatter Cascade"
 	desc = "Unknown harmonance affecting universal substructure, converting nearby matter to supermatter."

 	decay_rate = 5 // 5% chance of a turf decaying on lighting update/airflow (there's no actual tick for turfs)

/datum/universal_state/supermatter_cascade/OnShuttleCall(var/mob/user)
	if(user)
		to_chat(user, "<span class='sinister'>All you hear on the frequency is static and panicked screaming. There will be no shuttle call today.</span>")
	return 0

/datum/universal_state/supermatter_cascade/DecayTurf(var/turf/T)
	if(istype(T,/turf/simulated/wall))
		var/turf/simulated/wall/W=T
		W.melt()
		return
	if(istype(T,/turf/simulated/floor))
		var/turf/simulated/floor/F=T
		// Burnt?
		if(!F.burnt)
			F.burn_tile()
		else
			if(!istype(F,/turf/simulated/floor/plating))
				F.break_tile_to_plating()
		return

// Apply changes when entering state
/datum/universal_state/supermatter_cascade/OnEnter()
	set background = 1
	to_chat(world, "<span class='sinister' style='font-size:22pt'>You are blinded by a brilliant flash of energy.</span>")

	SEND_SOUND(world, sound('sound/effects/cascade.ogg'))

	for(var/mob/M in GLOB.player_list)
		M.flash_eyes()

	if(SSemergencyshuttle.can_recall())
		priority_announcement.Announce("The emergency shuttle has returned due to bluespace distortion.")
		SSemergencyshuttle.recall()

	AreaSet()
	MiscSet()
	APCSet()
	OverlayAndAmbientSet()

	// Disable Nar-Sie.
	cult.allow_narsie = 0

	PlayerSet()

	new /obj/singularity/narsie/large/exit(pick(endgame_exits))
	spawn(rand(30,60) SECONDS)
		var/txt = {"
There's been a galaxy-wide electromagnetic pulse.  All of our systems are heavily damaged and many personnel are dead or dying. We are seeing increasing indications of the universe itself beginning to unravel.

[station_name()], you are the only facility nearby a bluespace rift, which is near your research outpost. You are hereby directed to enter the rift using all means necessary, quite possibly as the last of your species alive.

You have five minutes before the universe collapses. Good l\[\[###!!!-

AUTOMATED ALERT: Link to [command_name()] lost.

The access requirements on the Asteroid Shuttles' consoles have now been revoked.
"}
		priority_announcement.Announce(txt,"SUPERMATTER CASCADE DETECTED")

		for(var/obj/machinery/computer/shuttle_control/C in GLOB.machines)
			if(istype(C, /obj/machinery/computer/shuttle_control/research) || istype(C, /obj/machinery/computer/shuttle_control/mining))
				C.req_access = list()
				C.req_one_access = list()

		spawn(5 MINUTES)
			SSticker.station_explosion_cinematic(0,null) // TODO: Custom cinematic
			universe_has_ended = 1
		return

/datum/universal_state/supermatter_cascade/proc/AreaSet()
	for(var/area/A in GLOB.sortedAreas)
		if(!istype(A,/area) || istype(A, /area/space) || istype(A,/area/beach))
			continue

		A.updateicon()

/datum/universal_state/supermatter_cascade/OverlayAndAmbientSet()
	spawn(0)
		for(var/turf/space/T in world)
			T.color = "#0066FF"

/datum/universal_state/supermatter_cascade/proc/MiscSet()
	for (var/obj/machinery/firealarm/alm in GLOB.machines)
		if (!(alm.machine_stat & BROKEN))
			LEGACY_EX_ACT(alm, 2, null)

/datum/universal_state/supermatter_cascade/proc/APCSet()
	for (var/obj/machinery/power/apc/APC in GLOB.apcs)
		if (!(APC.machine_stat & BROKEN) && !APC.is_critical)
			APC.chargemode = 0
			if(APC.cell)
				APC.cell.charge = 0
			APC.emagged = 1
			APC.update_icon()

/datum/universal_state/supermatter_cascade/proc/PlayerSet()
	for(var/datum/mind/M in GLOB.player_list)
		if(!istype(M.current,/mob/living))
			continue
		if(M.current.stat!=2)
			M.current.Weaken(10)
			M.current.flash_eyes()

		clear_antag_roles(M)
