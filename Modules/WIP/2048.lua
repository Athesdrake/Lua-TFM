function main()
	GROUND_MODE = false
	map = [[<C><P /><Z><S><S P="0,0,0.3,0.2,90,0,0,0" L="400" o="6a7495" X="805" Y="200" T="12" H="10" /><S L="400" o="6a7495" X="-5" H="10" Y="200" T="12" P="0,0,0.3,0.2,90,0,0,0" /><S P="0,0,0.3,0.2,180,0,0,0" L="800" o="6a7495" H="10" Y="-5" T="12" X="400" /><S c="4" L="800" o="ffffff" H="400" X="400" Y="200" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S L="800" o="666666" H="10" X="400" Y="400" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S L="305" o="666666" H="305" X="402.5" Y="202.5" T="12" P="0,0,0.3,0.2,0,0,0,0" /></S><D><DS Y="380" X="400" /></D><O /></Z></C>]]
	player = ({pcall(1)})[2]:match('(.-)%.lua')
	table.foreach({"AutoNewGame", "AutoShaman", "AutoTimeLeft", "AutoScore", "PhysicalConsumables", "AfkDeath"},
		function(_, v) tfm.exec["disable"..v](true) end
	) -- disable
	math.randomseed(os.time())
	players = {}
	table.foreach(tfm.get.room.playerList, eventNewPlayer)
	tfm.exec.newGame(map)
end

function eventNewPlayer(name)
	tfm.exec.respawnPlayer(name)
	for key = 0, 3 do
		system.bindKeyboard(name, key, true, true)
	end
	if not players[name] then
		players[name] = {gameboard = Game(name)}
	end
	players[name].gameboard:show()
end

eventPlayerDied = tfm.exec.respawnPlayer

function eventKeyboard(name, key)
	local dir = {[0] = 1, [1] = 0, [2] = 2, [3] = 3}
	if not players[name].gameboard:move(dir[key]) then
		players[name].gameboard:add()
		players[name].gameboard:show()
	else
		local possibilities = 0
		for i in pairs(players[name].gameboard.grid) do
			for j, value in pairs(players[name].gameboard.grid[i]) do
				if value == 0 then
					possibilities = 1
					break
				end
			end
			if possibilities==1 then
				break
			end
		end
		if possibilities==0 then
			local gameover = true
			for i=0, 3 do
				if i~=dir[key] then
					if not players[name].gameboard:move(i, true) then
						gameover = false
						break
					end
				end
			end
			if gameover then
				ui.addTextArea(-1, "<p align='center'><font size='40' color='#776e65'>Game over!", name, 0, 175, 800, nil, 0x0, 0x0, 0, true)
			end
		end
	end
end

function table.filter(tbl, f)
	local new_tbl = {}
	for _, v in pairs(tbl) do
		if f(v) then
			table.insert(new_tbl, v)
		end
	end
	return new_tbl
end

function table.copy(tbl)
	local temp = {}
	for k, v in next, tbl do
		temp[k] = v
	end
	return temp
end

function table.rep(value, times)
	local tbl = {}
	for _ = 1, times do
		table.insert(tbl, value)
	end
	return tbl
end

function table.extend(...)
	local tbl = {}
	for _, t in pairs{...} do
		for _, value in ipairs(t) do
			table.insert(tbl, value)
		end
	end
	return tbl
end

function table.equals(t1, t2, recursive, check)
	for k, v in pairs(t1) do
		if type(v) == 'table' and recursive then
			if type(t2[k]) == 'table' then
				if not table.equals(t1[k], t2[k], true) then
					return false
				end
			else
				return false
			end
		elseif not (t2[k] == v) then
			return false
		end
	end
	if not check then
		return table.equals(t2, t1, recursive, true)
	end
	return true
end

function table.sum(tbl, deep)
	local sum = 0
	for k,v in next, tbl do
		if deep and type(v)=='table' then
			sum = sum + table.sum(v)
		elseif type(v)=='number' then
			sum = sum + v
		end
	end
	return sum
end

function slide(row, dir)
	local arr = table.filter(row, function(v) return v ~= 0 end)
	while #row > #arr do
		table.insert(arr, 0)
	end
	return table.extend(arr[dir], arr[dir % 2 + 1])
end

function combine(row)
	for i = 4, 1, -1 do
		local a = row[i]
		local b = row[i - 1]
		if a == b then
			row[i] = a + b
			row[i - 1] = 0
		end
	end
	return row
end

function operate(row, dir)
	row = slide(row, dir)
	row = combine(row)
	row = slide(row, dir)
	return row
end

Game = {}
Game.__index = Game

function Game:show()
	local background = {0xeee4da, 0xede0c8, 0xf2b179, 0xf59563, 0xf67c5f, 0xf65e3b, 0xedcf72, 0xedcc61, 0xedc850, 0xedc53f, 0xedc22e}
	for i in pairs(self.grid) do
		for j, value in pairs(self.grid[i]) do
			local id = i * 4 + j
			local width = 70
			local x = 250 + (j - 1) * width + 5 * j
			local y = 50 + (i - 1) * width + width / 2 + 5 * i
			local ground = {type = 12, width = width, height = width, color = value == 0 and 0xCDC0B4 or background[math.log(value, 2)]}
			if GROUND_MODE then
				tfm.exec.addPhysicObject(id, x + width / 2, y, ground)
			else
				ui.addTextArea(id*1000, '', self.name, x+5, y-(width / 2)+7, width-10, width-10, ground.color, ground.color, 1, true)
			end
			if value ~= 0 then
				ui.addTextArea(id, '<p align="center"><font size="20" color="#' .. (math.log(value) > 2 and 'f9f6f2' or '776e65') .. '">'..value, self.name, x, y - 10, width, nil, 0x0, 0x0, 0, true)
			else
				ui.removeTextArea(id, self.name)
			end
		end
	end
end

function Game:move(dir, test)
	local new_grid = {}
	local old_grid = self.grid
	if dir == 1 or dir == 2 then
		for _, row in pairs(self.grid) do
			table.insert(new_grid, operate(row, dir))
		end
	else
		for i = 1, #self.grid do
			new_grid[i] = {}
		end
		for j = 1, #self.grid[1] do
			local row = {}
			for _, col in pairs(self.grid) do
				table.insert(row, col[j])
			end
			for i, v in pairs(operate(row, dir % 2 + 1)) do
				new_grid[i][j] = v
			end
		end
	end
	local equals = table.equals(old_grid, new_grid, true)
	if not test then
		self.grid = new_grid
		self:show()
		if not equals then
			print(table.sum(new_grid, true))
		end
	end
	return equals
end

function Game:add()
	local possibilities = {}
	for i in pairs(self.grid) do
		for j, value in pairs(self.grid[i]) do
			if value == 0 then
				table.insert(possibilities, {i, j})
			end
		end
	end
	if #possibilities == 0 then
		print("GAME OVER: "..self.name)
		ui.addTextArea(-1, "<p align='center'><font size='20' color='#776e65'>Game over!", self.name, 0, 180, 800, nil, 0x0, 0x0, 0, true)
	else
		local i, j = table.unpack(possibilities[math.random(#possibilities)])
		self.grid[i][j] = math.random() < .25 and 4 or 2
	end
end

function Game:init()
	local grid = {}
	for i = 1, 4 do
		grid[i] = {}
		for j = 1, 4 do
			grid[i][j] = 0
		end
	end
	self.grid = grid
	self:add()
	self:add()
	self:show()
end

function Game.new(name)
	local meta = setmetatable({name=name}, Game)
	meta:init()
	return meta
end

setmetatable(Game, {__call = function(_,...) return Game.new(...) end})

function pprint(...)
	for _, value in ipairs{...} do
		if type(value) == "table" then
			local tbl = {}
			for k, v in next, value do
				if type(k) == "number" then
					if type(v) == 'table' then
						table.insert(tbl, '\n\t{'..table.concat(v, ', ') .. '}')
					else
						table.insert(tbl, v)
					end
				else
					table.insert(tbl, k.."="..v)
				end
			end
			print("{"..table.concat(tbl, ', ') .. "}")
		end
	end
end

main()
