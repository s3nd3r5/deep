require("..map")

local origin = Space:new(ST_EMPTY)
local map = Map:new(MT_EMPTY, origin, 0, 0, 3, 3, 2, 2)

print("=== init ===")
print(map)
print(origin)

print_map(map)
print("=== check origin ===")
print(string.format("x: %d y: %d", map.start_space.x, map.start_space.y))

print("=== add new space ===")
next_space = map:move(S_DIR_NORTH)
print(next_space)
print(string.format("next x: %d == %d, y: %d == %d", origin.x, next_space.x, origin.y - 1, next_space.y))

print_map(map)
print("=== move back to origin ===")
back_to_origin = map:move(S_DIR_SOUTH) -- return back south (previously moved north)
print(back_to_origin)
print(back_to_origin.x == origin.x)

print_map(map)
print("=== move south again ===")
next_space = map:move(S_DIR_SOUTH)
print(string.format("next.x == 2 ? %s | next.y == 3 ? %s", next_space.x == 2, next_space.y == 3))

print_map(map)
print("=== cant move south again ===")
current_space = map.current_space
next_space = map:move(S_DIR_SOUTH)
print(string.format("current.x == next.x and current.y == next.y = %s", current_space.x == next_space.x and current_space.y == next_space.y))

print_map(map)
