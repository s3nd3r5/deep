DEBUG=true

function love.conf (t)
  t.window.resizable=false
  t.window.fullscreen=false
  t.window.borderless=false
  t.window.title="The Deep"
end

-- SPRITES

SPRITE_TITLE=love.graphics.newImage("sprites/Title.png")
