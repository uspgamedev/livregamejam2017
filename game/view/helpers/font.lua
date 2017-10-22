
local FONT = {}

local _fonts = {}

local function _get(size)
  local font = _fonts[size]
  if not font then
    font = love.graphics.newFont('assets/fonts/Orbitron-Medium.ttf', size)
    _fonts[size] = font
  end
  return font
end

function FONT.set(size, height)
  local font = _get(size)
  if height then
    font:setLineHeight(height)
  end
  love.graphics.setFont(font)
end

function FONT.height(size)
  local font = _get(size)
  return font:getHeight()
end

return FONT

