
/mob/living/vv_get_header()
	. = ..()
	. += {"
		<a href='byond://?_src_=vars;rename=\ref[src]'><b>[src]</b></a><font size='1'>
		<br><a href='byond://?_src_=vars;datumedit=\ref[src];varnameedit=ckey'>[ckey ? ckey : "No ckey"]</a> / <a href='byond://?_src_=vars;datumedit=\ref[src];varnameedit=real_name'>[real_name ? real_name : "No real name"]</a>
		<br>
		BRUTE:<a href='byond://?_src_=vars;mobToDamage=\ref[src];adjustDamage=brute'>[getBruteLoss()]</a>
		FIRE:<a href='byond://?_src_=vars;mobToDamage=\ref[src];adjustDamage=fire'>[getFireLoss()]</a>
		TOXIN:<a href='byond://?_src_=vars;mobToDamage=\ref[src];adjustDamage=toxin'>[getToxLoss()]</a>
		OXY:<a href='byond://?_src_=vars;mobToDamage=\ref[src];adjustDamage=oxygen'>[getOxyLoss()]</a>
		CLONE:<a href='byond://?_src_=vars;mobToDamage=\ref[src];adjustDamage=clone'>[getCloneLoss()]</a>
		BRAIN:<a href='byond://?_src_=vars;mobToDamage=\ref[src];adjustDamage=brain'>[getBrainLoss()]</a>
		</font>
		"}
