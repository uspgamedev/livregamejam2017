
local GRAPH_LOGIC = {}

local _initialNode = 1 -- Test only variable
local _testEdges = {{0, 5, 5},
                    {5, 0, 8},
                    {5, 8, 0}} -- Test only variable to simulate a file input

--[[local _testEdges = {{0, 5, 3, 7, 11, 0, 0},
                    {5, 0, 0, 0, 0, 0, 0},
                    {3, 0, 0, 0, 0, 0, 0},
                    {7, 0, 0, 0, 0, 0, 0},
                    {11, 0, 0, 0, 0, 2, 5},
                    {0, 0, 0, 0, 2, 0, 0},
                    {0, 0, 0, 0, 5, 0, 0}}]] -- Test only variable to simulate a file input
local _power = 3
local _lastInfected = false
local _nodes = {}
local _edges = {}

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
      _edges[i][j] = (_testEdges[i][j] ~= 0) and ((j < i) and _edges[j][i] or { weight = _testEdges[i][j] }) or false
    end
  end
  for i,line in ipairs(_edges) do
    for j,edge in ipairs(_edges[i]) do
      if not edge then
        print(i, j, "false")
      else
        print(i, j, edge.weight)
      end
    end
  end
end

local function compareD(a, b)
  return _nodes[a.fin].pcs > _nodes[b.fin].pcs
end

local function compareA(a, b)
  return _nodes[a.fin].pcs < _nodes[b.fin].pcs
end

function breadth(neighs)
  local finish = false
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
        print(fin.infectedPcs, fin.pcs)
        if fin.infectedPcs == fin.pcs then
          fin.infected = true
          notFullNodes = notFullNodes - 1
        end
        if neighs[i].passing == 0 then
          notFullNodes = notFullNodes - 1
        end
        finish = false
      end
    end
  end
end

function depth(neighs)
  print("Not implemented yet D:")
end

function focusDepth(neighs)
  local finish = false
  local counter = _power
  local i = 1
  while (counter ~= 0 and i <= #neighs) do
    local fin = _nodes[neighs[i].fin]
    if not fin.infected then
      local add = math.min(fin.pcs-fin.infectedPcs, counter, neighs[i].passing)
      fin.infectedPcs = fin.infectedPcs + add
      counter = counter - add
      if fin.infectedPcs == fin.pcs then
        fin.infected = true
      end
    end
    i = i + 1
  end
end

function focusBreadth(neighs)
  print('Not implemented yet D:')
end

function moveVirus(type, neighNodes)
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
  for i,edge in ipairs(neighNodes) do
    print(i, tostring(edge.ini)..','..tostring(edge.fin), edge.passing)
  end
  if type == 0 then
    print('BFS')
    breadth(neighNodes)
  elseif type == 1 then
    print('DFS')
    depth(neighNodes)
  elseif type == 2 then
    print('Depth greedy')
    table.sort(neighNodes, compareD)
    focusDepth(neighNodes)
  elseif type == 3 then
    print('Depth humble')
    table.sort(neighNodes, compareA)
    focusDepth(neighNodes)
  elseif type == 4 then
    print('Beadth greedy')
    table.sort(neighNodes, compareD)
    focusBreadth(neighNodes)
  elseif type == 5 then
    print('Beadth humble')
    table.sort(neighNodes, compareA)
    focusBreadth(neighNodes)
  end
  for i,node in ipairs(_nodes) do
    print(i, tostring(node.infectedPcs).."/"..tostring(node.pcs), node.infected)
  end
end

function GRAPH_LOGIC.turn()
  moveVirus(3, neighNodes)
end

function GRAPH_LOGIC.nodes()
  return _nodes
end

function GRAPH_LOGIC.edges()
  return _edges
end

return GRAPH_LOGIC
