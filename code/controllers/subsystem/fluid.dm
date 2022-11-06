SUBSYSTEM_DEF(fluids)
	name = "Fluids"
	wait = 1 SECONDS
	subsystem_flags = SS_NO_INIT

	var/static/tmp/list/depth_levels = list(2, 50, 100, 200)
