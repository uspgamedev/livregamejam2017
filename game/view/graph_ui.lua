
local COLOR = require 'cpml.color'
local MOUSE = require 'view.helpers.mouse'
local GRAPH_LOGIC = require 'graph_logic'

local GRAPH_UI = {}

local _RADIUS = 16
local _IDLE_COLOR = COLOR(0, 0, 255, 255)
local _HOVER_SIZE = 1.2
local _CLICKED_COLOR = COLOR(0, 255, 255, 255)
local _DECAY = 5

local _EDGE_CLICK_WIDTH = 16
local _EDGE_COLOR = COLOR(100, 100, 100, 255)

local _queue = {}

local _nodes = {}

local function _push(...)
  table.insert(_queue, {...})
end

function GRAPH_UI.load(n)
  _nodes = {}
  for i=1,n do
    _nodes[i] = { glow = 0 }
  end
  Font = love.graphics.newFont("/assets/fonts/ptserif.ttf", 18)
end

function GRAPH_UI.node(i, x, y)
  local mx, my = MOUSE.pos()
  local near = (mx - x)^2 + (my - y)^2 < (_RADIUS*_HOVER_SIZE)^2
  local clicked = MOUSE.clicked() and near
  local glow = clicked and 1 or _nodes[i].glow
  local scale = near and _HOVER_SIZE or 1
  _nodes[i].glow = glow
  _nodes[i].pos = {x,y}
  _push('push')
  _push('setColor', COLOR.lerp(_IDLE_COLOR, _CLICKED_COLOR, glow))
  _push('translate', x, y)
  _push('scale', scale, scale)
  _push('circle', 'fill', 0, 0, _RADIUS)
  _push('setColor', 255, 255, 255)
  _push('print', GRAPH_LOGIC.nodes()[i].pcs, -10, -13)
  _push('pop')
  return clicked
end

function GRAPH_UI.edge(i, j, state)
  local mx, my = MOUSE.pos()
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
  
  _push('setColor', _EDGE_COLOR)
  _push('setLineWidth', near and 4 or 1)
  _push('line', ix, iy, jx, jy)

  return near and MOUSE.clicked()
end

function GRAPH_UI.update(dt)
  for _,node in ipairs(_nodes) do
    node.glow = node.glow - node.glow*_DECAY*dt
  end
end

function GRAPH_UI.draw()
  local g = love.graphics
  g.setFont(Font)
  for _,cmd in ipairs(_queue) do
    g[cmd[1]](unpack(cmd, 2))
  end
  _queue = {}
end

return GRAPH_UI

