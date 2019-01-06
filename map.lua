-- SPACE_TYPES
-- used to denote the type of space to render
ST_EMPTY = "empty" -- a regular empty space

S_DIR_NORTH=1
S_DIR_SOUTH=2
S_DIR_EAST=3
S_DIR_WEST=4

function moveDirX(dir, x)
  if dir == S_DIR_EAST then return x - 1
  elseif dir == S_DIR_WEST then return x + 1
  else return x end
end

function moveDirY(dir, y)
  if dir == S_DIR_NORTH then return y - 1
  elseif dir == S_DIR_SOUTH then return y + 1
  else return y end
end

function oppositeDirection(dir)
  if dir == S_DIR_NORTH then return S_DIR_SOUTH
  elseif dir == S_DIR_SOUTH then return S_DIR_NORTH
  elseif dir == S_DIR_EAST then return S_DIR_WEST
  elseif dir == S_DIR_WEST then return S_DIR_EAST
  else print(string.format("Invalid dir: %d", dir or "-1"))
  end
end

-- MAP_TYPES
-- These select the tileset to chose from
MT_CAVE = "cave" -- the typical

-- SPRITES

SPRITES = {}

SPRITES[MT_CAVE] = {}
SPRITES[MT_CAVE][ST_EMPTY] = love.graphics.newImage("sprites/grass.png")

function get_sprite(space_type, map_type)
  return SPRITES[map_type][space_type]
end

Space = { type=ST_EMPTY, visited=false, neighbors = {}, x=0, y=0, sprite=nil }

function Space:new(type)
  o = { type=type, visited=false, neighbors = {}, x=0, y=0, sprite=nil }
  setmetatable(o, self)
  self.__index = self
  return o
end

function Space:hasAdjacent(dir)
  return self.neighbors[dir] ~= nil
end

function Space:getAdjacent(dir)
  return self.neighbors[dir]
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
    self.neighbors[dir] = space
    space:add(self, oppositeDirection(dir))
  else
    print("Cannot add space, space dir already filled")
  end
end

Map = { 
  type = MT_CAVE,
  start_space = nil, -- the space the character will start from
  current_space = nil, -- the space the character is on
  x_max_bound = 0, -- the maximum x distance
  y_max_bound = 0, -- the maximum y distance
  x_min_bound = 0, -- the minimum x distance
  y_min_bound = 0, -- the maximum y distance
  spaces = {}
}

function Map:new (type, space, x_min_bound, y_min_bound, x_max_bound, y_max_bound, origin_x, origin_y)
  space.x = origin_x
  space.y = origin_y
  space.sprite = get_sprite(space.type, type)
  spaces = {}
  o = {
    type=type,
    start_space=space,
    current_space=space,
    x_min_bound=x_min_bound,
    y_min_bound=y_min_bound,
    x_max_bound=x_max_bound,
    y_max_bound=y_max_bound,
    spaces = spaces
  }
  for y=y_min_bound, y_max_bound do
    spaces[y] = {}
  end 
  spaces[origin_y][origin_x] = space
  setmetatable(o, self)
  self.__index = self
  return o
end

function Map:checkMove(new_x, new_y)
  return new_x >= self.x_min_bound 
    and new_x <= self.x_max_bound 
    and new_y >= self.y_min_bound 
    and new_y <= self.y_max_bound 
end 

function Map:move(dir)
  space = self.current_space
  
  new_x = moveDirX(dir, space.x)
  new_y = moveDirY(dir, space.y)
  
  is_new = false

  if space:hasAdjacent(dir) then
    next_space = space:getAdjacent(dir)
    self.current_space = next_space
    is_new = false
  elseif self:checkMove(new_x, new_y) then
    next_space = Space:new(ST_EMPTY)
    space:add(next_space, dir)
    self.spaces[new_y][new_x] = next_space
    next_space.x = new_x
    next_space.y = new_y
    next_space.sprite = get_sprite(next_space.type, self.type)
    self.current_space = next_space
    is_new = true
  end
 
  return is_new 
end

function Map:render()

end

function Map:generate()
  

end

function print_map(map)
  for y=map.y_min_bound, map.y_max_bound do
    s = ""
    for x=map.x_min_bound, map.x_max_bound do
      sp = map.spaces[y][x]
      if sp == nil then
        s = s .. " ?"
      elseif sp.x == map.current_space.x and sp.y == map.current_space.y then
        s = s .. " o"
      else
        s = s .. " ."
      end
    end
    print(s)
  end
end
