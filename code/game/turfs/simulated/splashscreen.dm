/turf/unsimulated/start_area
	name = null
	desc = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	permit_ao = FALSE

/turf/simulated/splashscreen
	name = "Space Station 13"
	desc = null
	icon = 'icons/blanks/blank_title.png'
	icon_state = ""
	pixel_x = -64
	plane = SPLASHSCREEN_PLANE
	permit_ao = FALSE

INITIALIZE_IMMEDIATE(/turf/simulated/splashscreen)

/turf/simulated/splashscreen/Initialize(mapload)
	. = ..()
	SStitle.splash_turf = src
	if(SStitle.icon)
		icon = SStitle.icon
		handle_generic_titlescreen_sizes()

///helper proc that will center the screen if the icon is changed to a generic width, to make admins have to fudge around with pixel_x less. returns null
/turf/simulated/splashscreen/proc/handle_generic_titlescreen_sizes()
	var/icon/size_check = icon(SStitle.icon, icon_state)
	var/width = size_check.Width()
	if(width == 480) // 480x480 is nonwidescreen
		pixel_x = 0
	else if(width == 608) // 608x480 is widescreen
		pixel_x = -64

/turf/simulated/splashscreen/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if(NAMEOF(src, icon))
				SStitle.icon = icon
				handle_generic_titlescreen_sizes()

/turf/simulated/splashscreen/examine()
	desc = pick(strings(SPLASH_FILE, "splashes"))
	return ..()
