
local ANTIVIRUS_HUD = {}

local _ACTIONS = {
  'move_intel', 'move_intel', 'move_intel'
}

local _icons = {}

local function _loadIcon(name)
  return love.graphics.newImage(("assets/icons/%s.png"):format(name))
end

function ANTIVIRUS_HUD.load()
  for _,action_name in ipairs(_ACTIONS) do
    _icons[action_name] = _loadIcon(action_name)
  end
end

function ANTIVIRUS_HUD.draw()
  local g = love.graphics
  local i = 0
  g.setColor(255, 255, 255, 255)
  for _,action_name in ipairs(_ACTIONS) do
    g.push()
    g.translate(40 + (i%2)*54, 40 + 32*i)
    g.scale(1/8, 1/8)
    g.draw(_icons[action_name])
    g.pop()
    i = i + 1
  end
end

return ANTIVIRUS_HUD

