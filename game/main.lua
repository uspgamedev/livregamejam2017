
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
  state.update(dt)
end

function love.keypressed(key)
  if key == 'space' then
    state = newState(state)
    state.load()
  end
end

function love.draw()
  state.draw()
end

