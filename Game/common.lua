Class = require "lib/hump/class"

--- Constants
-- @param MIN_DT		The minimum delta time between frames (framerate)
-- @param FRAME_RATE 	The delta time between spritesheet frame animations
-- @param METER	 		Pixel-equivalent of one meter
-- @param G				Gravitational constant
MIN_DT 			= 1/60
FRAME_RATE 		= 1/15
METER 			= 23.5
G 				= 9.8 * METER * 10
JUMP_CONST		= G * 9

--- String:split splits a string into an table based on the delimiter provided
-- @param sep the delimiter to split a string by
function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end
