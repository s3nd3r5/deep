require(".map")

G_MAP = nil
G_START = nil

G_OFFSET = 32

PLAYER = {}

function game_routine ()
  G_START = Space:new(ST_EMPTY)
  G_MAP = Map:new(MT_CAVE, G_START, 0, 0, 16, 16, 0, 0)
  add_space(G_START)
end

function add_space(space)
  debug(string.format("space.sprite ~= nil: %s", space.sprite ~= nil))
  debug(space.sprite)
  push_fore_sprite(space.sprite, space.x * G_OFFSET, space.y * G_OFFSET)
end

function render_map () 
    
end

function clean_game_routine () 

end
