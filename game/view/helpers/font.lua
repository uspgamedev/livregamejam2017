
local FONT = {}

local _fonts = {}

function FONT.set(size)
  local font = _fonts[size]
  if not font then
    font = love.graphics.newFont('assets/fonts/Orbitron-Medium.ttf', size)
    _fonts[size] = font
  end
  love.graphics.setFont(font)
end

return FONT

