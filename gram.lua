-- Char[] -> Char[]
function shuffle(tbl)
  for i = #tbl, 2, -1 do 
    local j = flr(rnd(i)) + 1
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

gs = {
  {
    name = "basic",
    parts = {{},{},{}},
    init = function(self, xs)
      self.parts[1] = {xs[1], xs[2]}
      self.parts[2] = {xs[3], xs[4]}
      self.parts[3] = {xs[5], xs[6]}
    end,
    gen = function(self, tgt_length)
      -- rand length 
      -- tgt_length = flr(rnd(max_length))
      str = ""
      for i=0,tgt_length do
        -- pick one of the first chars 
        str = str..self.parts[(i % 3) + 1][flr(rnd(2))+1]
      end 
      return str
    end,
    check = function(self, xs)
      for k,v in pairs(xs) do 
        if not elem(v, self.parts[((k-1) % 3) + 1]) then 
          -- printh("Couldnt find "..v.." in parts "..((k - 1) % 3))
          return false
        end
      end
      return true
    end,
    debug = function(self)
      printh("self.p1: "..self.parts[1][1]..","..self.parts[1][2])
      printh("self.p2: "..self.parts[2][1]..","..self.parts[2][2])
      printh("self.p3: "..self.parts[3][1]..","..self.parts[3][2])
    end,
    explain = function(self, x, y)
      print("first: "..self.parts[1][1].." or "..self.parts[1][2], x, y)
      print("second: "..self.parts[2][1].." or "..self.parts[2][2], x, y+10)
      print("third: "..self.parts[3][1].." or "..self.parts[3][2], x, y+20)
    end
  }
}

chatter = { 
}

function elem(e, tbl)
  for v in all(tbl) do 
    if e == v then
      return true
    end
  end
  return false
end

