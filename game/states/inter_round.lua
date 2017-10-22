local TEXT_SCREEN = require 'view.text_screen'
local MOUSE = require 'view.helpers.mouse'
local ANTIVIRUS = require 'states.antivirus'
local MAP_LOADER = require 'map_loader'

local INTER_ROUND = {}

function INTER_ROUND.load()
	TEXT_SCREEN.load()
end

function INTER_ROUND.update(dt)
	ANTIVIRUS.update(dt)

	if MOUSE.clicked(1) then
		MAP_LOADER.switchMap()
		newState()
	end
end

function INTER_ROUND.draw()
	TEXT_SCREEN.draw("Round won\n\n" .. "    " .. getWhoWon() .. " wins")
end

function INTER_ROUND.keypressed(key)
	if key == 'space' then
		MAP_LOADER.switchMap()
		newState()
	end
end

return INTER_ROUND
