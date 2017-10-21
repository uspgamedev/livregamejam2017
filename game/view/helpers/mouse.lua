
local MOUSE = {}

local _mouse_down
local _mouse_clicked

function MOUSE.update(dt)
  local last = _mouse_down
  _mouse_down = love.mouse.isDown(1)
  _mouse_clicked = _mouse_down and not last
end

function MOUSE.pos()
  return love.mouse.getPosition()
end

function MOUSE.clicked()
  return _mouse_clicked
end

return MOUSE

