
local GRAPH_LOGIC = require 'graph_logic'
local GRAPH_UI = require 'view.graph_ui'
local ANTIVIRUS_HUD = require 'view.antivirus_hud'
local ANTIVIRUS = {}

local _TURN_TIME = 12

local _ACTIONS = {
  'move_intel',
  'lock_route',
  'probe_cluster',
}

local MAP = {
  {200, 300}, 
  {500, 400},
  {600, 100},
}

local _selected = 0
local _turn_cooldown = 0

local function getMidpoint(a, b)
  x = (MAP[a][1] + MAP[b][1])/2
  y = (MAP[a][2] + MAP[b][2])/2

  return {x, y}
end

function ANTIVIRUS.load()
  _selected = 0
  ANTIVIRUS_HUD.load()
	GRAPH_UI.load(3)
  GRAPH_LOGIC.load(3)
end

function ANTIVIRUS.update(dt)
  _turn_cooldown = _turn_cooldown + dt
  while _turn_cooldown >= _TURN_TIME do
    GRAPH_LOGIC.turn()
    _turn_cooldown = _turn_cooldown - _TURN_TIME
  end

  ANTIVIRUS_HUD.update(dt)
  for i,action in ipairs(_ACTIONS) do
    if ANTIVIRUS_HUD.action(action, i == _selected) then
      _selected = i
      print("action", i, action)
    end
  end
  ANTIVIRUS_HUD.turnClock(_turn_cooldown/_TURN_TIME)

  GRAPH_UI.update(dt)

  -- Draw nodes
  for i=1,3 do
    GRAPH_UI.node(i, MAP[i][1], MAP[i][2])
  end

  -- Draw edges
  for i=1,#GRAPH_LOGIC.nodes() do
    for j=i+1,#GRAPH_LOGIC.nodes() do
      if GRAPH_LOGIC.edges()[i][j] then
        GRAPH_UI.edge(i, j, GRAPH_LOGIC.edges()[i][j].weight, getMidpoint(i, j))
      end
    end
  end

end

function ANTIVIRUS.draw()
	GRAPH_UI.draw()
  ANTIVIRUS_HUD.draw()
end

function ANTIVIRUS.iterateVirus()
  GRAPH_LOGIC.turn()
end

return ANTIVIRUS

