local TEXT_SCREEN = require 'view.text_screen'
local MOUSE = require 'view.helpers.mouse'
local ANTIVIRUS = require 'states.antivirus'
local MAP_LOADER = require 'map_loader'

local WAIT = {}

function WAIT.load()
	TEXT_SCREEN.load()
end

function WAIT.update(dt)
	if MOUSE.clicked(1) then
		newState()
	end
end

function  WAIT.draw()
	TEXT_SCREEN.draw('Waiting for government...')
end

function WAIT.keypressed(key)
	if key == 'space' then
		newState()
	end
end

return WAIT
