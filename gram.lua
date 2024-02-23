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
        if not elem(self.parts[((k-1) % 3) + 1], v) then 
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
      dshad("1st/4th: "..self.parts[1][1].." or "..self.parts[1][2], x, y, 12, 1)
      dshad("2nd/5th: "..self.parts[2][1].." or "..self.parts[2][2], x, y+10, 12, 1)
      dshad("3rd/6th: "..self.parts[3][1].." or "..self.parts[3][2], x, y+20, 12, 1)
    end
  },
  {
    name = "headstails",
    heads = {},
    tails = {},
    init = function(self, xs)
      self.heads = {xs[1], xs[2]}
      self.tails = {xs[5], xs[6]}
      self.all = xs
    end,
    gen = function(self, tgt_length)
      -- head first
      str = self.heads[1 + flr(rnd(2))]
      for i=2,tgt_length do
        -- pick one of the first chars 
        str = str..self.all[1 + flr(rnd(#self.all))]
      end 
      str = str..self.tails[1 + flr(rnd(2))]
      return str
    end,
    check = function(self, xs)
      if #xs < 2 then
        return false
      end
      if not elem(self.heads, xs[1]) or not elem(self.tails, xs[#xs]) then
          return false
      end
      return true
    end,
    debug = function(self)
      printh("self.heads: "..self.heads[1]..","..self.heads[2])
      printh("self.tails: "..self.tails[1]..","..self.tails[2])
    end,
    explain = function(self, x, y)
      dshad("first: "..self.heads[1].." or "..self.heads[2], x, y, 12, 1)
      dshad("last: "..self.tails[1].." or "..self.tails[2], x, y+10, 12, 1)
    end
  }
}

function elem(tbl, e)
  for v in all(tbl) do 
    if e == v then
      return true
    end
  end
  return false
end

