
local _RADIUS = 64

local GRAPH_UI = {}

local _queue = {}

local _mouse_pos
local _mouse_down
local _mouse_clicked

function GRAPH_UI.load()
end

function GRAPH_UI.node(x, y)
  local g = love.graphics
  local mx, my = unpack(_mouse_pos)
  local clicked = _mouse_clicked and (mx - x)^2 + (my - y)^2 < _RADIUS^2
  g.setColor(
  return clicked
end

function GRAPH_UI.update()
  _mouse_pos = { love.mouse.getPosition() }
  local last = _mouse_down
  _mouse_down = love.mouse.isDown(1)
  _mouse_clicked = _mouse_down and not last
end

function GRAPH_UI.draw()
  local g = love.graphics
  for _,cmd in ipairs(_queue) do
    g[cmd[1]](unpack(cmd, 2))
  end
end

return GRAPH_UI

