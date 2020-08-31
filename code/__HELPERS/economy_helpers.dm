/proc/cash2text(num, use_symbol = TRUE, use_suffix = TRUE, use_desc = TRUE)	// Returns $800USD mil for example.
	var/symbol
	var/suffix
	var/text_desc
	var/multiplier = 1
	var/negative = FALSE

	var/final_num

	if(GLOB.using_map.currency_symbol && use_symbol)
		symbol = GLOB.using_map.currency_symbol

	if(GLOB.using_map.currency_suffix && use_suffix)
		suffix = GLOB.using_map.currency_suffix

	if(0 > num)
		negative = TRUE
		num = (-1 * (num))

	if(use_desc)
		switch(num)
			if(1000000 to INFINITY)
				text_desc = "mil"
				multiplier = 1000000

	final_num = round(num / multiplier)

	if(negative)
		final_num = "-[final_num]"

	return "[symbol][final_num][suffix][text_desc ? " [text_desc]" : ""]"
