local MAP_LOADER = require 'map_loader'
local MOUSE = require 'view.helpers.mouse'
local CURSOR = require 'view.cursor'
local BG = require 'view.background'

local who_won

gamestates = {
  require 'states.title',
  require 'states.virus',
  require 'states.wait',
  require 'states.antivirus',
  require 'states.inter_round'
}
local counter = 1
local _virus_pts = 0
local _antivirus_pts = 0

local _state = gamestates[1]

local _bgm

function setWhoWon(winner)
  if (winner == 0) then
    who_won = "Hackx0rz"
    _virus_pts = _virus_pts + 1
  else
    who_won = "Govenment"
    _antivirus_pts = _antivirus_pts + 1
  end
end

function getWhoWon()
  return who_won
end

function verifyVictory()
  if _virus_pts == 2 or _antivirus_pts == 2 then
    return true
	end
  return false
end

function newState(...)
  if counter == 5 then
    if verifyVictory() then
      _antivirus_pts = 0
      _virus_pts = 0
      counter = 1
    else
      print(_virus_pts, _antivirus_pts)
      counter = 2
    end
  else
    counter = counter%#gamestates + 1
  end
  print(counter)
  _state = gamestates[counter]
  _state.load(...)

  return _state
end

function love.load(arg)
  if arg[2] then
    DEBUG = true
  end
  _bgm = love.audio.newSource("assets/bgm/tyops_futuristic-suspense-synth.ogg")
  _bgm:setVolume(0.3)
  _bgm:setLooping(true)
  _bgm:play()
  MAP_LOADER.loadMaps()
  BG.load()
  CURSOR.load()
  _state.load()
  _virus_pts = 0
  _antivirus_pts = 0
end

function love.update(dt)
  BG.update(dt)
  MOUSE.update(dt)
  _state.update(dt)
end

function love.keypressed(key)
  (_state.keypressed or function() end)(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  BG.draw()
  _state.draw()
end
