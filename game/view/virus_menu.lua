
local VEC2  = require 'cpml.vec2'
local FONT  = require 'view.helpers.font'
local MOUSE = require 'view.helpers.mouse'
local ICON  = require 'view.helpers.icon'
local VIRUS_MENU = {}

local _SLOT_HOOK = VEC2(200, 200)
local _SLOT_SIZE = VEC2(200, 40)
local _SLOT_GAP = 20
local _SLOT_CROSS = 160

local _OPTION_HOOK = VEC2(600, 200)
local _OPTION_SIZE = VEC2(80, 80)
local _OPTION_GAP = 20

local _max_strategies
local _slots
local _strategies
local _options
local _confirm_hovered

local function _slotBounds(i, global)
  local topleft = VEC2(0,1) * (_SLOT_SIZE.y + _SLOT_GAP)*(i-1)
  if global then
    topleft = topleft + _SLOT_HOOK
  end
  return topleft.x, topleft.x + _SLOT_SIZE.x,
         topleft.y, topleft.y + _SLOT_SIZE.y
end

local function _optionBounds(i, global)
  i = i-1
  local j = i % 4
  local i = math.floor(i / 4)
  local topleft = VEC2(1,0) * (_OPTION_SIZE.x + _OPTION_GAP)*j
                + VEC2(0,1) * (_OPTION_SIZE.y + _OPTION_GAP)*i
  if global then
    topleft = topleft + _OPTION_HOOK
  end
  return topleft.x, topleft.x + _OPTION_SIZE.x,
         topleft.y, topleft.y + _OPTION_SIZE.y
end

local function _confirmBounds()
  local w,h = love.graphics.getDimensions()
  return w - 400, w - 200, h - 200, h - 160
end

function VIRUS_MENU.load(max_strategies)
  _max_strategies = max_strategies
end

function VIRUS_MENU.update(dt)
  _strategies = {}
  _options = {}
end

function VIRUS_MENU.slot(name)
  local l,r,t,b = _slotBounds(#_strategies + 1, true)
  local mx, my = MOUSE.pos()
  local inside = mx > l + _SLOT_CROSS and mx < r and my > t and my < b
  table.insert(_strategies, { name = name, hover = inside })
  return inside and MOUSE.clicked(1)
end

function VIRUS_MENU.option(name)
  local l,r,t,b = _optionBounds(#_options + 1, true)
  local mx, my = MOUSE.pos()
  local inside = mx > l and mx < r and my > t and my < b
  table.insert(_options, { name = name, hover = inside })
  return inside and MOUSE.clicked(1)
end

function VIRUS_MENU.confirm()
  local l,r,t,b = _confirmBounds()
  local mx, my = MOUSE.pos()
  local inside = mx > l and mx < r and my > t and my < b
  _confirm_hovered = inside
  return inside and MOUSE.clicked(1)
end

function VIRUS_MENU.draw()
  local g = love.graphics
  for i=1,_max_strategies do
    g.push()
    g.translate(_SLOT_HOOK:unpack())
    local l,r,t,b = _slotBounds(i)
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
  for i,option in ipairs(_options) do
    g.push()
    g.translate(_OPTION_HOOK:unpack())
    local l,r,t,b = _optionBounds(i)
    g.setColor(255, 2550, 255, 255)
    if option.hover then
      g.setColor(200, 240, 200, 255)
    else
      g.setColor(100, 240, 100, 255)
    end
    g.rectangle('fill', l, t, r-l, b-t)
    g.setColor(80, 20, 20, 255)
    g.draw(ICON.load(option.name), (l+r)/2, (t+b)/2, 0,
                                   1/4, 1/4,
                                   256, 256)
    g.pop()
  end
  local l,r,t,b = _confirmBounds()
  if _confirm_hovered then
    g.setColor(200, 240, 200, 255)
  else
    g.setColor(100, 240, 100, 255)
  end
  g.rectangle('fill', l, t, r-l, b-t)
  FONT.set(24)
  local pad = (_SLOT_SIZE.y - FONT.height(24))/2
  g.setColor(80, 20, 20, 255)
  g.printf("compile", l, t+pad, r - l, 'center')
end

return VIRUS_MENU

