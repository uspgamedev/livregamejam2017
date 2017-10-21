
local MOUSE = require 'view.helpers.mouse'
local ANTIVIRUS_HUD = {}

local _RADIUS = 32

local _icons = {}
local _actions = {}

local _glow_phase = 0

local _GLOW_CODE = [[
extern number phase;
vec4 effect(vec4 color, Image texture, vec2 tex_coords, vec2 screen_coords) {
  vec4 texturecolor = Texel(texture, tex_coords);
  return texturecolor * color + phase*texturecolor.a*vec4(1,1,1,1);
}
]]

local _GLOW_SHADER

local function _loadIcon(name)
  local icon = _icons[name] if not icon then
    icon = love.graphics.newImage(("assets/icons/%s.png"):format(name))
    _icons[name] = icon
  end
  return icon
end

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
  local clicked = MOUSE.clicked() and near
  table.insert(
    _actions,
    {
      name = action_name,
      hovered = near or selected,
      selected = selected
    }
  )
  return near and clicked
end

function ANTIVIRUS_HUD.draw()
  local g = love.graphics
  local i = 0
  for _,action in ipairs(_actions) do
    g.push()
    g.translate(_iconPos(i))
    g.scale(1/8, 1/8)
    g.setColor(255, 255, 255, 100 + 155*(action.hovered and 1 or 0))
    if action.selected then
      g.setShader(_GLOW_SHADER)
    end
    g.draw(_loadIcon(action.name), 0, 0, 0, 1, 1, 256, 256)
    g.pop()
    i = i + 1
    g.setShader()
  end
end

return ANTIVIRUS_HUD

