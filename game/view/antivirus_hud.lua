
local COLOR = require 'cpml.color'
local MOUSE = require 'view.helpers.mouse'
local ICON  = require 'view.helpers.icon'
local FONT  = require 'view.helpers.font'
local GRAPH_LOGIC = require 'graph_logic'
local ANTIVIRUS_HUD = {}

local _TEXT_COLOR = COLOR(240, 240, 240, 255)
local _RADIUS = 32

local _GLOW_CODE = [[
extern number phase;
vec4 effect(vec4 color, Image texture, vec2 tex_coords, vec2 screen_coords) {
  vec4 texturecolor = Texel(texture, tex_coords);
  return texturecolor * color + phase*texturecolor.a*vec4(1,1,1,1);
}
]]

local _GLOW_SHADER

local _actions = {}
local _turn_progress = 0

local _glow_phase = 0

local function _iconPos(i)
  return 64 + (i%2)*64, 64 + 40*i
end

function ANTIVIRUS_HUD.load()
  _GLOW_SHADER = love.graphics.newShader(_GLOW_CODE)
end

function ANTIVIRUS_HUD.update(dt)
  _actions = {}
  _glow_phase = math.fmod(_glow_phase + dt*1.2, 1)
  _GLOW_SHADER:send('phase', 1 - math.sin(_glow_phase * math.pi))
end

function ANTIVIRUS_HUD.action(action_name, selected)
  local x, y = _iconPos(#_actions)
  local mx, my = MOUSE.pos()
  local near = (mx - x)^2 + (my - y)^2 < _RADIUS^2
  local clicked = MOUSE.clicked(1) and near
  table.insert(
    _actions,
    {
      name = action_name,
      hovered = near or selected,
      selected = selected
    }
  )
  if near and clicked then
    _glow_phase = 0
    return true
  end
end

function ANTIVIRUS_HUD.turnClock(progress)
  _turn_progress = progress
end

function ANTIVIRUS_HUD.draw()
  local g = love.graphics
  local w, h = g.getDimensions()
  local i = 0
  for _,action in ipairs(_actions) do
    g.push()
    g.translate(_iconPos(i))
    g.scale(1/8, 1/8)
    g.setColor(255, 255, 255, 100 + 155*(action.hovered and 1 or 0))
    if action.selected then
      g.setShader(_GLOW_SHADER)
    end
    g.draw(ICON.load(action.name), 0, 0, 0, 1, 1, 256, 256)
    g.pop()
    i = i + 1
    g.setShader()
  end
  g.setColor(200, 200, 50, 255)
  g.rectangle('fill', 32, h - 32, _turn_progress*(w - 64), 4)
  local total, infected = 0, 0
  for _,node in ipairs(GRAPH_LOGIC.nodes()) do
    total = total + node.pcs
    infected = infected + node.infectedPcs
  end
  FONT.set(20)
  g.setColor(_TEXT_COLOR)
  g.print(("%d/%d"):format(infected, total), w - 100, 100)
end

return ANTIVIRUS_HUD

