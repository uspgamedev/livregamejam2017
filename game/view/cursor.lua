
local CURSOR = {}

local _ARROW
local _CROSS

function CURSOR.load()
  _ARROW = love.mouse.newCursor("assets/cursor.png", 6, 6)
  love.mouse.setCursor(_ARROW)
end

return CURSOR

