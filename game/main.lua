local MAP_LOADER = require 'map_loader'
local MOUSE = require 'view.helpers.mouse'
local CURSOR = require 'view.cursor'
local BG = require 'view.background'

gamestates = {
  virus = require 'states.virus',
  antivirus = require 'states.antivirus'
}

local _state = gamestates.virus

local _bgm

function newState()
  if _state == gamestates.virus then
    _state = gamestates.antivirus
    _state.load()
  else
    _state = gamestates.virus
    _state.load()
  end

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
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  BG.draw()
  _state.draw()
end
