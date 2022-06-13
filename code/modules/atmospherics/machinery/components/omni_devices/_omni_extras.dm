//--------------------------------------------
// Omni device port types
//--------------------------------------------
#define ATM_NONE    0
#define ATM_INPUT   1
#define ATM_OUTPUT  2

#define ATM_GAS_MIN 3 // Lower bound for gas mode iteration.
#define ATM_O2      3 // Oxygen.
#define ATM_N2      4 // Nitrogen.
#define ATM_CO2     5 // Carbon dioxide.
#define ATM_P       6 // Phoron.
#define ATM_N2O     7 // Nitrous oxide.
#define ATM_H2      8 // Hydrogen.
#define ATM_CH3BR   9 // Methyl bromide.
#define ATM_GAS_MAX 9 // Upper bound for gas mode iteration.


//--------------------------------------------
// Omni port datum
//
// Used by omni devices to manage connections
//  to other atmospheric objects.
//--------------------------------------------
/datum/omni_port
	var/obj/machinery/atmospherics/component/quaternary/master
	var/dir
	var/update = 1
	var/mode = 0
	var/concentration = 0
	var/con_lock = 0
	var/transfer_moles = 0
	var/datum/gas_mixture/air
	var/obj/machinery/atmospherics/node
	var/datum/pipe_network/network

/datum/omni_port/New(obj/machinery/atmospherics/component/quaternary/M, direction = NORTH)
	..()
	dir = direction
	if(istype(M))
		master = M
	air = new
	air.volume = ATMOS_DEFAULT_VOLUME_FILTER

/datum/omni_port/proc/connect()
	if(node)
		return
	master.atmos_init()
	master.build_network()
	if(node)
		node.atmos_init()
		node.build_network()

/datum/omni_port/proc/disconnect()
	if(node)
		node.disconnect(master)
		master.disconnect(node)


//--------------------------------------------
// Need to find somewhere else for these
//--------------------------------------------

//returns a text string based on the direction flag input
// if capitalize is true, it will return the string capitalized
// otherwise it will return the direction string in lower case
/proc/dir_name(dir, capitalize = FALSE)
	var/string = null
	switch(dir)
		if(NORTH)
			string = "North"
		if(SOUTH)
			string = "South"
		if(EAST)
			string = "East"
		if(WEST)
			string = "West"

	if(!capitalize && string)
		string = lowertext(string)

	return string

//returns a direction flag based on the string passed to it
// case insensitive
/proc/dir_flag(dir)
	dir = lowertext(dir)
	switch(dir)
		if("north")
			return NORTH
		if("south")
			return SOUTH
		if("east")
			return EAST
		if("west")
			return WEST
		else
			return FALSE
