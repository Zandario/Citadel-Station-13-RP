SUBSYSTEM_DEF(networks)
	name = "Networks"
	subsystem_flags = SS_NO_FIRE
	// no init order for now
	// no fire priority for now

	// Simple networks
	/// id lookup to a list of devices
	var/static/list/simple_network_lookup = list()

/datum/controller/subsystem/networks/Initialize()
	return SS_INIT_SUCCESS
