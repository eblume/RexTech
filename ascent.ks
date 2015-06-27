// Proportional Feedback Loop for Kerbin ascent. Assumes we are already in early ascent,
// straight vertical 'UP' profile.

// See: http://ksp-kos.github.io/KOS_DOC/tutorials/pidloops.html
PARAMETER target_apoapsis, target_inclination.

RUN lib_lazcalc.
RUN lib_navball.

function draw_ascent_screen {
    PARAMETER plan.
    CLEARSCREEN.
    PRINT "Ascent Program | TA: " + target_apoapsis + " | TI: " + target_inclination.
    PRINT "Phase: " + plan. 
    PRINT "------------------------------".
}

LOCAL to_throttle IS 1.
LOCK THROTTLE TO to_throttle.

LOCAL launch_azimuth IS LAZCalc(target_apoapsis, target_inclination).
LOCAL to_pitch IS 0.
LOCK STEERING TO UP + R(to_pitch,0, 0).

// Stage 1: Vertical Climb
// TODO - Apparently TERMVELOCITY doesn't work any more, so just use TWR = 1.7 again
draw_ascent_screen("Vertical climb to 10000m").
LOCAL g is 0.
LOCAL total_twr is 0.
UNTIL SHIP:ALTITUDE > 5000 {
    SET g TO SHIP:BODY:MU / (SHIP:BODY:RADIUS + SHIP:ALTITUDE)^2.
    SET total_twr TO SHIP:AVAILABLETHRUST / (g * SHIP:MASS).

    SET to_pitch TO 0.
    SET to_throttle TO max(0, min(1, 1.7 / total_twr)).
    SET curr_twr TO total_twr * to_throttle.
    
    PRINT "  Total TWR: " + total_twr at (0, 3).
    PRINT "Current TWR: " + curr_twr at (0, 4).
    PRINT "   Altitude: " + ship:altitude at (0, 5).
    PRINT "   Throttle: " + to_throttle at (0, 6).
}

// Stage 2: Downrange Acceleration
draw_ascent_screen("Gravity Turn").
LOCAL g IS 0.
LOCAL total_twr IS 0.
LOCAL vertical_twr IS 0.
LOCAL pitch_pid IS PID_init(5, 2, 2, 0, 100).
UNTIL SHIP:APOAPSIS >= target_apoapsis {
    SET g TO SHIP:BODY:MU / (SHIP:BODY:RADIUS + SHIP:ALTITUDE)^2.
    SET total_twr TO SHIP:AVAILABLETHRUST / (g * SHIP:MASS).
    SET vertical_twr TO total_twr * COS(VANG(ship:up:vector, ship:velocity:surface)).

    SET to_pitch TO PID_seek(pitch_pid, 0, 1.7 - vertical_twr).
    SET to_throttle TO 1.

    PRINT "      Apoapsis: " + SHIP:APOAPSIS at (0, 3).
    PRINT "     Total TWR: " + total_twr at (0, 4).
    PRINT "  Vertical TWR: " + vertical_twr at (0, 5).
    PRINT "         Pitch: " + to_pitch at (0, 6).
    PRINT "Target Azimuth: " + launch_azimuth at (0, 7).
}
 
// Stage 3: Coast to Apoapsis
draw_ascent_screen("Coast to Apoapsis").
UNTIL SHIP:ALTITUDE >= target_apoapsis {
    SET to_pitch TO 0.
    SET to_throttle TO 0.

    PRINT "Apoapsis: " + SHIP:APOAPSIS at (0, 3).
    PRINT "Altitude: " + SHIP:ALTITUDE at (0, 4).
}

CLEARSCREEN.
