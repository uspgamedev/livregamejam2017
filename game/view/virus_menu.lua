
local VEC2  = require 'cpml.vec2'
local FONT  = require 'view.helpers.font'
local MOUSE = require 'view.helpers.mouse'
local VIRUS_MENU = {}

local _SLOT_HOOK = VEC2(200, 200)
local _SLOT_SIZE = VEC2(200, 40)
local _SLOT_GAP = 20
local _SLOT_CROSS = 160

local _max_strategies
local _slots
local _strategies

local function _slotBounds(i, global)
  local topleft = VEC2(0,1) * (_SLOT_SIZE.y + _SLOT_GAP)*(i-1)
  if global then
    topleft = topleft + _SLOT_HOOK
  end
  return topleft.x, topleft.x + _SLOT_SIZE.x,
         topleft.y, topleft.y + _SLOT_SIZE.y
end

function VIRUS_MENU.load(max_strategies)
  _max_strategies = max_strategies
end

function VIRUS_MENU.update(dt)
  _strategies = {}
end

function VIRUS_MENU.slot(name)
  local l,r,t,b = _slotBounds(#_strategies, true)
  local mx, my = MOUSE.pos()
  local inside = mx > l + _SLOT_CROSS and mx < r and my > t and my < b
  table.insert(_strategies, { name = name, hover = inside })
  return inside and MOUSE.clicked(1)
end

function VIRUS_MENU.option(name)
end

function VIRUS_MENU.draw()
  local g = love.graphics
  for i=1,_max_strategies do
    g.push()
    g.translate(_SLOT_HOOK:unpack())
    local l,r,t,b = _slotBounds(i-1)
    local strategy = _strategies[i]
    if strategy.name then
      g.setColor(100, 240, 100, 255)
      g.rectangle('fill', l, t, r-l, b-t)
      if strategy.hover then
        g.setColor(200, 240, 200, 255)
        g.rectangle('fill', l + _SLOT_CROSS, t, b-t, b-t)
      end
      g.setColor(80, 20, 20, 255)
      g.line(l + _SLOT_CROSS + 8, t + 8, r - 8, b - 8)
      g.line(l + _SLOT_CROSS + 8, b - 8, r - 8, t + 8)
      FONT.set(24)
      local pad = (_SLOT_SIZE.y - FONT.height(24))/2
      g.printf(strategy.name, l + pad, t + pad, _SLOT_CROSS - 2*pad, 'left')
    else
      g.setColor(100, 240, 100, 255)
      g.rectangle('line', l, t, r-l, b-t)
    end
    g.pop()
  end
end

return VIRUS_MENU

