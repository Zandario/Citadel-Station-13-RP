
/proc/getstraightlinewalled(atom/M,vx,vy,include_origin = 1)//hacky fuck for l ighting
	if (!M) return null
	var/turf/T = null
	var/px=M.x		//starting x
	var/py=M.y
	if (include_origin)
		. = list(locate(px,py,M.z))
	else
		.= list()
	if (vx)
		var/step = vx > 0 ? 1 : -1
		vx = abs(vx)
		while(vx > 0)
			px += step
			vx -= 1
			T = locate(px,py,M.z)
			if (!T || T.opacity || T.opaque_atom_count > 0)
				break
			. += T
	else if (vy)
		var/step = vy > 0 ? 1 : -1
		vy = abs(vy)
		while(vy > 0)
			py += step
			vy -= 1
			T = locate(px,py,M.z)
			if (!T || T.opacity || T.opaque_atom_count > 0)
				break
			. += T

/atom/proc/set_opacity(newopacity)
	SHOULD_CALL_PARENT(TRUE)

	if (newopacity == src.opacity)
		return // Why even bother

	var/oldopacity = src.opacity
	src.opacity = newopacity

	SEND_SIGNAL(src, COMSIG_ATOM_SET_OPACITY, oldopacity)

	// Below is a "smart" signal on a turf that only get called when the opacity
	// actually changes in a meaningfull way. If atom is on a turf and we are
	// obscuring vision in a turf that was originally not obscured. Or we are on a
	// turf that is not obscuring vision, we were obscuring vision and are not
	// anymore.
	// if (isturf(src.loc) && ((src.loc.opacity == 0 && src.opacity == 1) || (src.loc.opacity == 0 && oldopacity == 1 && src.opacity == 0)))
	// 	SEND_SIGNAL(src.loc, COMSIG_TURF_CONTENTS_SET_OPACITY_SMART, oldopacity, src)
