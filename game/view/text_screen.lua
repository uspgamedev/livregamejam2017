FONT = require 'view.helpers.font'

local TEXT_SCREEN = {}

function TEXT_SCREEN.load()
	FONT.set(32)
end

function TEXT_SCREEN.draw(text)
	local g = love.graphics
  local w, h = g.getDimensions()
  g.push()
  g.setColor(0, 0, 0, 90)
  g.rectangle('fill', 0, 0, w, h)
  g.setColor(255, 255, 255)
  g.print(text, w/2 + 100, h/2)
  g.pop()

end

return TEXT_SCREEN
