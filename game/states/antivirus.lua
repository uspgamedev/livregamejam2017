
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

local MAP = {
  {200, 300},
  {500, 400},
  {600, 100},
}

local DIR = {
  'left', 'right', 'up', 'down',
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

local function getMidpoint(a, b)
  k = -8

  dX = (MAP[b][1]-MAP[a][1])
  dY = (MAP[b][2]-MAP[a][2])
  norm = 1/math.sqrt(dX*dX + dY*dY)
  xMid = (MAP[a][1] + MAP[b][1])/2
  yMid = (MAP[a][2] + MAP[b][2])/2
  x = (dY*norm)*k + xMid
  y = (-dX*norm)*k + yMid

  return {x, y}
end

function ANTIVIRUS.load()
  _selected = 0
  ANTIVIRUS_HUD.load()
	GRAPH_UI.load(3)
  GRAPH_LOGIC.load(3)
end

function ANTIVIRUS.update(dt)
  -- Calculate turn time
  _turn_cooldown = _turn_cooldown + dt
  while _turn_cooldown >= _TURN_TIME do
    GRAPH_LOGIC.turn()
    _turn_cooldown = _turn_cooldown - _TURN_TIME
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
  for i=1,3 do
    GRAPH_UI.node(i, MAP[i][1], MAP[i][2])
  end

  -- Draw edges
  for i=1,#GRAPH_LOGIC.nodes() do
    for j=i+1,#GRAPH_LOGIC.nodes() do
      if GRAPH_LOGIC.edges()[i][j] and
         GRAPH_UI.edge(i, j, GRAPH_LOGIC.edges()[i][j].weight, getMidpoint(i, j)) then
        if action == 'lock_route' then
          GRAPH_LOGIC.edges()[i][j].locked = true
          GRAPH_LOGIC.edges()[i][j].resetIn = 5
          _selected = 0
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
  GRAPH_LOGIC.turn()
end

return ANTIVIRUS
