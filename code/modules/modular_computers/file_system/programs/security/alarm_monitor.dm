//Subtype of engineering alarm monitor, look at /engineering/alarm_monitor.dm for details
/datum/computer_file/program/alarm_monitor/security
	filename = "alarmmonitorsec"
	filedesc = "Alarm Monitoring (Security)"
	extended_desc = "This program provides visual interface for the security alarm system."
	tguimodule_path = /datum/tgui_module/alarm_monitor/security/ntos
	required_access = access_security
