
local CURSOR = {}

local _ARROW
local _CROSS

function CURSOR.load()
  _ARROW = love.mouse.newCursor("assets/cursor.png", 6, 6)
  _CROSS = love.mouse.newCursor("assets/crosshairs.png", 16, 16)
  CURSOR.pointer()
end

function CURSOR.pointer()
  love.mouse.setCursor(_ARROW)
end

function CURSOR.crosshairs()
  love.mouse.setCursor(_CROSS)
end

return CURSOR

