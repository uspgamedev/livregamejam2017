
local MAP_LOADER = require 'map_loader'
local MOUSE = require 'view.helpers.mouse'
local CURSOR = require 'view.cursor'
local BG = require 'view.background'

local gamestates = {
  virus = require 'states.virus',
  antivirus = require 'states.antivirus'
}

local state = gamestates.virus

local _bgm

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
  state.load()
end

local function newState(state)
  if state == gamestates.virus then
    state = gamestates.antivirus
  else
    state = gamestates.virus
  end

  return state
end

function love.update(dt)
  BG.update(dt)
  MOUSE.update(dt)
  state.update(dt)
end

function love.keypressed(key)
  if key == 'space' then
    state = newState(state)
    state.load()
  elseif key == 'l' then
    state.iterateVirus()
  elseif key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  BG.draw()
  state.draw()
end
