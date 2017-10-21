
local GRAPH_UI = require 'graph_ui'

function love.load()
  GRAPH_UI.load(1)
end

function love.update(dt)
  GRAPH_UI.update(dt)
  GRAPH_UI.node(1, 400, 300)
end

function love.draw()
  GRAPH_UI.draw()
end

