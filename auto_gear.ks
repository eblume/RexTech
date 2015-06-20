// Auto-manage gear in a very basic way.

DECLARE FUNCTION gear_up {
    PRINT "Retract landing struts.".
    GEAR OFF.
    WHEN SHIP:ALTITUDE < 150 THEN gear_down().
}

DECLARE FUNCTION gear_down {
    PRINT "Deploying landing struts.".
    GEAR ON.
    WHEN SHIP:ALTITUDE > 200 THEN gear_up().
}

// Initialize the script with struts deployed.
WHEN SHIP:ALTITUDE > 200 THEN gear_up().

