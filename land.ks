
RUN lib_pid.

PRINT "Start descent program.".
LOCK THROTTLE TO 0.
WAIT UNTIL SHIP:ALTITUDE < 7000.

// break_height is the height at which we must begin maximum deceleration in order to 
// stop in time. Doesn't currently take in to account change in inertia due to propellant
// or air resistance.
LOCK gravaccel TO KERBIN:MU / (KERBIN:RADIUS + SHIP:ALTITUDE)^2.
LOCK twr TO SHIP:AVAILABLETHRUST / (gravaccel * SHIP:MASS).
LOCK break_height TO (SHIP:VERTICALSPEED^2 / (2 * gravaccel * (twr - 1))) + 50.
WAIT UNTIL SHIP:ALTITUDE <= break_height.
PRINT "End descent program.".

PRINT "Start landing program.".

LOCAL landing_pid IS PID_init(0.1, 0.06, 0.06, 0, 1).
LOCAL to_throttle IS 0.
LOCK THROTTLE TO to_throttle.

UNTIL ALT:RADAR < 10 {
    SET to_throttle TO PID_seek(landing_pid, -7, SHIP:VERTICALSPEED).
    wait 0.001.
}.

UNTIL ALT:RADAR < 1 {
    SET to_throttle TO PID_seek(landing_pid, -3, SHIP:VERTICALSPEED).
    wait 0.001.
}.

LOCK THROTTLE TO 0.

PRINT "End landing program.".
