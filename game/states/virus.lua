
local SFX = require 'sound'
local VIRUS_MENU = require 'view.virus_menu'
local VIRUS = {}

local _strategies
local _max_strategies
local _options

function VIRUS.load()
  _max_strategies = 5
  _strategies = {}
  _options = {
    'spread', 'random', --'focus +', 'focus -', --'hybrid +', 'hybrid -',
    'hide', 'boost'
  }
  VIRUS_MENU.load(_max_strategies)
end

function VIRUS.update(dt)
  VIRUS_MENU.update(dt)
  for i=1,_max_strategies do
    if VIRUS_MENU.slot(_options[_strategies[i]]) then
      table.remove(_strategies, i)
      SFX.play "Deletando Hab op 2"
    end
  end
  for i,option in ipairs(_options) do
    if VIRUS_MENU.option(option) and #_strategies < _max_strategies then
      table.insert(_strategies, i)
      SFX.play "Escolhendo hab virus"
    end
  end
  if VIRUS_MENU.confirm() and #_strategies ~= 0 then
    newState(_strategies)
    SFX.play "Compilar"
  end
end

function  VIRUS.draw()
  VIRUS_MENU.draw()
end

return VIRUS
