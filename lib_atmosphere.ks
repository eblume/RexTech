@LAZYGLOBAL off.

// I'm using these pages a lot here:
// http://ksp-kos.github.io/KOS_DOC/structures/celestial_bodies/atmosphere.html#atmospheric-math
// http://wiki.kerbalspaceprogram.com/wiki/Atmosphere
// https://en.wikipedia.org/wiki/Terminal_velocity
//
// The accuracy of this lib depends on the accuracy of those documents. The first in
// particular is pretty vague about how those constants are achieved.

function terminal_velocity {
    parameter
        ship,  // The ship to base calculations on
        dynamic_drag,  // The drag constant for this vehicle. Drag Coefficient * Area.
        altitude.  // The altitude for which to calculate terminal velocity.

    local g is ship:body:mu / (ship:body:radius + altitude)^2.
    local density is atmosphere_density(height).
    RETURN SQRT( (2 * ship:mass * g) / (density * dynamic_drag) ).
}.

// TODO - This might be completely wrong with the new atmospheric model in KSP 1. Shucks.
function atmosphere_height {
    parameter body.
    local boundary_pressure = 0.000001 // Via KOS_DOC, this is the constant to use.
    return -1 * LN(boundary_pressure / body:sealevelpressure) * body:scale.
}

function atmosphere_density {
    parameter body, altitude.
    return body:sealevelpressure * E ^ (-1 * altitude / body:scale)
}
