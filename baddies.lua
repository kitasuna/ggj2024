baddie_mngr = {
  baddies = {},
  init = function(self)
    self.baddies = {}
  end,
  add = function(self, x, y, flip, message)
    local frame_ttl_const = 1 * (1 / (#message * 2))
    add(self.baddies, 
      {
        x = x,
        y = y,
        flip = flip,
        frames = {},
        frame = 0,
        frame_ttl = frame_ttl_const + rnd(0.3),
        frame_ttl_const = frame_ttl_const,
        message = message,
        reaction = "",
        reaction_ttl = 0,
        speak = true,
        spoke = false,
      }
    ) 
  end,
  draw = function(self)
    for k, v in pairs(self.baddies) do 
      spr(7 + v.frame, v.x, v.y, 1, 1, v.flip)  
      if v.speak then
        print(v.message, v.x - 4, v.y - 5, 7)
      end

      if v.reaction_ttl > 0 then
        local offset_x = 0
        local offset_y = 0
        if v.reaction == "haha" then
          offset_x = rnd(4) - 2
          offset_y = rnd(4) - 2
        end
        print(v.reaction, v.x + 5 + offset_x, v.y - 5 + offset_y, 7)
      end
    end
  end,
  update = function(self, dt, px, py)
    for k, v in pairs(self.baddies) do 
      if v.reaction != "..." then
        v.frame_ttl -= dt 
        if v.frame_ttl < 0 then
          v.frame = (v.frame + 1) % 2
          v.frame_ttl = v.frame_ttl_const
        end
      end

      v.reaction_ttl -= dt 
      if v.reaction_ttl < 0 then
        v.reaction_ttl = 0
        v.reaction = ""
      end

      -- assume false to account for showtime mode
      v.speak = false 
      if px != 0 or py != 0 then
        local dx = v.x + 4 - px
        local dy = v.y + 4 - py
        local dist = sqrt(dx * dx + dy * dy)
        if dist < 12 then
          v.speak = true
          if v.spoke == false then
            v.spoke = true
            _showtime_remaining_timer -= 2 * #v.message 
          end
        end
      end
    end
  end,
  react = function(self, reaction)
    for k, v in pairs(self.baddies) do 
      v.reaction = reaction
      v.reaction_ttl = 0.8 + rnd(0.8)
    end
  end,
}


