SCR_W=love.graphics.getWidth()
SCR_H=love.graphics.getHeight()

function debug(str)
  if DEBUG then
    print(string.format("%s - %s", os.date("%Y-%m-%dT%X", os.time()), str))
  end
end

--[[ SPRITE TABLES --]]

BACKGROUND={}
FORGROUND={}
HUD={}
TEXT={}

function push_text(str, x, y, justify_x, justify_y)
  if justify_x then
    x = x - (#str * 2)
  end
  if justify_y then
    y = y - (#str * 2)
  end
  table.insert(TEXT, { str, x, y })
end

function flush(tbl)
  while #tbl > 0 do
    table.remove(tbl)
  end
end

--[[ END SPRITE TABLES --]]

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

S_TITLE=1
S_START=2
S_GAME=3
S_GAME_OVER=4

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
  check_timers(dt * 1000)
end

function render () 
 for i=1, #TEXT do
   text_obj=TEXT[i]
   love.graphics.print(text_obj[1], text_obj[2], text_obj[3])
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
    love.graphics.print(string.format("state error # %d", state or -1), 0, 0)
    debug("Invalid state")
  end
end

function clear_state (state)
  if state == S_TITLE then
    clear_title_routine ()
  end
end

function start_routine ()
  debug("setup start")
  push_text("The Deep", SCR_W/2, 0, true)
  push_text("Any Key to Start", SCR_W/2, SCR_H/2, true)
end

function clear_start_routine ()
  debug("clearing start")
  flush(TEXT)
end

function title_routine ()
  debug("setup title")
  push_text("The Deep", SCR_W/2, SCR_H/2, true, true)
  set_s_timer(1000, S_START)
end

function clear_title_routine ()
  debug("clearing title")
  flush(TEXT)
end
