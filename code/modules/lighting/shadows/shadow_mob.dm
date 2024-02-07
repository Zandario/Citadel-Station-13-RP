/mob/proc/create_opacity_image()
	if(!client)
		return
	client.reflector = new
	client.reflector.loc = src
	client.reflector.plane = SHADOWCASTING_REFLECTOR_PLANE
	client.reflector.layer = SHADOW_CASTER_LAYER_MAIN
	client.images.Add(client.reflector)

	client.mover = new
	client.mover.animate_movement = NO_STEPS
	client.mover.vis_flags = VIS_HIDE

	update_opacity_image()

/mob/proc/update_opacity_image()
	var/turf/T = get_turf(src)
	if(!client)
		return
	client.reflector.vis_contents = list()
	if(!T)
		return
	else if(length(T.shadowcasting_overlays) <= 1)
		T.update_shadowcasting_overlays()

	client.reflector.vis_contents = T.shadowcasting_overlays
	client.mover.loc = T
	client.reflector.loc = client.mover

/mob/living/carbon/human/Login()
	. =..()
	ASYNC
		create_opacity_image()
		client.reflector.vis_contents = list()
		update_opacity_image()
		client.reflector.loc = loc

/mob/forceMove()
	. = ..()
	if(client)
		update_opacity_image()

/mob/Moved()
	. = ..()
	if(client)
		update_opacity_image()
