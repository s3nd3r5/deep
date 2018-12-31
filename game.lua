-- Dungeon OOP
T_EMPTY = "empty"
T_WALL = "wall"

Space = {
  visited = false,
  type = T_EMPTY,
  
}

function Space::new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function game_routine ()

end
