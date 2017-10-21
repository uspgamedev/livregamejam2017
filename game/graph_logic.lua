
local GRAPH_LOGIC = {}

local _initialNode = 1 -- Test only variable
local _testEdges = {{0, 5, 0}, {5, 0, 8}, {0, 8, 0}} -- Test only variable to simulate a file input
local _power = 30
local _lastInfected = false
local _nodes = {}
local _edges = {}

local function compare(a, b)
  return a.fin.pcs < b.fin.pcs
end

function bfsWeight(neighs)
  local finish = true
  local counter = _power
  local notFullNodes = #neighs
  local avg = _power/#neighs
  while (counter ~= 0 and not finish) do
    finish = true
    avg = counter/notFullNodes
    for i=1,#neighs do
      local fin = _nodes[neighs[i].fin]
      if not fin.infected and neighs[i].passing ~= 0 then
        local add = math.min(fin.pcs-fin.infectedPcs, avg, counter, neighs[i].passing)
        fin.infectedPcs = fin.infectedPcs + add
        neighs[i].passing = neighs[i].passing - add
        counter = counter - add
        if fin.infectedPcs == fin.pcs then
          fin.infected = true
          notFullNodes = notFullNodes - 1
        end
        finish = false
      end
    end
  end
end

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
      _edges[i][j] = (_testEdges[i] ~= 0) and ((j < i) and _edges[j][i] or { weight = 5 }) or false
    end
  end
  -- Add initial node to _infectedNodes Nodes
end

function GRAPH_LOGIC.update(dt)
  local neighNodes = {}
  for i=1,#_nodes do
    for j=i+1,#_nodes do
      if _edges[i][j] then
        if not _nodes[i].infected and _nodes[j].infected then
          table.insert(neighNodes, { ini = j, fin = i, passing = _edges[i][j].weight })
        elseif _nodes[i].infected and not _nodes[j].infected then
          table.insert(neighNodes, { ini = i, fin = j, passing = _edges[i][j].weight })
        end
      end
    end
  end
  table.sort(neighNodes, compare)
  bfsWeight(neighNodes)
end

GRAPH_LOGIC.nodes = _nodes
GRAPH_LOGIC.edges = _edges

return GRAPH_LOGIC
