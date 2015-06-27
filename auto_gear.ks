// Auto-manage gear in a very basic way.
@LAZYGLOBAL OFF.

LOCAL GEARDOWN IS 10.
LOCAL GEARUP IS 50.

DECLARE FUNCTION gear_up {
    PRINT "Retract landing struts.".
    GEAR OFF.
    WHEN radar_altitude() < GEARDOWN THEN gear_down().
}

DECLARE FUNCTION gear_down {
    PRINT "Deploy landing struts.".
    GEAR ON.
    WHEN radar_altitude() > GEARUP THEN gear_up().
}

// Initialize the script with struts deployed.
WHEN radar_altitude() > GEARUP THEN gear_up().

