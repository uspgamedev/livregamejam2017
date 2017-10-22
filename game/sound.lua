
local SOUND = {}

local _sfx = {}

function SOUND.play(name)
  local sfx = _sfx[name] if not sfx then
    sfx = love.audio.newSource(("assets/sfx/%s.wav"):format(name), 'static')
    _sfx[name] = sfx
  end
  sfx:stop()
  sfx:play()
end

return SOUND


