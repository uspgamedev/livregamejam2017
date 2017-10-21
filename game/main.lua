
local MOUSE = require 'view.helpers.mouse'

local gamestates = {
  virus = require 'states.virus',
  antivirus = require 'states.antivirus'
}

local state = gamestates.virus

function love.load()
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
  MOUSE.update(dt)
  state.update(dt)
end

function love.keypressed(key)
  if key == 'space' then
    state = newState(state)
    state.load()
  end
  if key == 'l' then
    state.iterateVirus()
  end
end

function love.draw()
  state.draw()
end
