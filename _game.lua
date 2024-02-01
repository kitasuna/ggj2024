_showtime_hero_params = {20, 99}
_showtime_mic_params = {24, 95}
_showtime_hero_index = 0
_showtime_hero_ttl = 3
_guesses = {}
function _showtime_draw()
  cls()
  palt(11, true)

  map(0,0,8,24,14,13)

  -- input guy
  input:draw(24, 112)

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
  rectfill(33,18,93 - (SHOWTIME_TIMER - _showtime_current_timer),21,8)

  palt()
end

function _explore_draw()
  cls()
  
  palt(11, true)

  map(0,0,8,24,14,13)

  -- player
  player:draw()

  -- baddies
  baddie_mngr:draw()

  -- time limit
  rect(32,17,94,22,7)
  -- 60 px wide
  rectfill(33,18,93 - (SHOWTIME_TIMER - _showtime_remaining_timer),21,8)

  palt()
end

function _gameover_draw()
  cls()

  palt(11, true)

  print("bravo!", 48, 32, 8)
  print("score: ".._score, 48, 40, 8)

  print("grammar explanation here...", 32, 72, 12)

  palt()
end

function _gameover_update()
end

function _explore_update(dt)
  local bits = btn()

  player:update(bits, dt)
  baddie_mngr:update(dt, player.x + 4, player.y + 4)

end

function _showtime_update(dt)
  _showtime_current_timer -= dt
  if _showtime_current_timer < 0 then
    change_state(STATE_GAMEOVER)
  end

  _showtime_hero_ttl -= dt
  if _showtime_hero_ttl < 0 then
    _showtime_hero_index = (_showtime_hero_index + 1) % #_showtime_hero_params
    printh("Showtime hero index: ".._showtime_hero_index)
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
      baddie_mngr:react(result and "haha" or "...")
      if result then
        if not elem(joined_str, _guesses) then
          _score += #joined * 5
          add(_guesses, joined_str)
          for k, v in pairs(_guesses) do 
            printh(k.." guess: "..v)
          end
        end
      end
    end
  end

  -- passing 0,0 as dummy values for player pos
  baddie_mngr:update(dt, 0, 0)
end

function change_state(new_state)
  if new_state == STATE_SHOWTIME then
    _current_state = new_state
    _showtime_current_timer = _showtime_remaining_timer
    printh("Showtime timer: ".._showtime_current_timer)
    _showtime_hero_ttl = 3
    _guesses = {}
  elseif new_state == STATE_EXPLORE then
    _current_state = new_state
    _showtime_remaining_timer = SHOWTIME_TIMER
  elseif new_state == STATE_GAMEOVER then
    _current_state = new_state
  else
    printh("Invalid game state!")
  end

end

