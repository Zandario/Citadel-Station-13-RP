var/list/doppler_arrays = list()

obj/machinery/doppler_array
	name = "tachyon-doppler array"
	desc = "A highly precise directional sensor array which measures the release of quants from decaying tachyons. The doppler shifting of the mirror-image formed by these quants can reveal the size, location and temporal affects of energetic disturbances within a large radius ahead of the array."
	anchored = TRUE
	density = TRUE
	dir = NORTH

	icon_state = "doppler"

obj/machinery/doppler_array/Initialize(mapload, newdir)
	. = ..()
	doppler_arrays += src

obj/machinery/doppler_array/Destroy()
	doppler_arrays -= src
	return ..()

obj/machinery/doppler_array/proc/sense_explosion(x0, y0, z0, devastation_range, heavy_impact_range, light_impact_range, took)
	if(machine_stat & NOPOWER)
		return
	if(z != z0)
		return

	var/dx = abs(x0-x)
	var/dy = abs(y0-y)
	var/distance
	var/direct

	if(dx > dy)
		distance = dx
		if(x0 > x)
			direct = EAST
		else
			direct = WEST
	else
		distance = dy
		if(y0 > y)
			direct = NORTH
		else
			direct = SOUTH

	if(distance > 100)
		return
	if(!(direct & dir))
		return

	var/message = "Explosive disturbance detected - Epicenter at: grid ([x0],[y0]). Epicenter radius: [devastation_range]. Outer radius: [heavy_impact_range]. Shockwave radius: [light_impact_range]. Temporal displacement of tachyons: [took]seconds."

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>[src]</span> states coldly, \"[message]\"</span>",2)

obj/machinery/doppler_array/power_change()
	..()
	if(machine_stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		icon_state = "[initial(icon_state)]_off"
