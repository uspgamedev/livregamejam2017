local ROUND_END = require 'view.round_end'
local MOUSE = require 'view.helpers.mouse'
local ANTIVIRUS = require 'states.antivirus'
local MAP_LOADER = require 'map_loader'

local INTER_ROUND = {}

function INTER_ROUND.load()
	ROUND_END.load()
end

function INTER_ROUND.update(dt)
	ANTIVIRUS.update(dt)
	ROUND_END.update(dt)

	if MOUSE.clicked(1) then
		MAP_LOADER.switchMap()
		newState()
	end
end

function  INTER_ROUND.draw()
	ROUND_END.draw(getWhoWon())
end

function INTER_ROUND.keypressed(key)
	if key == 'space' then
		MAP_LOADER.switchMap()
		newState()
	end
end

return INTER_ROUND