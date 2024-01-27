player = {
  init = function(self)
    self.x = 56
    self.y = 96
    self.frame_ttl = 0.1
    self.frame_offset = 0
    self.cycle_length = 2
    self.frame_starts = {32, 32, 35, 38}
    self.direction = 0
  end,
  draw = function(self)
    spr(self.frame_starts[self.direction + 1] + self.frame_offset, self.x, self.y, 1, 1, self.direction == 0 and true or false)
  end,
  update = function(self, bits, dt)
    if btn(0) then
      self.x -= 0.5
      if self.x < 12 then
        self.x = 12
      end
      self.direction = 0
    end

    -- if bits & (1<<1) then
    if btn(1) then
      self.x += 0.5
      if self.x > 108 then
        self.x = 108
      end
      self.direction = 1
    end

    if btn(2) then
      self.y -= 0.5
      if self.y < 28 then
        self.y = 28
      end
      self.direction = 2
    end

    if btn(3) then
      self.y += 0.5
      if self.y > 98 then
        self.y = 98
      end
      self.direction = 3
    end

    if btn(4) or btn(5) then
      change_state(STATE_SHOWTIME)
    end

    if btn() > 0 then
      self.frame_ttl -= dt
      if self.frame_ttl < 0 then
        self.frame_ttl = 0.1
        self.frame_offset = (self.frame_offset + 1) % self.cycle_length
      end
    end
  end
}
