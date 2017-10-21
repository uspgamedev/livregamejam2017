
local GRAPH_LOGIC = require 'graph_logic'
local GRAPH_UI = require 'view.graph_ui'
local ANTIVIRUS_HUD = require 'view.antivirus_hud'
local ANTIVIRUS = {}

function ANTIVIRUS.load()
  ANTIVIRUS_HUD.load()
	GRAPH_UI.load(3)
  GRAPH_LOGIC.load(3)
end

function ANTIVIRUS.update(dt)
  ANTIVIRUS_HUD.update(dt)
  print(GRAPH_LOGIC.nodes()[1].infectedPcs)
  if ANTIVIRUS_HUD.action('move_intel') then
    print("move intel!")
  end
  ANTIVIRUS_HUD.action('move_intel')
  ANTIVIRUS_HUD.action('move_intel')
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

return ANTIVIRUS
