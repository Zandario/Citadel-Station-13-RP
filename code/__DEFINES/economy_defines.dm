#define MAX_MONEY 10000000

#define		   CREDIT "credit"
#define		  CREDITS "credits"
#define	SYMBOL_CREDIT "&cent;"
#define	 SHORT_CREDIT "CR"

// Department types
#define	  PUBLIC_DEPARTMENT 1	// Station Departments
#define	EXTERNAL_DEPARTMENT 2	// Centcom Departments
#define	 OFFDUTY_DEPARTMENT 3	// No monies while off-duty

// Getting the map's head departments
#define	HEAD_DEPARTMENT GLOB.using_map.get_head_department()
#define	MAIN_DEPARTMENT GLOB.using_map.get_main_department()

// Public Departments
#define	 DEPT_NANOTRASEN "nanotrasen"

#define		  DEPT_CARGO "cargo"
#define		 DEPT_COLONY "colony"
#define		DEPT_COMMAND "command"
#define	DEPT_ENGINEERING "engineering"
#define DEPT_EXPLORATION "exploration"
#define		DEPT_MEDICAL "medical"
#define	   DEPT_CIVILIAN "civilian"
#define		DEPT_SCIENCE "science"
#define	   DEPT_SECURITY "security"
#define		DEPT_SERVICE "service"

// External Departments
#define		DEPT_CENTCOM "central-command"
