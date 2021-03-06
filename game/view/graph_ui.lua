
local COLOR = require 'cpml.color'
local VEC2 = require 'cpml.vec2'
local MOUSE = require 'view.helpers.mouse'
local FONT = require 'view.helpers.font'
local GRAPH_LOGIC = require 'graph_logic'

local GRAPH_UI = {}

local _RADIUS = 24
local _IDLE_COLOR = COLOR(101, 141, 206, 255)
local _HOVER_SIZE = 1.2
local _CLICKED_COLOR = COLOR(0, 255, 255, 255)
local _DECAY = 5
local _IDLE_INTEL_COLOR = COLOR(100, 180, 20, 255)
local _CLICKED_INTEL_COLOR = COLOR(205, 205, 85, 255)

local _EDGE_CLICK_WIDTH = 16
local _EDGE_COLOR = COLOR(100, 100, 100, 255)
local _LOCKED_EDGE_COLOR = COLOR(225, 50, 50, 255)

local _queue = {}

local _nodes = {}
local _camera = VEC2(0, 0)

local function _push(...)
  table.insert(_queue, {...})
end

local function _mousePos()
  local mx, my = MOUSE.pos()
  mx = mx + _camera.x
  my = my + _camera.y
  return mx, my
end

function GRAPH_UI.load(n, map)
  for i,node in ipairs(GRAPH_LOGIC.nodes()) do
    if node.hasIntel then
      _camera = VEC2(unpack(map[i])) - VEC2(love.graphics.getDimensions())/2
    end
  end
  _nodes = {}
  for i=1,n do
    _nodes[i] = { glow = 0 }
  end
end

function GRAPH_UI.node(i, x, y)
  local mx, my = _mousePos()
  local near = (mx - x)^2 + (my - y)^2 < (_RADIUS*_HOVER_SIZE)^2
  local clicked = MOUSE.clicked(1) and near
  local glow = clicked and 1 or _nodes[i].glow
  local scale = near and _HOVER_SIZE or 1
  local node = GRAPH_LOGIC.nodes()[i]
  _nodes[i].glow = glow
  _nodes[i].pos = {x,y}
  _push('push')
  if node.hasIntel then
    _push('setColor', COLOR.lerp(_IDLE_INTEL_COLOR, _CLICKED_INTEL_COLOR, glow))
  else
    _push('setColor', COLOR.lerp(_IDLE_COLOR, _CLICKED_COLOR, glow))
  end
  _push('translate', x, y)
  _push('push')
  _push('scale', scale, scale)
  _push('polygon', 'fill', 0, -_RADIUS, _RADIUS, 0,
                           0, _RADIUS, -_RADIUS, 0)
  if node.protected then
    _push('scale', 1.2, 1.2)
    _push('setLineWidth', 1)
    _push('polygon', 'line', 0, -_RADIUS, _RADIUS, 0,
                             0, _RADIUS, -_RADIUS, 0)
  end
  _push('pop')
  if near and not node.protected then
    _push('setColor', 240, 240, 240)
    _push('printf', GRAPH_LOGIC.nodes()[i].pcs, -_RADIUS, _RADIUS*1.5,
                                                2*_RADIUS, 'center')
  end

  if node.hasProbe or DEBUG then
    local aux = GRAPH_LOGIC.sleeping() and 0 or 100 * node.infectedPcs / node.pcs
    local percent = ("%d%%"):format(aux)
    _push('setColor', 200, 140, 140)
    _push('printf', percent, _RADIUS, _RADIUS*1.5,
                             3*_RADIUS, 'left')
  end
  _push('pop')
  return clicked
end

function GRAPH_UI.edge(i, j, weight, midpoint)
  local mx, my = _mousePos()
  local ix, iy = unpack(_nodes[i].pos)
  local jx, jy = unpack(_nodes[j].pos)
  local ex, ey = jx-ix, jy-iy
  local l = ex*ex + ey*ey
  local sql = math.sqrt(l)
  local offset = 2*_RADIUS
  ix, iy = ix + ex*offset/sql, iy + ey*offset/sql
  jx, jy = jx - ex*offset/sql, jy - ey*offset/sql
  ex, ey = jx-ix, jy-iy
  l = ex*ex + ey*ey
  local rx, ry = mx-ix, my-iy
  local d = ex*rx + ey*ry
  local p = d/l
  local px, py = ix + p*ex, iy + p*ey
  local n = (mx-px)^2 + (my-py)^2
  local near = p >= 0 and p <= 1 and n < _EDGE_CLICK_WIDTH^2

  if near then
    _push('setColor', 240, 240, 240, 255)
    _push('print', weight, midpoint[1], midpoint[2] + 10)
  end
  if GRAPH_LOGIC.edges()[i][j].locked then
    _push('setColor', _LOCKED_EDGE_COLOR)
  else
    _push('setColor', _EDGE_COLOR)
  end
  _push('setLineWidth', near and 4 or 1)
  _push('line', ix, iy, jx, jy)

  return near and MOUSE.clicked(1)
end

function GRAPH_UI.moveCamera(dx, dy)
  _camera = _camera + VEC2(dx, dy)
end

function GRAPH_UI.update(dt)
  for _,node in ipairs(_nodes) do
    node.glow = node.glow - node.glow*_DECAY*dt
  end
end

function GRAPH_UI.draw()
  local g = love.graphics
  g.push()
  g.translate((-_camera):unpack())
  FONT.set(18)
  for _,cmd in ipairs(_queue) do
    g[cmd[1]](unpack(cmd, 2))
  end
  g.pop()
  _queue = {}
end

return GRAPH_UI
