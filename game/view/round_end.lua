FONT = require 'view.helpers.font' 

local ROUND_END = {}

function ROUND_END.load()
	FONT.set(32)
end

function ROUND_END.update(dt)
	local w, h = love.graphics.getDimensions()
end

function ROUND_END.draw(text)
	local g = love.graphics
  local w, h = g.getDimensions()
  g.push()
  g.setColor(0, 0, 0, 90)
  g.rectangle('fill', 0, 0, w, h)
  g.setColor(255, 255, 255)
  g.print("Round won\n\n" .. "    " .. text .. " wins", w/2 + 100, h/2)
  g.pop()

end

return ROUND_END
