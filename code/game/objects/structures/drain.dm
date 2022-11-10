// Cheap, shitty, hacky means of draining water without a proper pipe system.
// TODO: water pipes.
/obj/structure/drain
	name = "gutter"
	desc = "You probably can't get sucked down the plughole."
	icon = 'icons/obj/drain.dmi'
	icon_state = "drain"
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER+0.1
	var/drainage = 0.5
	var/last_gurgle = 0
	var/welded

/obj/structure/drain/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/drain/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/drain/attackby(obj/item/thing, mob/user)
	if(istype(thing, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = thing
		if(WT.isOn())
			welded = !welded
			to_chat(user, SPAN_NOTICE("You weld \the [src] [welded ? "closed" : "open"]."))
		else
			to_chat(user, SPAN_WARNING("Turn \the [thing] on, first."))
		update_icon()
		return
	return ..()

/obj/structure/drain/update_icon()
	icon_state = "[initial(icon_state)][welded ? "-welded" : ""]"

/obj/structure/drain/process(delta_time)
	if(welded)
		return
	var/turf/T = get_turf(src)
	if(!istype(T)) return
	var/fluid_here = T.get_fluid_depth()
	if(fluid_here <= 0)
		return

	T.remove_fluid(ROUND_UP(fluid_here * drainage))
	T.show_bubbles()
	if(world.time > last_gurgle + 80)
		last_gurgle = world.time
		playsound(T, pick(SSfluids.gurgles), 50, TRUE)
