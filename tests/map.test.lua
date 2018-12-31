require("..map")
local origin = Space:new(ST_EMPTY)
local map = Map:new(MT_EMPTY, origin, 0, 0 4, 4, 0, 0)

print(origin)
print(map.start_space)
print(map)
