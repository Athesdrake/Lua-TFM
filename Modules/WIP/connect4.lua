-- Classes
-- Grid
Grid = {}
Grid.__index = Grid

function Grid.new(width, height)
	if (not width) or (not height) then
		return setmetatable({
			{0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0},
		}, Grid)
	end

	local tbl = {}
	for i=1, height do
		tbl[i] = {}
		for j=1, width do
			tbl[i][j] = 0
		end
	end

	return setmetatable(tbl, Grid)
end

function Grid.__call(self)
	-- if (not self.coro) or coroutine.status(self.coro)=='dead'then
	-- 	self.coro = coroutine.create(function()
	-- 		for i=1, #self do
	-- 			coroutine.yield(i, self[i])
	-- 		end
	-- 	end)
	-- end
	-- return table.unpack({coroutine.resume(self.coro)}, 2)
	local tbl = {}
	for i=1, #self do
		tbl[#tbl+1] = self[i]
	end
	return next, tbl
end

function Grid:cols()
	local grid = Grid(6, 7)
	grid.rotated = true

	for i, line in self() do
		for j, value in next, line do
			grid[j][i] = value
		end
	end

	return grid
end

function Grid:diagonals(reverse)
	local diags = {}

	for i, line in self() do
		for j, value in next, line do
			local index = reverse and j-i+6 or i+j-1
			-- print(index)
			local tbl = diags[index]

			if not tbl then
				diags[index] = {}
				tbl = diags[index]
			end

			tbl[#tbl+1] = value
		end
	end

	setmetatable(diags, Grid).reverse = reverse
	return diags
end

function Grid:checkWin(check)
	local calcPoint = function(x, y)
		if check then
			if self.rotated then
				return {y,x}
			else
				local i = y+(x-x%8)/8
				local j = x-i+1
				if self.reverse then
					-- i = 8-i
					j = x+i-6
				end
				return {i,j}
			end
		else
			return {x,y}
		end
	end

	for i, line in self() do
		local score, p1, last = 0, {0,0}, 0
		for j, v in next, line do
			if last~=v or v==0 then
				score, last, p1 = 1, v, {i,j}
			else
				score = score +1
				if score==4 then
					return true, calcPoint(table.unpack(p1)), calcPoint(i,j)
				end
			end
		end
	end

	if not check then
		local cols = {self:cols():checkWin(true)}
		if cols[1] then
			return table.unpack(cols)
		end

		local diags = {self:diagonals():checkWin(true)}
		if diags[1] then
			return table.unpack(diags)
		end
		return self:diagonals(true):checkWin(true)
	end
	return false
end

function Grid:drop(j)
	local index = nil
	for i, line in self() do
		if line[j]==0 then
			index = i
		else
			break
		end
	end

	return index
end
setmetatable(Grid, {__call=function(_,...) return Grid.new(...) end})

-- Queue
Queue = {}
Queue.__index = Queue

function Queue.__call(self)
	if not self.__iter or coroutine.status(self.__iter)=='dead' then
		self.__iter = coroutine.create(function()
			local i = self.start
			while i<self.stop do
				coroutine.yield(self[i])
				i = i+1
			end
		end)
	end
	return table.unpack({coroutine.resume(self.__iter)}, 2)
end

function Queue.new(tbl)
	tbl = tbl and {table.unpack(tbl)} or {} -- keep only the integer keys
	tbl.start = 1
	tbl.stop = 1
	return setmetatable(tbl, Queue)
end

function Queue:put(value)
	self[self.stop] = value
	self.stop = self.stop +1
end

function Queue:right_put(value)
	self[self.stop] = value
	self.stop = self.stop +1
end

function Queue:get(index)
	return self[index or self.start]
end

function Queue:pop()
	if self.start==self.stop then return end

	local rval = self[self.start]
	self.start = self.start +1
	return rval
end

function Queue:right_pop()
	if self.start==self.stop then return end

	local rval = self[self.stop]
	self.stop = self.stop -1
	return rval
end

function Queue:pop_all()
	local tbl = {table.unpack(self, self.start, self.stop)}
	self.start = 1
	self.stop = 1
	self[1] = nil
	return next, tbl
end

function Queue:len()
	return self.stop - self.start
end

function Queue:is_in(value)
	for v in self do
		if v==value then
			return true
		end
	end
	return false
end
Queue.left_put = Queue.put
Queue.left_pop = Queue.pop
setmetatable(Queue, {__call=function(_,...) return Queue.new(...) end})

-- Main
function main()
	--ids
	ids = setmetatable({__id=0}, {
		__index = function(self, key)
			if rawget(self, key) then -- If the key already exists
				return rawget(self, key) -- Then return it
			end

			self.__id = self.__id +1 -- Otherwise increment the counter
			return rawset(self, key, self.__id)[key] -- Set the new id to the key and return the value
		end,
		__newindex = function() end
	})

	mfid = -1
	turn = 0

	--tables
	players = {nbr=0}
	grid = Grid()
	queue = Queue()

	-- system
	for k,v in next, {'AutoShaman', 'AutoNewGame', 'AfkDeath', 'PhysicalConsumables'} do
		tfm.exec['disable'..v](true)
	end
	system.disableChatCommandDisplay('join', true)
	system.disableChatCommandDisplay('call', true)
	table.foreach(tfm.get.room.playerList, eventNewPlayer)
	new_game(true)
end

-- Events
eventPlayerDied = tfm.exec.respawnPlayer

function eventNewPlayer(name)
	need_reload = true
	ui.addTextArea(ids.join, '<p align="center"><font size="30">Type !join to play to connect4', nil, 0, 20, 800, nil, 0x0, 0x0, 0, true)
	tfm.exec.respawnPlayer(name)
end

function eventChatCommand(name, cmd)
	if not name then return end -- prevent nil name from new_game

	if cmd=='join' then
		if players[name] then return end
		if players.nbr==2 then
			if queue:is_in(name) then return end
			queue:put(name)
			update_queue()
		else
			local opponent = 0
			if players.nbr==1 then
				turn = 2
				ui.addTextArea(ids.turn, ("<b><font size='16'><j>%s<n>'s turn"):format(displayName(name)), nil, 580, 360, 225, nil, 0x0, 0x0, 0, true)
				for n, pl in next, players do
					if n~='nbr' then
						pl.opponent = name
						opponent = n
						break -- it should be only one player but whatever it's better to be sure.
					end
				end
				system.bindMouse(name, true)
				system.bindMouse(opponent, true)
			end
			local color = players.nbr==1 and 0xffff00 or 0xff0000
			players.nbr = players.nbr +1
			players[name] = {id=players.nbr, color=color, opponent=opponent}

			local txt = '<p align="center"><font size="20"><b><r>%s \n<v>vs\n <j>%s'
			local p1, p2 = name, opponent
			if players[name].id==2 then
				p1, p2 = p2, p1
			end
			ui.addTextArea(ids.versus, txt:format(displayName(p1), p2==0 and '?' or displayName(p2)), nil, 575, 120, 225, nil, 0x0, 0x0, 0, true)
		end
	elseif cmd:match('^call') and name=='Athesdrake#0000' then
		local path, args = nil, {}
		local tbl = {
			n = tonumber,
			s = tostring,
			_ = function(s)
				local tbl = _G
				for p in s:gmatch('[^%.]+') do
					if tbl[p] then
						tbl = tbl[p]
					else
						return print('do not exists:', p)
					end
				end
			end
		}
		for m in cmd:gmatch('%S+') do
			if not path or path=='call' then
				path = m
			end
			local arg = {m:match('^%$([^$]+)%$([^$]+)$')}
			if arg[1] and tbl[arg[1]] then
				args[#args+1] = tbl[arg[1]](arg[2])
			end
		end
		local tbl = tbl._(path)
		if tbl then
			tbl(table.unpack(args))
		end
	end
end

function eventLoop()
	for k, tbl in next, _timeout do
		if os.time()>=tbl.t then
			tbl.f(table.unpack(tbl.args))
			table.remove(_timeout, k)
			break
		end
	end
	print(turn)
end

function eventNewGame()
	need_reload = false

	tfm.exec.addPhysicObject(1001, 0, 0, {type=14, miceCollision=false, groundCollision=false})
	tfm.exec.addPhysicObject(1002, 0, 0, {type=14, miceCollision=false, groundCollision=false})

	local id = 1000
	local idpp = function() id = id +1; return id end

	tfm.exec.addPhysicObject(idpp(), 400, 255, {type=12, width=350, height=270, color=0xff, miceCollision=false, groundCollision=false})
	for x=280, 520, 40 do
		for y=155, 355, 40 do
			tfm.exec.addPhysicObject(idpp(), x, y, {type=13, width=15, miceCollision=false, groundCollision=false, color=0x6A7495})
		end
		tfm.exec.addPhysicObject(idpp(), x-20, 200, {type=14, height=400, miceCollision=false})
	end
	tfm.exec.addPhysicObject(idpp(), 540, 200, {type=14, height=400, miceCollision=false})
	tfm.exec.addPhysicObject(idpp(), 400, 375, {type=14, width=270, miceCollision=false})
	tfm.exec.addJoint(5, 0, 0, {point1='20,20', point2='50,50', color=0xff0000, type=0, alpha=1, line=5})
end

function eventMouse(name, x, y)
	x = x-(x+20)%40+20
	if x<280 or x>520 then return end

	local player = players[name]
	if player.id~=turn then return end
	turn = 0

	local j = (x-280)/40+1
	local i = grid:drop(j)
	if not i then
		turn = player.id
		return
	end
	grid[i][j] = player.id

	tfm.exec.addPhysicObject(mfid, x, 80, {type=13, width=15, miceCollision=false, color=player.color, dynamic=true, fixedRotation=true})
	tfm.exec.addPhysicObject(mfid-1, x, 60, {type=14, width=15, miceCollision=false, dynamic=true, fixedRotation=true})
	mfid = mfid -2

	local win = {grid:checkWin()}
	if win[1] then
		ui.removeTextArea(ids.turn)
		return setTimeout(function()
			ui.addTextArea(ids.won, ('<p align="center"><font size="25">%s won !'):format(name), nil, 0, 50, 800, nil, 0x0, 0x0, 0, true)
			local scale = function(p)
				return {
					240+p[2]*40,
					115+p[1]*40
				}
			end
			draw(1, scale(win[2]), scale(win[3]), 0xffffff, 5)
			setTimeout(new_game, 5)
		end, 1)
	end

	local txt = ("<b><font size='16'><%s>%s<n>'s turn"):format(player.id==1 and 'j' or 'r', displayName(player.opponent))
	ui.addTextArea(ids.turn, txt, nil, 580, 360, 225, nil, 0x0, 0x0, 0, true)

	setTimeout(function(p) turn = players[p].id end, 0.5, player.opponent, true)
end

-- Debug
_print = print
function print(...)
	local tmp, lasti = {}, 0
	for i, v in next, {...} do
		lasti = lasti+1
		if lasti~=i then
			for j=1, i-lasti do
				tmp[#tmp+1] = 'nil'
			end
			lasti = i
		end
		tmp[#tmp+1] = tostring(v)
	end

	_print(table.concat(tmp, ' '))
end

-- Game
function new_game(map)
	grid = Grid()
	players = {nbr=0}

	if map or need_reload then
		tfm.exec.newGame('<C><P /><Z><S><S L="800" o="324650" H="10" X="400" Y="394" T="12" P="0,0,0.3,0.2,0,0,0,0" /></S><D /><O /></Z></C>')
	end
	if not map then
		ui.removeTextArea(ids.won)
		draw(1, {10,0}, {11,0}, 0xffffff, 1) -- tfm.exec.removeJoint is not working >:(

		for i=-1, mfid, -1 do
			tfm.exec.removePhysicObject(i)
		end
		mfid = -1

		local p1, p2 = queue:pop(), queue:pop()
		eventChatCommand(p1, 'join')
		eventChatCommand(p2, 'join')
		update_queue()

		ui.removeTextArea(ids.versus)
	end
end

function update_queue()
	local txt = {'<font size="14"><b>Queue:</b>'}

	for n in queue do
		txt[#txt+1] = '\t'..n
	end

	if #txt>1 then
		ui.addTextArea(ids.queue, table.concat(txt, '\n'), nil, 0, 50, nil, nil, 0x0, 0x0, 0, true)
	else
		ui.removeTextArea(ids.queue)
	end
end

-- Draw
function draw(id, pos1, pos2, color, line)
	local def = {type=0, point1=table.concat(pos1, ","), point2=table.concat(pos2, ","), line=line or 3, color=color, alpha=1, foreground=true}
	tfm.exec.addJoint(id, 1001, 1002, def)
end

-- DisplayName
function displayName(playerName)
	if type(playerName)~='string' then
		print(('<R>displayName expected a string as argument, got "%s"</R>'):format(tostring(playerName)))
		return tostring(playerName)
	end

	local name = playerName:match('^([^#]+)')
	for pl in next, tfm.get.room.playerList do
		if pl~=playerName then
			local n = pl:match('^([^#]+)')
			if name==n then
				return playerName
			end
		end
	end
	return name
end

-- SetTimeout
_timeout = {}
function setTimeout(f, seconds, ...)
    _timeout[#_timeout+1] = {t=os.time()+seconds*1000, f=f, args={...}}
end

main()