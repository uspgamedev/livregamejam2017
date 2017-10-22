local MAP_LOADER = require 'map_loader'
local VEC2 = require 'cpml.vec2'
local CURSOR = require 'view.cursor'
local MOUSE = require 'view.helpers.mouse'
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

local map

local DIR = {
  'left', 'right', 'sup', 'down',
  'a', 'd', 'w', 's',
  left = VEC2(-1,0),
  a = VEC2(-1,0),
  right = VEC2(1,0),
  d = VEC2(1,0),
  up = VEC2(0,-1),
  w = VEC2(0,-1),
  down = VEC2(0,1),
  s = VEC2(0,1),
}

local _selected = 0
local _turn_cooldown = 0
local _played = false
local _intelNode = 2
local _probeTime = 5

local function getMidpoint(a, b)
  k = -8

  dX = (map[b][1]-map[a][1])
  dY = (map[b][2]-map[a][2])
  norm = 1/math.sqrt(dX*dX + dY*dY)
  xMid = (map[a][1] + map[b][1])/2
  yMid = (map[a][2] + map[b][2])/2
  x = (dY*norm)*k + xMid
  y = (-dX*norm)*k + yMid

  return {x, y}
end

function ANTIVIRUS.load()
  _selected = 0
  ANTIVIRUS_HUD.load()
	GRAPH_UI.load(MAP_LOADER.getTotal())
  GRAPH_LOGIC.load(MAP_LOADER.getTotal())
  GRAPH_LOGIC.setStrategy{0, 4, 1, 0}
  for i,node in ipairs(GRAPH_LOGIC.nodes()) do
    if node.hasIntel then
      _intelNode = i
      break
    end
  end
  map = MAP_LOADER.getCurrMap()
end

function ANTIVIRUS.update(dt)
  -- Calculate turn time
  _turn_cooldown = _turn_cooldown + dt
  while _turn_cooldown >= _TURN_TIME do
    GRAPH_LOGIC.turn()
    _turn_cooldown = _turn_cooldown - _TURN_TIME
    _played = false
  end

  -- Draw HUD
  ANTIVIRUS_HUD.update(dt)
  for i,action in ipairs(_ACTIONS) do
    if ANTIVIRUS_HUD.action(action, i == _selected) then
      _selected = _selected == i and 0 or i
    end
  end
  ANTIVIRUS_HUD.turnClock(_turn_cooldown/_TURN_TIME)

  GRAPH_UI.update(dt)

  local action = _ACTIONS[_selected]

  if action then
    CURSOR.crosshairs()
  else
    CURSOR.pointer()
  end

  if MOUSE.clicked(2) then
    _selected = 0
  end

  -- Draw nodes
  for i=1, MAP_LOADER.getTotal()  do
    if GRAPH_UI.node(i, map[i][1], map[i][2]) then
      -- Add _selected = 0 and _turn_cooldown = _TURN_TIME in every action
      if action == 'move_intel' and GRAPH_LOGIC.connected(_intelNode, i) then
        GRAPH_LOGIC.nodes()[_intelNode].hasIntel = false
        GRAPH_LOGIC.nodes()[i].hasIntel = true
        _intelNode = i
        _selected = 0
        _turn_cooldown = _TURN_TIME
      elseif action == 'probe_cluster' then
        GRAPH_LOGIC.nodes()[i].hasProbe = true
        GRAPH_LOGIC.nodes()[i].probeResetIn = _probeTime
        _selected = 0
        _turn_cooldown = _TURN_TIME
      end
    end
  end

  -- Draw edges
  for i=1,#GRAPH_LOGIC.nodes() do
    for j=i+1,#GRAPH_LOGIC.nodes() do
      if GRAPH_LOGIC.edges()[i][j] and
         GRAPH_UI.edge(i, j, GRAPH_LOGIC.edges()[i][j].weight,
                       getMidpoint(i, j)) then
        -- Add _selected = 0 and _turn_cooldown = _TURN_TIME in every action
        if action == 'lock_route' then
          GRAPH_LOGIC.edges()[i][j].locked = true
          GRAPH_LOGIC.edges()[i][j].resetIn = 5
          _selected = 0
          _turn_cooldown = _TURN_TIME
        end
      end
    end
  end

  for _,dir in ipairs(DIR) do
    if love.keyboard.isDown(dir) then
      GRAPH_UI.moveCamera((DIR[dir]*(dt*200)):unpack())
    end
  end

end

function ANTIVIRUS.draw()
	GRAPH_UI.draw()
  ANTIVIRUS_HUD.draw()
end

function ANTIVIRUS.iterateVirus()
  _turn_cooldown = _TURN_TIME
end

return ANTIVIRUS
