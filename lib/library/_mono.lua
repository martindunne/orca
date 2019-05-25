local midi_out = function ( self, x, y, frame, grid )
  
  self.y = y
  self.x = x  
  
  self.name = 'mono'
  self.info = 'Sends MIDI monophonic note.'
  
  self.ports = {{1, 0, 'input_op'}, {2, 0, 'input_op'}, {3, 0, 'input_op'}, {4, 0 , 'input_op'}, {5, 0, 'input_op'}}
  self:spawn(self.ports)
  
  self:notes_off( channel )
  
  local channel = util.clamp( self:listen( self.x + 1, self.y ) or 0, 0, 16 )
  local octave = util.clamp( self:listen( self.x + 2, self.y ) or 3, 0, 8 )
  local vel = util.clamp( self:listen( self.x + 4, self.y ) or 10, 0, 16 )
  local length = util.clamp( self:listen( self.x + 5, self.y ) or 1, 0, #self.chars )
  local l = grid[self.y][self.x + 3] ~= 'null' and grid[self.y][self.x + 3] or 'C'
  local note_in = self:listen( self.x + 3, self.y ) or 0
  local note = self.chars[note_in]
  if l == string.upper(l) then note = string.upper(note) end
  local transposed = self.transpose( note, octave )
  local n, oct, velocity = transposed[1], transposed[4], math.floor(( vel / 16 ) * 127 )
  
  if self.banged( self.x, self.y ) then
    self.midi_out_device:note_on( n, velocity, channel )
    self:add_note_mono( channel, n, length )
  end
  
end

return midi_out