#define FOOTSTEP_SPRITE_AMT 2

//**** Here lives snow ****

/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "snow"
	var/list/crossed_dirs = list()

/turf/simulated/floor/snow/Entered(atom/movable/AM)
	if(AM.is_incorporeal())
		return // Ignore incorporeal mobs.

	if(isliving(AM))
		var/mdir = "[AM.dir]"
		if(crossed_dirs[mdir])
			crossed_dirs[mdir] = min(crossed_dirs[mdir] + 1, FOOTSTEP_SPRITE_AMT)
		else
			crossed_dirs[mdir] = 1

		update_icon()

	..()

/turf/simulated/floor/snow/update_icon()
	cut_overlays()
	for(var/d in crossed_dirs)
		var/amt = crossed_dirs[d]

		for(var/i in 1 to amt)
			add_overlay(image(icon, "footprint[i]", text2num(d)))


/turf/simulated/floor/snow/gravsnow
	name = "snowy gravel"
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "gravsnow"

/turf/simulated/floor/snow/snow2
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	initial_flooring = /decl/flooring/snow

/turf/simulated/floor/snow/gravsnow2
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "gravsnow"
	initial_flooring = /decl/flooring/snow/gravsnow2

/turf/simulated/floor/snow/plating
	name = "snowy playing"
	icon_state = "snowyplating"
	initial_flooring = /decl/flooring/snow/plating

/turf/simulated/floor/snow/plating/drift
	name = "snowy plating"
	icon_state = "snowyplayingdrift"
	initial_flooring = /decl/flooring/snow/plating/drift
