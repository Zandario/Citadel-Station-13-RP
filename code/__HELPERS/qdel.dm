/// The underscores are to encourage people not to use this directly.
/proc/______qdel_list_wrapper(list/L)
	QDEL_LIST(L)

/// Sometimes you just want to end yourself.
/datum/proc/qdel_self()
	qdel(src)
