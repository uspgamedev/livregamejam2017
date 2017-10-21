
local GRAPH_UI = require 'graph_ui'
local GRAPH_LOGIC = require 'graph_logic'

function love.load()
  GRAPH_UI.load(3)
  GRAPH_LOGIC.load(3)
end

function love.update(dt)
  GRAPH_UI.update(dt)
  if GRAPH_UI.node(1, 200, 300) then
    print("node 1")
  end
  GRAPH_UI.node(2, 500, 400)
  GRAPH_UI.node(3, 600, 100)
end

function love.draw()
  GRAPH_UI.draw()
end
