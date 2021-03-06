local L = function (self, x, y, glyph)

  self.y = y
  self.x = x
  
  self.glyph = glyph
  self.passive = glyph == string.lower(glyph) and true 
  self.name = 'loop'
  self.info = 'Loops a number of eastward operators.'
    
  self.ports = { 
    {-1, 0, 'in-length', 'haste'}, {-2, 0, 'in-rate', 'haste'}
  }

  local length = self:listen( self.x - 1, self.y, 0 ) or 0
  local rate = util.clamp(self:listen( self.x - 2, self.y, 0 ) or 1, 1, #self.chars)
  local offset = 1
  length = util.clamp( length, 0, self.XSIZE - length)
  local l_start = util.clamp( self.x + offset, 1, self.XSIZE)
  local l_end = util.clamp( self.x + length, 1, self.YSIZE)

  if not self.passive then
    self.cleanup(self.x, self.y)
    for i = 1, length do
      self.ports[#self.ports + 1] = { i , 0, 'in-value',  'input' }
    end
    self:spawn(self.ports)
    
    if (self.frame % rate == 0 and length ~= 0) then
      self:shift(offset, length)
    end

    
  end

end


return L

