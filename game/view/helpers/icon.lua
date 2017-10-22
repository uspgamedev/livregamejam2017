
local ICON = {}

local _icons = {}

function ICON.load(name)
  name = name:gsub(' ', '')
  local icon = _icons[name] if not icon then
    icon = love.graphics.newImage(("assets/icons/%s.png"):format(name))
    _icons[name] = icon
  end
  return icon
end

return ICON

