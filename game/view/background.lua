
local BG = {}

local _EFFECT_CODE = [[
extern vec2 size;
vec4 effect(vec4 color, Image _unused1, vec2 _unused2, vec2 pos) {
  vec2 center = size/2;
  number dist = min(distance(center, pos)/600, 1);
  return dist*vec4(0.1,0.3,0.1,1);
}

]]

local _EFFECT_SHADER

function BG.load()
  _EFFECT_SHADER = love.graphics.newShader(_EFFECT_CODE)
  _EFFECT_SHADER:send('size', { love.graphics.getDimensions() })
end

function BG.update(dt)
end

function BG.draw()
  local g = love.graphics
  local w, h = g.getDimensions()
  g.push()
  g.setShader(_EFFECT_SHADER)
  g.rectangle('fill', 0, 0, w, h)
  g.setShader()
  g.pop()
end

return BG

