player = {
  init = function(self)
    self.x = 56
    self.y = 112
  end,
  draw = function(self)
    spr(1, self.x, self.y)
  end,
  update = function(self, bits)
    printh("Bits: "..bits)
    if btn(0) then
      self.x -= 1
    end

    -- if bits & (1<<1) then
    if btn(1) then
      self.x += 1
    end

    if btn(2) then
      self.y -= 1
    end

    if btn(3) then
      self.y += 1
    end

    if btn(4) or btn(5) then
      _current_state = STATE_SHOWTIME
    end
  end
}
