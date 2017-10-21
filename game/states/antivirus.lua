
local GRAPH_LOGIC = require 'graph_logic'
local GRAPH_UI = require 'view.graph_ui'
local ANTIVIRUS_HUD = require 'view.antivirus_hud'
local ANTIVIRUS = {}

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

function ANTIVIRUS.load()
  _selected = 0
  ANTIVIRUS_HUD.load()
	GRAPH_UI.load(3)
  GRAPH_LOGIC.load(7)
end

function ANTIVIRUS.update(dt)
  ANTIVIRUS_HUD.update(dt)
  for i,action in ipairs(_ACTIONS) do
    if ANTIVIRUS_HUD.action(action, i == _selected) then
      _selected = i
      print("action", i, action)
    end
  end
  GRAPH_UI.update(dt)

  for i=1,3 do
    GRAPH_UI.node(i, MAP[i][1], MAP[i][2])
  end
  GRAPH_UI.edge(2, 3)
end

function ANTIVIRUS.draw()
	GRAPH_UI.draw()
  ANTIVIRUS_HUD.draw()
end

function ANTIVIRUS.iterateVirus()
  GRAPH_LOGIC.turn()
end

return ANTIVIRUS
