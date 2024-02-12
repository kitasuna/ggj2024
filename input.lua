input = {
  chars = {},
  indexes = {},
  charset = {},
  current_index = 1,
  init = function(self,chars)
    self.chars = {}
    self.indexes = {0,0,0,0,0,0}
    -- self.indexes = {3,2,1,4,5,6}
    self.charset = chars
    self.current_index = 1
  end,
  setchar = function(self, index, val)
    self.indexes[index] = val
  end,
  moveup = function(self)
    self.indexes[self.current_index] += 1
    if self.indexes[self.current_index] > #self.charset then
      self.indexes[self.current_index] = 0
    end
  end,
  movedown = function(self)
    self.indexes[self.current_index] -= 1
    if self.indexes[self.current_index] < 0 then
      self.indexes[self.current_index] = #self.charset
    end
  end,
  moveleft = function(self)
    self.current_index = self.current_index - 1
    if self.current_index < 1 then
      self.current_index = #self.indexes
    end
  end,
  moveright = function(self)
    -- Don't allow to move to next slot if this one is empty
    if self.indexes[self.current_index] == 0 then
      return
    end
    self.current_index = self.current_index + 1
    if self.current_index > #self.indexes then
      self.current_index = 1
    end
  end,
  draw = function(self, x, y)
    for i=1,#self.indexes do 
      if self.indexes[i] != 0 then
        print(self.charset[self.indexes[i]], x + (i * 10), y+2, 7)
      else 
        line(x + (i * 10), y + 4, x + 8 + (i * 10), y + 4, 7) 
      end
    end
    spr(16, x + (self.current_index*10), y + 8)
  end,
  reset = function(self)
    self.current_index = 1
    self.indexes = {0,0,0,0,0,0}
  end,
  submit = function(self)
    local result = {}
    local result_str = ""
    for k,v in pairs(self.indexes) do 
      if v != 0 then
        result[k] = self.charset[v]
        result_str = result_str..self.charset[v]
      end
    end
    self:reset()
    return result, result_str
  end,
}
