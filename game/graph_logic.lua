
local GRAPH_LOGIC = {}
local MAP_LOADER = require 'map_loader'

local _resetInCons = 10 -- Change this at antivirus.lua too, when drawing edges

local _testEdges -- Test only variable to simulate a file input

local _power = 20
local _nodes = {}
local _edges = {}

local _strategy
local _next_strat = 1

local _sleeping = false
local _sleepResetIn = 0
local _SLEEP_MAX = 3

local _boost = false
local _boostResetIn = 0
local _BOOST_MAX = 3
local _BOOST_FACTOR = 4
local _virus_pts = 0
local _antivirus_pts = 0

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

function GRAPH_LOGIC.newGame()
	-- Reset points
	-- Reload the maps
end

local function verifyVictory()
	if _virus_pts == 2 then
		print("Virus won the match")
	elseif _antivirus_pts == 2 then
		print("CIA won the match")
	end
end

function GRAPH_LOGIC.load(n)
  _nodes = {}
  _edges = {}
  _next_strat = 1
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
  if DEBUG then
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
end

function GRAPH_LOGIC.setStrategy(strat)
  _strategy = strat
end

local function compareD(a, b)
  return _nodes[a.fin].pcs > _nodes[b.fin].pcs
end

local function compareA(a, b)
  return _nodes[a.fin].pcs < _nodes[b.fin].pcs
end

local function compareM(a, b)
  local node1 = _nodes[a.fin]
  local node2 = _nodes[b.fin]
  local min1 = math.min(node1.pcs-node1.infectedPcs, a.passing)
  local min2 = math.min(node2.pcs-node2.infectedPcs, b.passing)
  return min1 > min2
end

function distributeEqually(neighs, counter)
  local avg = counter/#neighs
  for i,edge in ipairs(neighs) do
    local fin = _nodes[edge.fin]
    fin.infectedPcs = fin.infectedPcs + avg
    neighs[i].passing = neighs[i].passing - avg
    if fin.infectedPcs == fin.pcs then
      fin.infected = true
      fin.resetIn = _resetInCons
      neighs[i] = nil
    end
    if neighs[i].passing == 0 then
      neighs[i] = nil
    end
  end
end

function breadth(neighs, counter, marked)
  local counter = counter or _power
  local marked = marked or {}
  while (counter ~= 0 and #neighs ~= 0) do
    table.sort(neighs, compareM)
    local fin = _nodes[neighs[#neighs].fin]
    local add = math.min(fin.pcs-fin.infectedPcs, neighs[#neighs].passing)
    if (add*#neighs > counter) then
      distributeEqually(neighs, counter)
      return
    end
    for i=#neighs,1,-1 do
      fin = _nodes[neighs[i].fin]
      if marked[fin] then
        neighs[i] = nil
      elseif not fin.infected and neighs[i].passing ~= 0 then
        fin.infectedPcs = fin.infectedPcs + add
        neighs[i].passing = neighs[i].passing - add
        counter = counter - add
        if fin.infectedPcs == fin.pcs then
          fin.infected = true
          fin.resetIn = _resetInCons
          marked[fin] = true
          neighs[i] = nil
        elseif neighs[i].passing >= 0 then
          marked[fin] = true
          neighs[i] = nil
        end
      end
    end
  end
end

function random(neighs)
  if #neighs == 0 then
    return
  end
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
  if #neighs == 0 then
    return
  end
  local finish = false
  local counter = _power
  local fin = _nodes[neighs[#neighs].fin]
  local add = math.min(fin.pcs-fin.infectedPcs, counter, neighs[#neighs].passing)
  local marked = {}
  fin.infectedPcs = fin.infectedPcs + add
  counter = counter - add
  if fin.infectedPcs == fin.pcs then
	  fin.infected = true
    fin.resetIn = _resetInCons
    marked[fin] = true
  end
  neighs[#neighs] = nil
  breadth(neighs, counter, marked)
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
  end
  if _sleeping then
    _sleepResetIn = _sleepResetIn - 1
    if _sleepResetIn == 0 then
      _sleeping = false
    end
  end
  if _boost then
    _boostResetIn = _boostResetIn - 1
    if _boostResetIn == 0 then
      _boost = false
      _power = _power/_BOOST_FACTOR
    end
  end
  for i,edge in ipairs(neighNodes) do
	  print(i, tostring(edge.ini)..','..tostring(edge.fin), edge.passing)
  end
  for i,node in ipairs(_nodes) do
    print(i, tostring(node.infectedPcs).."/"..tostring(node.pcs), node.infected, node.resetIn, node.probeResetIn)
  end
  if type == 1 then
  	print('BFS')
  	breadth(neighNodes)
  elseif type == 2 then
  	print('Random')
  	random(neighNodes)
  elseif type == 0 then
  	print('Depth greedy')
  	table.sort(neighNodes, compareD)
  	focusDepth(neighNodes)
  elseif type == 0 then
  	print('Depth humble')
  	table.sort(neighNodes, compareA)
  	focusDepth(neighNodes)
  elseif type == 0 then
  	print('Beadth greedy')
  	table.sort(neighNodes, compareD)
  	focusBreadth(neighNodes)
  elseif type == 0 then
  	print('Beadth humble')
  	table.sort(neighNodes, compareA)
  	focusBreadth(neighNodes)
  elseif type == 3 then
    print('Sleep')
    _sleeping = true
    _sleepResetIn = _SLEEP_MAX
  elseif type == 4 then
    print('Boost')
    _boost = true
    _boostResetIn = _BOOST_MAX
    _power = _power*_BOOST_FACTOR
  end
end

function GRAPH_LOGIC.turn()
  local strat = 1 -- Set the default type of the move here
  if _strategy then
    strat = _strategy[_next_strat]
    _next_strat = _next_strat%#_strategy + 1
  end
  moveVirus(strat, neighNodes)

  for i,node in ipairs(_nodes) do
    if DEBUG then
    print(i, tostring(node.infectedPcs).."/"..tostring(node.pcs), node.infected, node.resetIn, node.probeResetIn)
    end
    if _nodes[i].hasIntel and _nodes[i].infected then
      print("Virus wins!!!")
      setWhoWon("Virus")
      _virus_pts = _virus_pts + 1
      newState(1)
      return 1
    end
    if _nodes[i].hasIntel and _nodes[i].protected then
      setWhoWon("Antivirus")
      print("CIA wins!!!")
      _antivirus_pts = _antivirus_pts + 1
      newState(1)
      return 1
    end
  end

  return 0
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

function GRAPH_LOGIC.sleeping()
  return _sleeping
end

return GRAPH_LOGIC
