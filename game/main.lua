local MAP_LOADER = require 'map_loader'
local MOUSE = require 'view.helpers.mouse'
local CURSOR = require 'view.cursor'
local BG = require 'view.background'

local who_won

gamestates = {
  require 'states.virus',
  require 'states.wait',
  require 'states.antivirus',
  require 'states.inter_round'
}
local counter = 1

local _state = gamestates[1]

local _bgm

function setWhoWon(winner)
  who_won = winner
end

function getWhoWon()
  return who_won
end

function newState(round_end, ...)
  counter = counter%#gamestates + 1
  _state = gamestates[counter]
  _state.load(...)

  return _state
end

function love.load(arg)
  if arg[2] then
    DEBUG = true
  end
  _bgm = love.audio.newSource("assets/bgm/tyops_futuristic-suspense-synth.ogg")
  _bgm:setVolume(0.1)
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
