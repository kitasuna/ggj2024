function _showtime_draw()
  cls()
  palt(11, true)
  -- print(#_chars, 0, 0, 11)
  for i=1,#_chars do 
    --print(_chars[i], 32 + i*6, 32)
  end

  for i=1,#_dialog do 
    -- print(i..": ".._dialog[i], 4, 8 + (i*8))
  end

  -- input guy
  input:draw(24, 112)

  -- baddies
  baddie_mngr:draw()

  -- result output
  result_output:draw()

  -- showtime banner
  spr(64, 20, 0, 10, 2)

  palt()
end

function _explore_draw()
  cls()
  
  palt(11, true)

  -- player
  player:draw()

  -- baddies
  baddie_mngr:draw()

  palt()
end

function _explore_update(dt)
  local bits = btn()

  player:update(bits)
  baddie_mngr:update(dt, player.x, player.y)

end

function _showtime_update(dt)
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
    local joined = input:submit()
    -- printh("Joined: "..joined)
    local result = gs[1]:check(joined)
    result_output:set(result and "haha!" or "...")
    baddie_mngr:react(result and "haha" or "...")
  end

  result_output:update(dt)

  -- passing 0,0 as dummy values for player pos
  baddie_mngr:update(dt, 0, 0)
end

result_output = {
  message = "",
  ttl = 0,
  set = function(self, message)
    self.message = message
    self.ttl = 1.5
  end,
  update = function(self, dt)
    self.ttl -= dt
    if self.ttl < 0 then
      self.ttl = 0
    end
  end,
  draw = function(self)
    if self.ttl > 0 then
      -- print(self.message, 112, 112, 6)
    end
  end,
}
