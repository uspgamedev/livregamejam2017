
local MOUSE = {}

local _mouse_down = { false, false }
local _mouse_clicked = { false, false }

function MOUSE.update(dt)
  for i=1,2 do
    local last = _mouse_down[i]
    _mouse_down[i] = love.mouse.isDown(i)
    _mouse_clicked[i] = _mouse_down[i] and not last
  end
end

function MOUSE.pos()
  return love.mouse.getPosition()
end

function MOUSE.clicked(i)
  return _mouse_clicked[i]
end

return MOUSE

