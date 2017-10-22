local MAP_LOADER = {}
local _maps = {}
local _used_maps = {}
local _current_map

local function generateEdgesMatrix(edges)
	local matrix = {}

	for i=1, #edges do
		table.insert(matrix, {})
		for j=1, #edges do
			table.insert(matrix[i], 0)
		end
	end

	for i=1, #edges do
		for j=1, #edges[i] do
			matrix[i][edges[i][j][1]] = edges[i][j][2]
		end
	end

	return matrix
end

--Returns true if a map was used or false otherwise
local function mapUsed(map)
	local i = 1
	local used = false
	for i=1, #_maps do
		if _maps[i] == _current_map then
			used = true
		end
	end
	return used
end

-- Function called once in the main file
function MAP_LOADER.loadMaps()
	-- Load every map
	local files = love.filesystem.getDirectoryItems("maps")
	for k, file in ipairs(files) do
		file = string.sub(file, 1, -5)
		table.insert(_maps, require('maps.' .. file))
	end
	--Pick one map randomly to be the first map of the game
	_current_map = _maps[3]
	table.insert(_used_maps, _current_map)
end

function MAP_LOADER.switchMap()
	repeat
		_current_map = _maps[love.math.random(1, #_maps)]
	until (mapUsed(_current_map))
	table.insert(_used_maps, _current_map)
end

function MAP_LOADER.getIntel()
  return _current_map['intel']
end

function MAP_LOADER.getInfected()
  return _current_map['infected']
end

function MAP_LOADER.getProtected()
  return _current_map['protected']
end

function MAP_LOADER.getCapacity()
	return _current_map['capacity']
end

function MAP_LOADER.getEdges()
	return generateEdgesMatrix(_current_map['edges'])
end

function MAP_LOADER.getTotal()
	return _current_map['total']
end

function MAP_LOADER.getCurrMap()
	return _current_map['map']
end

return MAP_LOADER
