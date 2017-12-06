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
		newState()
	end
end

function INTER_ROUND.draw()
	if verifyVictory() then
		TEXT_SCREEN.draw("Match won\n\n" .. "    " .. getWhoWon() .. " wins")
	else
		TEXT_SCREEN.draw("Round won\n\n" .. "    " .. getWhoWon() .. " wins")
	end
end

function INTER_ROUND.keypressed(key)
	if key == 'space' then
		newState()
	end
end

return INTER_ROUND
