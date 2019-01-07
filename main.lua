require(".game")
require(".map")

-- GLOBAL VARIABLES
SCR_W=love.graphics.getWidth()
SCR_H=love.graphics.getHeight()
--love.keyboard.setKeyRepeat(true)

function debug(str)
  if DEBUG then
    print(string.format("%s - %s", os.date("%Y-%m-%dT%X", os.time()), str))
  end
end

-- SPRITES

SPRITE_TITLE = love.graphics.newImage("sprites/Title.png")


-- GRAPHICS
-- Types
T_SPRITE = 'sprite'
T_TEXT = 'text'

BACKGROUND={}
FOREGROUND={}
HUD={}

function push_fore_text(str, x, y, justify_x, justify_y)
  push_text(FOREGROUND, str, x, y, justify_x, justify_y)
end

function push_bg_text(str, x, y, justify_x, justify_y)
  push_text(BACKGROUND, str, x, y, justify_x, justify_y)
end

function push_hud_text(str, x, y, justify_x, justify_y)
  push_text(HUD, str, x, y, justify_x, justify_y)
end

function push_text(tbl, str, x, y, justify_x, justify_y)
  if justify_x then
    x = x - (#str/2)
    align="left"
  end
  if justify_y then
    y = y - (#str/2)
  end
  if justify_x and justify_y then
    align="center"
  end
  table.insert(tbl, { msg=str, x=x, y=y, type=T_TEXT, align=align })
end

function push_fore_sprite(spr, x, y, justify_x, justify_y)
  push_sprite(FOREGROUND, spr, x, y, justify_x, justify_y)
end

function push_bg_sprite(spr, x, y, justify_x, justify_y)
  push_sprite(BACKGROUND, spr, x, y, justify_x, justify_y)
end
function push_hud_sprite(spr, x, y, justify_x, justify_y)
  push_sprite(HUD, spr, x, y, justify_x, justify_y)
end

function push_sprite(tbl, spr, x, y, justify_x, justify_y)
  if justify_x then
    x = x - (spr:getWidth() / 2)
  end
  if justify_y then 
    y = y - (spr:getHeight() / 2)
  end
  table.insert(tbl, { sprite=spr, x=x, y=y, type=T_SPRITE } )
end

function render () 
  for i=1, #BACKGROUND do
    render_type(BACKGROUND[i])
  end
  for i=1, #FOREGROUND do
    render_type(FOREGROUND[i])
  end
  for i=1, #HUD do
    render_type(HUD[i])
  end
end

function render_type (tableEl)
  if tableEl.type == nil then
    debug(string.format("Cannont print tableEl: %s", tableEl or "nil"))
  elseif tableEl.type == T_SPRITE then
    render_type_sprite(tableEl)
  elseif tableEl.type == T_TEXT then
    render_type_text(tableEl)
  else 
    debug(string.format("Unknown render type: %s", tableEl.type or "nil"))
  end
end


function render_type_text (tableText)
  if tableText.align ~= nil then
    love.graphics.printf(tableText.msg, tableText.x, tableText.y, SCR_W, tableText.align)
  else
    love.graphics.print(tableText.msg, tableText.x, tableText.y, SCR_W, SCR_H)
   end
end

function render_type_sprite (tableSprite) 
  love.graphics.draw(tableSprite.sprite, tableSprite.x, tableSprite.y)
end

function flush(tbl)
  while #tbl > 0 do
    table.remove(tbl)
  end
end

-- END GRAPHICS

--[[ TIMER --]]
-- Timers can be set for things that are only available periodically
-- Multiple timers can be defined and are checked on every draw

S_TIMER=nil
S_TIMER_NEXT=nil
S_TIMER_P_TIME=nil

function cur_time()
  return love.timer.getTime() * 1000
end

function check_timers(dt)
  check_s_timer(dt)
end

function set_s_timer(ms, state)
  S_TIMER_NEXT=state
  S_TIMER=ms 
end

function check_s_timer(dt)
  if S_TIMER ~= nil then
    S_TIMER = S_TIMER - dt
    if S_TIMER <= 0 then
      transition_state(S_TIMER_NEXT)
      S_TIMER=nil
      S_TIMER_NEXT=nil
    end
  end
end

--[[ END TIMER --]]

--[[ STATES --]]

S_TITLE="title"
S_START="start"
S_GAME="game"
S_GAME_OVER="game over"

P_STATE=nil
C_STATE=S_TITLE

function transition_state(n_state)
  P_STATE=C_STATE
  C_STATE=n_state
end
--[[ END STATES --]]

function love.draw () 
  if P_STATE == nil or P_STATE ~= C_STATE then
    if P_STATE ~= nil then
      clear_state(P_STATE)
    end
    setup_state(C_STATE) 
    P_STATE = C_STATE
  else
    render()
  end
end

function love.update (dt)
  check_keypress(C_STATE)
  check_timers(dt * 1000)
end

function check_keypress (state)
  if state == S_START then
    if love.keyboard.isDown("return", "kpenter") then
      transition_state(S_GAME)
    end
  end
end

function love.keypressed(key, scancode, is_repeated)
  if C_STATE == S_GAME then
    if key == "escape" then
      love.event.quit()
    end
    new_space = false
     
    if key == "up" then
      new_space = G_MAP:move(S_DIR_NORTH)
    elseif key == "down" then
      new_space = G_MAP:move(S_DIR_SOUTH)
    elseif key == "left" then
      new_space = G_MAP:move(S_DIR_WEST)
    elseif key == "right" then
      new_space = G_MAP:move(S_DIR_EAST)
    end
    if new_space then
      add_space(G_MAP.current_space)
    end
  end
end

function setup_state(state)
  if state == S_TITLE then
    title_routine ()
  elseif state == S_START then
    start_routine ()
  elseif state == S_GAME then
    game_routine ()
  elseif state == S_GAME_OVER then
    game_over_routine ()
  else
    err_msg = string.format("state error # %s", state or "nil")
    love.graphics.print(err_msg, 0, 0)
    debug(err_msg)
  end
end

function clear_state (state)
  if state == S_TITLE then
    clear_title_routine ()
  elseif state == S_START then
    clear_start_routine ()
  elseif state == S_GAME then
    clear_game_routine ()
  end
end

function start_routine ()
  debug("setup start")
  push_hud_sprite(SPRITE_TITLE, SCR_W/2, SCR_H/2, true, true)
  push_hud_text("Press Enter to Start", 0, SCR_H-100, true, true)
end

function clear_start_routine ()
  debug("clearing start")
  flush(HUD)
end

function title_routine ()
  debug("setup title")
  push_hud_sprite(SPRITE_TITLE, SCR_W/2, SCR_H/2, true, true)
  set_s_timer(1000, S_START)
end

function clear_title_routine ()
  debug("clearing title")
  flush(HUD)
end
