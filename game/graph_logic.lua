local GRAPH_LOGIC = {}
local MAP_LOADER = require 'map_loader'


local _initialNode = 1 -- Test only variable

local _resetInCons = 10 -- Change this at antivirus.lua too, when drawing edges

local _testEdges -- Test only variable to simulate a file input

local _power = 4
local _nodes = {}
local _edges = {}

local function newNode(capacity)
  return {
    pcs = capacity,
    infectedPcs = 0,
    infected = false,
    resetIn = 0,
    hasIntel = false,
    hasProbe = false,
    probeResetIn = 0,
    protected = false
  }
end

local function newEdge(w)
  return (w ~= 0) and { weight = w, locked = false, resetIn = 0 } or false
end

function GRAPH_LOGIC.load(n)
  _nodes = {}
  _edges = {}
  _testEdges = MAP_LOADER.getEdges()
  for i=1,n do
	  _nodes[i] = newNode(MAP_LOADER.getCapacity()[i])
  end
  local infected = MAP_LOADER.getInfected()
  _nodes[infected].infectedPcs = _nodes[infected].pcs
  _nodes[infected].infected = true
  _nodes[infected].resetIn = _resetInCons
  local intel = MAP_LOADER.getIntel()
  _nodes[intel].hasIntel = true
  local protected = MAP_LOADER.getProtected()
  _nodes[protected].protected = true
  for i=1,n do
		_edges[i] = {}
		-- Add file infos to edges
		for j=1,n do
		  _edges[i][j] = (j < i) and _edges[j][i] or newEdge(_testEdges[i][j])
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
          fin.resetIn = _resetInCons
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

function random(neighs)
  local finish = false
  local pcounter = _power
  local ncounter = 0
  local r = love.math.random(#neighs)
  local fin = _nodes[neighs[r].fin]
  while pcounter ~= 0 and ncounter ~= #neighs do
    if not fin.infected then
      local add = math.min(fin.pcs-fin.infectedPcs, pcounter, neighs[r].passing)
      fin.infectedPcs = fin.infectedPcs + add
      pcounter = pcounter - add
      if fin.infectedPcs == fin.pcs then
        fin.resetIn = _resetInCons
        fin.infected = true
      end
    end
    fin = _nodes[neighs[love.math.random(#neighs)].fin]
    ncounter = ncounter + 1
  end
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
        fin.resetIn = _resetInCons
        fin.infected = true
      end
    end
    i = i + 1
  end
end

function focusBreadth(neighs)
  local finish = false
  local counter = _power
  local notFullNodes = #neighs - 1
  local avg = _power/(#neighs-1)
  local fin = _nodes[neighs[1].fin]
  local add = math.min(fin.pcs-fin.infectedPcs, counter, neighs[1].passing)
  fin.infectedPcs = fin.infectedPcs + add
  counter = counter - add
  if fin.infectedPcs == fin.pcs then
	fin.infected = true
  end
  while (counter ~= 0 and not finish) do
    finish = true
    avg = counter/notFullNodes
    for i=2,#neighs do
      fin = _nodes[neighs[i].fin]
      if not fin.infected and neighs[i].passing ~= 0 then
        add = math.min(fin.pcs-fin.infectedPcs, avg, counter, neighs[i].passing)
        fin.infectedPcs = fin.infectedPcs + add
        neighs[i].passing = neighs[i].passing - add
        counter = counter - add
        print(fin.infectedPcs, fin.pcs)
        if fin.infectedPcs == fin.pcs then
          fin.infected = true
          fin.resetIn = _resetInCons
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

function moveVirus(type, neighNodes)
  local neighNodes = {}
  for i=1,#_nodes do
    for j=i+1,#_nodes do
      if _edges[i][j] and not _edges[i][j].locked then
        if not _nodes[i].infected and _nodes[j].infected and not _nodes[i].protected then
          table.insert(neighNodes, { ini = j, fin = i, passing = _edges[i][j].weight })
        elseif _nodes[i].infected and not _nodes[j].infected and not _nodes[j].protected then
          table.insert(neighNodes, { ini = i, fin = j, passing = _edges[i][j].weight })
        end
      elseif _edges[i][j] and _edges[i][j].locked then
        _edges[i][j].resetIn = _edges[i][j].resetIn - 1
        if _edges[i][j].resetIn == 0 then
          _edges[i][j].locked = false
        end
      end
    end
    if _nodes[i].infected then
      _nodes[i].resetIn = _nodes[i].resetIn - 1
      if _nodes[i].resetIn == 0 then
        _nodes[i].infected = false
        _nodes[i].infectedPcs = 0
      end
    end
    if _nodes[i].hasProbe then
      _nodes[i].probeResetIn = _nodes[i].probeResetIn - 1
      if _nodes[i].probeResetIn == 0 then
        _nodes[i].hasProbe = false
      end
    end
    if _nodes[i].hasIntel and _nodes[i].infected then
      print("Virus wins!!!")
      return
    end
    if _nodes[i].hasIntel and _nodes[i].protected then
      print("CIA wins!!!")
      return
    end
  end
  for i,edge in ipairs(neighNodes) do
	  print(i, tostring(edge.ini)..','..tostring(edge.fin), edge.passing)
  end
  if type == 0 then
  	print('BFS')
  	breadth(neighNodes)
  elseif type == 1 then
  	print('Random')
  	random(neighNodes)
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
    print(i, tostring(node.infectedPcs).."/"..tostring(node.pcs), node.infected, node.resetIn, node.probeResetIn)
  end
end

function GRAPH_LOGIC.turn()
  moveVirus(3, neighNodes) -- Set the type of the move here
end

function GRAPH_LOGIC.nodes()
  return _nodes
end

function GRAPH_LOGIC.edges()
  return _edges
end

function GRAPH_LOGIC.connected(i, j)
  return not not _edges[i][j]
end

return GRAPH_LOGIC
