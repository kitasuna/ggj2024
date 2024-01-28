_showtime_hero_params = {0, 80}
_showtime_mic_params = {4, 76}
_showtime_hero_index = 0
_showtime_hero_ttl = 3
_guesses = {}
function _showtime_draw()
  cls()
  palt(11, true)

  for k, v in pairs(fx.stars) do 
    pset(v.x, v.y, 7)
  end

  map(0,0,8,24,14,13)

  -- input guy
  input:draw(6, 112)

  -- baddies
  baddie_mngr:draw()

  -- showtime banner
  spr(64, 20, 0, 10, 2)

  -- our hero
  spr(32, _showtime_hero_params[_showtime_hero_index + 1], 114, 1, 1, _showtime_hero_index == 1 and true or false)
  -- our hero's microphone
  spr(75, _showtime_mic_params[_showtime_hero_index + 1], 114, 1, 1, _showtime_hero_index == 1 and true or false)

  -- time limit
  rect(32,17,94,22,7)
  -- 60 px wide
  rectfill(33,18,93 - (SHOWTIME_TIMER - _showtime_current_timer),21,14)

  print("score: ".._score, 84, 122)
  palt()
end

function _explore_draw()
  cls()
  
  palt(11, true)

  for k, v in pairs(fx.stars) do 
    pset(v.x, v.y, 7)
  end

  map(0,0,8,24,14,13)

  -- player
  player:draw()

  -- baddies
  baddie_mngr:draw()

  -- time limit
  rect(32,17,94,22,7)
  -- 60 px wide
  rectfill(33,18,93 - (SHOWTIME_TIMER - _showtime_remaining_timer),21,14)

  print("press ❎ or 🅾️ ", 30, 115, 14)
  print("to start showtime!", 30, 121, 14)

  foreach(fx.parts, function(p)
    p:draw()
  end)

  palt()
end

function _gameover_draw()
  cls()

  palt(11, true)

  print("bravo!", 48, 32, 14)
  print("score: ".._score, 48, 40, 14)

  print("grammar solution!", 32, 72, 12)
  gs[1]:explain(32, 82)

  palt()
end

function _gameover_update(dt)
  if btnp(4) or btnp(5) then
    change_state(STATE_TITLE)
  end

  foreach(timers, function(t)
    t.ttl -= dt
    if t.ttl <= 0 then
      t.f()
      del(timers, t)
    end
  end)
end

function _explore_update(dt)
  local bits = btn()

  if rnd() > 0.7 then
    add(fx.stars, {x=130, y=flr(rnd(120)), dx=rnd()})
  end

  for k, v in pairs(fx.stars) do 
    v.x -= v.dx
  end

  player:update(bits, dt)
  baddie_mngr:update(dt, player.x + 4, player.y + 4)

  foreach(fx.parts, function(part) 
    part:update(dt)
    if part.ttl <= 0 then
      del(fx.parts, part)
    end
  end)

  if btnp(4) or btnp(5) then
    change_state(STATE_SHOWTIME)
  end

end

function _showtime_update(dt)
  if rnd() > 0.7 then
    add(fx.stars, {x=130, y=flr(rnd(120)), dx=rnd()})
  end

  for k, v in pairs(fx.stars) do 
    v.x -= v.dx
  end

  _showtime_current_timer -= dt
  if _showtime_current_timer < 0 then
    change_state(STATE_GAMEOVER)
  end

  _showtime_hero_ttl -= dt
  if _showtime_hero_ttl < 0 then
    _showtime_hero_index = (_showtime_hero_index + 1) % #_showtime_hero_params
    _showtime_hero_ttl = 3
  end

  if btnp(1) then 
    input:moveright()
  end
  if btnp(0) then 
    input:moveleft()
  end
  if btnp(2) then 
    input:moveup()
  end
  if btnp(3) then 
    input:movedown()
  end

  if btnp(4) then
    input:reset()
  end

  if btnp(5) then
    local joined, joined_str = input:submit() 
    if #joined > 0 then
      local result = gs[1]:check(joined)
      if result then
        if not elem(joined_str, _guesses) then
          _score += #joined * 5
          baddie_mngr:react("haha")
          sfx(24)
          add(timers, {
            ttl = 1.2,
            f = function()
              printh("silencing sound")
              sfx(24, -2) 
            end,
            })
          add(_guesses, joined_str)
          for k, v in pairs(_guesses) do 
            printh(k.." guess: "..v)
          end
        else -- repeat
          _score += 1
          baddie_mngr:react("ha...")
          sfx(25)
          add(timers, {
            ttl = 1.2,
            f = function()
              printh("silencing sound")
              sfx(25, -2) 
            end,
            })
        end
      -- failed, give a "..."
      else
        baddie_mngr:react("...")
          sfx(26)
          add(timers, {
            ttl = 1.2,
            f = function()
              printh("silencing sound")
              sfx(26, -2) 
            end,
            })
      end
    end
  end

  -- passing 0,0 as dummy values for player pos
  baddie_mngr:update(dt, 0, 0)

  foreach(timers, function(t)
    t.ttl -= dt
    if t.ttl <= 0 then
      t.f()
      del(timers, t)
    end
  end)
end

function _title_draw()
  cls()
  for k, v in pairs(fx.stars) do 
    pset(v.x, v.y, 7)
  end
  map(20,0,24,30,11,4)
  print("press any button to start", 18, 90, 14)

end

function _title_update()
  if btnp(4) or btnp(5) then
    change_state(STATE_EXPLORE)
  end

  if rnd() > 0.7 then
    add(fx.stars, {x=130, y=flr(rnd(120)), dx=rnd()})
  end

  for k, v in pairs(fx.stars) do 
    v.x -= v.dx
  end
end

function change_state(new_state)
  if new_state == STATE_SHOWTIME then
    _current_state = new_state
    _showtime_current_timer = _showtime_remaining_timer
    _showtime_hero_ttl = 3
    _guesses = {}
  elseif new_state == STATE_TITLE then
    _current_state = new_state
    _showtime_remaining_timer = SHOWTIME_TIMER
    __init()
  elseif new_state == STATE_EXPLORE then
    music(0, 500)
    _current_state = new_state
    _showtime_remaining_timer = SHOWTIME_TIMER
  elseif new_state == STATE_GAMEOVER then
    music(-1, 500)
    _current_state = new_state
  else
    printh("Invalid game state!")
  end
  printh("new state: "..new_state)

end

