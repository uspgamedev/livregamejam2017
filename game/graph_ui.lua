
local COLOR = require 'cpml.color'
local GRAPH_UI = {}

local _RADIUS = 16
local _IDLE_COLOR = COLOR(0, 0, 255, 255)
local _CLICKED_COLOR = COLOR(0, 255, 255, 255)
local _DECAY = 5

local _queue = {}

local _mouse_pos
local _mouse_down
local _mouse_clicked

local _nodes = {}

local function _push(...)
  table.insert(_queue, {...})
end

function GRAPH_UI.load(n)
  _nodes = {}
  for i=1,n do
    _nodes[i] = { glow = 0 }
  end
end

function GRAPH_UI.node(i, x, y)
  local mx, my = unpack(_mouse_pos)
  local clicked = _mouse_clicked and (mx - x)^2 + (my - y)^2 < _RADIUS^2
  local glow = clicked and 1 or _nodes[i].glow
  _nodes[i].glow = glow
  _push('setColor', COLOR.lerp(_IDLE_COLOR, _CLICKED_COLOR, glow))
  _push('circle', 'fill', x, y, _RADIUS)
  return clicked
end

function GRAPH_UI.edge(i, j, state)
  local mx, my = unpack(_mouse_pos)
  local clicked = _mouse_clicked and (mx - x)^2 + (my - y)^2 < _RADIUS^2
end

function GRAPH_UI.update(dt)
  _mouse_pos = { love.mouse.getPosition() }
  local last = _mouse_down
  _mouse_down = love.mouse.isDown(1)
  _mouse_clicked = _mouse_down and not last
  for _,node in ipairs(_nodes) do
    node.glow = node.glow - node.glow*_DECAY*dt
  end
end

function GRAPH_UI.draw()
  local g = love.graphics
  for _,cmd in ipairs(_queue) do
    g[cmd[1]](unpack(cmd, 2))
  end
end

return GRAPH_UI

