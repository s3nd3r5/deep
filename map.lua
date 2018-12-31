-- SPACE_TYPES
-- used to denote the type of space to render
ST_EMPTY = "empty" -- a regular empty space

S_DIR_NORTH=1
S_DIR_SOUTH=2
S_DIR_EAST=3
S_DIR_WEST=4

Space = { type=ST_EMPTY, visited=false, neighbors = {} }

function Space:new(type)
  o = { type=type, visited=false, neighbors = {} }
  setmetatable(o, self)
  self.__index = self
  return o
end

function oppositeDirection(dir)
  if dir == S_DIR_NORTH then return S_DIR_SOUTH
  elseif dir == S_DIR_SOUTH then return S_DIR_NORTH
  elseif dir == S_DIR_EAST then return S_DIR_WEST
  elseif dir == S_DIR_WEST then return S_DIR_EAST
  else debug(string.format("Invalid dir: %d", dir or "-1"))
  end
end

function Space:addNorth(space)
  return self:add(space, S_DIR_NORTH)
end

function Space:addSouth(space)
  return self:add(space, S_DIR_SOUTH)
end

function Space:addEast(space)
  return self:add(space, S_DIR_EAST)
end

function Space:addWest(space)
  return self:add(space, S_DIR_WEST)
end

function Space:add(space, dir)
  if self.neighbors[dir] == nil then
    self.neightbors[dir] = space
    space:add(self, oppositeDirection(dir))
  else
    debug("Cannot add space, space dir already filled")
  end
end

-- MAP_TYPES
-- These select the tileset to chose from
MT_CAVE = "cave" -- the typical

Map = { 
  type = MT_CAVE,
  start_space = nil, -- the space the character will start from
  current_space = nil, -- the space the character is on
  x_max_bound = 0, -- the maximum x distance
  y_max_bound = 0, -- the maximum y distance
  x_min_bound = 0, -- the minimum x distance
  y_min_bound = 0 -- the maximum y distance
}

function Map:new (type, space, x_min_bound, y_min_bound, x_max_bound, y_max_bound, origin_x, origin_y)
  o = {
    type=type,
    start_space=start_space,
    current_space=start_space,
    x_min_bound=x_min_bound,
    y_min_bound=y_min_bound,
    x_max_bound=x_max_bound,
    y_max_bound=y_max_bound
  }
  self.start_space.x = origin_x
  self.start_space.y = origin_y
  setmetatable(o, self)
  self.__index = self
  return o
end

function Map:checkMove(space, dir)
  new_x = moveDirX(dir, space.x)
  new_y = moveDirY(dir, space.y)

  return  new_x >= self.x_min_bound 
    and new_x <= self.x_max_bound 
    and new_y >= self.y_min_bound 
    and new_y <= self.y_max_bound 
    and space:check(dir)
end

function Map:move(space, dir)
  if self:checkMove(space, dir) then
    next_space = space:moveDir(dir)
    self.current_space = next_space
  end

function Map:generate()
end

