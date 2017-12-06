local TEXT_SCREEN = require 'view.text_screen'
local MOUSE = require 'view.helpers.mouse'
local ANTIVIRUS = require 'states.antivirus'
local MAP_LOADER = require 'map_loader'

local TITLE = {}

function TITLE.load()
	TEXT_SCREEN.load()
end

function TITLE.update(dt)
	if MOUSE.clicked(1) then
		newState()
	end
end

function  TITLE.draw()
	TEXT_SCREEN.draw('Network Battle:\nChain Hostility')
end

function TITLE.keypressed(key)
	if key == 'space' then
		newState()
	end
end

return TITLE
