
local BG = {}

local _EFFECT_CODE = [[
extern vec2 size;
extern number vpulse;
extern number phase;
const number MARGIN = 300;
const number DECAY = 300;
const vec4 LIGHT = vec4(0.1,0.3,0.2,1);
const vec4 LINE = vec4(0.3,0.1,0.2,1);
vec4 effect(vec4 color, Image _unused1, vec2 _unused2, vec2 pos) {
  vec2 center = size/2;
  vec2 box = size - MARGIN;
  number left = center.x - box.x/2;
  number right = center.x + box.x/2;
  number top = center.y - box.y/2;
  number bottom = center.y + box.y/2;
  vec2 nearest = vec2(max(left, min(right, pos.x)),
                      max(top, min(bottom, pos.y)));
  number dist = max(0.2, min(distance(nearest, pos)/DECAY, 1));
  number vline = smoothstep(0.98, 1.0, sin(pos.x/6));
  vline *= (1 + 1/max(0.5,distance(vpulse, pos.x)/8)*phase);
  number hline = smoothstep(0.98, 1.0, sin(pos.y/6));
  return dist*LIGHT + max(vline, hline)*LIGHT*dist;
}

]]

local _EFFECT_SHADER

local _PULSE_DELAY = 0.5

local _pulse

function BG.load()
  _EFFECT_SHADER = love.graphics.newShader(_EFFECT_CODE)
  _EFFECT_SHADER:send('size', { love.graphics.getDimensions() })
  _pulse = 0
end

function BG.update(dt)
  local w, h = love.graphics.getDimensions()
  _pulse = _pulse + dt
  _EFFECT_SHADER:send('phase', math.sin(_pulse/_PULSE_DELAY*math.pi))
  if _pulse >= _PULSE_DELAY then
    _EFFECT_SHADER:send('vpulse', love.math.random(w/6)*6)
    _pulse = 0
  end
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

