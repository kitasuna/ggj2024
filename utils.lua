-- Color -> IO()
function byline(color)
  print("v0.3.0", 1, 122, color)
  print("@kitasuna", 92, 122, color)
end

-- Int -> Int -> Int -> String
function new_msgbox(x, y, max_x, max_y, ttmax, str)
  return {
    -- how long the message box has been alive
    elapsed=0,
    ttmax=ttmax,
    draw = function(self)
      local finish_x = (self.elapsed / ttmax) * max_x
      local finish_y = (self.elapsed / ttmax) * max_y
      rectfill(x,y,mid(6,finish_x,max_x),mid(30,finish_y,max_y),6) 
      rectfill(x+2,y+2,mid(8,finish_x,max_x)-2,mid(32,finish_y,max_y)-2,5) 
      if self.elapsed >= ttmax then
        -- local new_str = sub(str, 1, mid(1, msg_box_fc * 2, #str))
        dshad(str, x+4, y+4, 7, 2)
      end
    end,
    update = function(self, dt)
      if self.elapsed < self.ttmax then
        self.elapsed += dt
      end
    end,
  }
end
