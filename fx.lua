fx = {
  parts = {},
  stars = {},
  cyclers = {},
  msgbox = nil,
}

function new_cycler(str, cycle_ttl, colors) 
  return {
    str = str,
    cycle_ttl = cycle_ttl,
    colors = colors,
    current = 1,
    update = function(self, dt)
      self.cycle_ttl -= dt 
      if self.cycle_ttl <= 0 then
        self.current += 1
        if self.current > #self.colors then
          self.current = 1
        end
        self.cycle_ttl = cycle_ttl
      end
    end,
    draw = function(self, x, y)
      print(self.str, x, y, self.colors[self.current])
    end,
  }
end
