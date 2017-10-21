
local GRAPH_LOGIC = {}

local _nodes = {}
local _edges = {}
local _infectedNodes = {}
local _initialNode = 1 -- Test only variable
local _testEdges = {{0, 5, 0}, {5, 0, 8}, {0, 8, 0}} -- Test only variable to simulate a file input

function GRAPH_LOGIC.load(n)
  _nodes = {}
  _edges = {}
  for i=1,n do
    _nodes[i] = { pcs = 10*i, infectedPcs = 0, infected = false }
  end
  _nodes[_initialNode] = { pcs = 10, infectedPcs = 10, infected = true }
  for i=1,n do
    _edges[i] = {}
    -- Add file infos to edges
    for j=1,n do
      _edges[i][j] = (_testEdges[i] ~= 0) and ((j < i) and _edges[j][i] or { limit = 5 }) or false
    end
  end
  -- Add neighbors of initial node to linkedNodes
  for node,edge in ipairs(_edges[_initialNode]) do
    if edge then
      table.insert(_infectedNodes, { id = node, rate = 0 })
    end
  end
end

function compare(a, b)
  return a.pcs < b.pcs
end

function GRAPH_LOGIC.update(dt)
  table.sort(_infectedNodes, compare)
end

return GRAPH_LOGIC
