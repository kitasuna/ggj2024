player = {
  init = function(self, allowed_inputs)
    self.x = 56
    self.y = 88
    self.frame_ttl = 0.1
    self.frame_offset = 0
    self.cycle_length = 2
    self.frame_starts = {32, 32, 35, 38}
    self.direction = 0
    self.allowed_inputs = allowed_inputs
  end,
  draw = function(self)
    spr(self.frame_starts[self.direction + 1] + self.frame_offset, self.x, self.y, 1, 1, self.direction == 0 and true or false)
  end,
  update = function(self, bits, dt)
    -- unfreeze any frozen inputs not currently held down
    for i=0,5 do
      if self.allowed_inputs & (1 << i) == 0 then
        -- input currently not allowed, so let's allow it if it's not held down
        if not isset(bits, i) then
          self.allowed_inputs |= (1 << i)
        end
      end
    end

    --filter out anything not allowed
    local oldbits = bits
    bits &= self.allowed_inputs

    if bits & (1 << 0) > 0 then
      self.x -= 0.5
      if self.x < 20 then
        self.x = 20
      end
      self.direction = 0
    end

    if bits & (1<<1) > 0 then
      self.x += 0.5
      if self.x > 108 then
        self.x = 108
      end
      self.direction = 1
    end

    if bits & (1<<2) > 0 then
      self.y -= 0.5
      if self.y < 20 then
        self.y = 20
      end
      self.direction = 2
    end

    if bits & (1<<3) > 0 then
      self.y += 0.5
      if self.y > 90 then
        self.y = 90
      end
      self.direction = 3
    end

    -- any direction
    if bits & 15 > 0 then
      self.frame_ttl -= dt
      if self.frame_ttl < 0 then
        self.frame_ttl = 0.1
        self.frame_offset = (self.frame_offset + 1) % self.cycle_length
      end
    end
  end
}

-- Check if a given bit value is set
function isset(bits, idx)
  return (bits & (1 << idx)) > 0
end
