
local VIRUS_MENU = require 'view.virus_menu'
local VIRUS = {}

local _strategies
local _max_strategies
local _options

function VIRUS.load()
  _max_strategies = 5
  _strategies = {'asd'}
  _options = {
    'BFS', 'RANDOM'
  }
  VIRUS_MENU.load(_max_strategies)
end

function VIRUS.update(dt)
  VIRUS_MENU.update(dt)
  for i=1,_max_strategies do
    if VIRUS_MENU.slot(_strategies[i]) then
      table.remove(_strategies, i)
    end
  end
  for _,option in ipairs(_options) do
    if VIRUS_MENU.option(option) then
      table.insert(_strategies, option)
    end
  end
end

function  VIRUS.draw()
  VIRUS_MENU.draw()
end

return VIRUS

