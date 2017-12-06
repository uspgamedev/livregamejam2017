local TEXT_SCREEN = require 'view.text_screen'
local MOUSE = require 'view.helpers.mouse'
local ANTIVIRUS = require 'states.antivirus'
local MAP_LOADER = require 'map_loader'

local WAIT = {}
local _states

function WAIT.load(states)
	_states = states
	TEXT_SCREEN.load()
end

function WAIT.update(dt)
	if MOUSE.clicked(1) then
		newState(4, _states)
	end
end

function  WAIT.draw()
	TEXT_SCREEN.draw('Waiting for government...')
end

function WAIT.keypressed(key)
	if key == 'space' then
		newState(4, _states)
	end
end

return WAIT
