
local GRAPH_LOGIC = require 'graph_logic'
local GRAPH_UI = require 'view.graph_ui'
local ANTIVIRUS_HUD = require 'view.antivirus_hud'
local ANTIVIRUS = {}

local _ACTIONS = {
  'move_intel',
  'lock_route',
  'probe_cluster',
}

local _selected = 0

function ANTIVIRUS.load()
  ANTIVIRUS_HUD.load()
	GRAPH_UI.load(3)
  GRAPH_LOGIC.load(3)
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
  if GRAPH_UI.node(1, 200, 300) then
    print("node 1")
  end
  GRAPH_UI.node(2, 500, 400)
  GRAPH_UI.node(3, 600, 100)
  if GRAPH_UI.edge(2, 3) then
    print("edge 23")
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
