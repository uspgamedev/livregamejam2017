local _nodes = {}
local _edges = {}
local _linkedNodes = {}
local _initialNode = 1 -- Test only variable
local _testEdges = {{0, 5, 0}, {5, 0, 8}, {0, 8, 0}} -- Test only variable

function GRAPH_LOGIC.load(n, m)
  _nodes = {}
  _edges = {}
  for i=1,n do
    _nodes[i] = { computers = 10, infected = 0 }
  end
  _nodes[_initialNode].infected = 10
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
      table.insert(_linkedNodes, { id = node, rate = 0 })
    end
  end
end
