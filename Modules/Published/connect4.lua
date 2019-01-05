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

-- Translation
T = {
	en = {
		join = 'Type !join to play to connect4',
		turn = "<%s>%s<n>'s turn",
		queue = 'Queue',
		win = {
			timer = '<v>%s</v> won, <v>%s</v> took too much time !',
			draw = "Nobody won, it\'s a draw !",
			left = '<v>%s</v> won, <v>%<v> has left !',
			won = '<v>%s</v> won !'
		},
		askJoin = '%s want to play with you.\nDo you accept ?',
		yes = 'Yes',
		no = 'No'
	},
	fr = {
		join = 'Utilise la commande !join pour jouer à puissance 4',
		turn = "Au tour de <%s>%s<n>",
		queue = "File d'attente",
		win = {
			timer = '<v>%s</v> a gagné, <v>%s</v> à pris trop de temps !',
			draw = "Égalité, personne n'a gagné !",
			left = '<v>%s</v> a gagné, <v>%s</v> est partit !',
			won = '<v>%s</v> a gagné !'
		},
		askJoin = '%s veut jouer avec toi.\nAccepter ?',
		yes = 'Oui',
		no = 'Non'
	}
}
do
	for l,tbl in next, T do
		if l~='en' then
			T[l] = setmetatable(tbl, {
				__index = function(self, key)
					if not T.en[key] then
						error(("<r>The key '%s' does not exists</r>"):format(key))
					else
						print(("<r>The key '%s' is missing in the locale '%s'</r>"):format(key, l), 2)
						return T.en[key]
					end
				end
			})
		end
	end
	setmetatable(T, {
		__index = function(self, key)
			print(key)
			if rawget(self, key) then
				return rawget(self, key)
			end
			return self.en
		end
	})
end

-- Main
function main()
	-- const
	TIME_PER_TURN = 20

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
	locale = {}
	players = {nbr=0}
	timer = {active=false, time=0}
	grid = Grid()
	queue = {}

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
	if players.nbr<2 then
		eventNewGame()
	end
	if players.nbr>=1 then
		showVersus()
	end
	locale[name] = T[tfm.get.room.playerList[name].community]
	print(tfm.get.room.playerList[name].community)
	ui.addTextArea(ids.join, '<p align="center"><font size="30">'..locale[name].join, name, 0, 20, 800, nil, 0x0, 0x0, 0, true)
	tfm.exec.respawnPlayer(name)
end

function eventPlayerLeft(name)
	for k,v in next, queue do
		if v[1]==name then
			if v[2] then
				queue[k] = {v[2]}
			else
				for i=k,#queue do
					queue[i] = queue[i+1]
				end
			end
			break
		elseif v[2]==name then
			v[2] = nil
			break
		end
	end
	update_queue()
	if players[name] then
		ui.displayWin('left', displayName(players[name].opponent), displayName(name))
		eventWin(players[name].opponent)
	end
end

function eventChatCommand(name, cmd)
	if not name then return end -- prevent nil name from new_game

	local args = {}
	for a in cmd:gmatch('%S+') do
		args[#args+1] = a
	end

	if args[1]=='join' then
		local p2 = nil
		if args[2] then
			p2 = args[2]:match('#%d+$') and args[2] or args[2]..'#0000'
		end

		if players[name] then return end
		if p2 then
			if players[p2] or not tfm.get.room.playerList[p2] then return end -- TODO: add an error message

			for k,v in next, queue do if v[1]==name or v[2]==name or v[1]==p2 or v[2]==p2 then return end end
			ui.addPopupArea(ids.askJoin, locale[p2].askJoin:format(displayName(name)), p2, 'join$'..name, 300, 100, 200, 100)
		elseif players.nbr==2 then
			for k,v in next, queue do if v[1]==name or v[2]==name then return end end

			for k,tbl in next, queue do
				if not tbl[2] then
					tbl[2] = name
					return update_queue()
				end
			end
			queue[#queue+1] = {name}
			update_queue()
		else
			local opponent = 0
			if players.nbr==1 then
				turn = 2
				for n in next, tfm.get.room.playerList do
					local txt = "<b><font size='16'>"..locale[n].turn:format('j', displayName(name))
					ui.addTextArea(ids.turn, txt, n, 580, 360, 225, nil, 0x0, 0x0, 0, true)
				end
				for n, pl in next, players do
					if n~='nbr' then
						pl.opponent = name
						opponent = n
						break -- it should be only one player but whatever it's better to be sure.
					end
				end
				system.bindMouse(name, true)
				system.bindMouse(opponent, true)
				timer.active = true
				timer.time = TIME_PER_TURN
			end
			local color = players.nbr==1 and 0xffff00 or 0xff0000
			players.nbr = players.nbr +1
			players[name] = {id=players.nbr, color=color, opponent=opponent}

			showVersus()
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
				return tbl
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
		local func = tbl._(path)
		print(func, table.unpack(args))
		if func then
			func(table.unpack(args))
		end
	end
end

function eventTextAreaCallback(id, name, callback)
	local args = {}
	for a in callback:gmatch('[^$]+') do
		args[#args+1] = a
	end

	if args[1]=='join' then
		ui.removePopupArea(ids.askJoin, name)
		if args[3]=='yes' then
			local p1, p2 = args[2], name
			-- TODO: add error message
			if players[p1] or players[p2] then return end
			for k,v in next, queue do if v[1]==p1 or v[2]==p1 or v[1]==p2 or v[2]==p2 then return end end

			if players.nbr==0 then
				eventChatCommand(p1, 'join')
				eventChatCommand(p2, 'join')
			else
				queue[#queue+1] = {p1,p2}
				update_queue()
			end
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
	if timer.active then
		timer.time = timer.time - 0.5
		if timer.time<=0 then
			ui.removeTextArea(ids.timer)
			timer.active = false

			local player
			for k,v in next, players do if k~='nbr' and v.id==turn then player=v;break end end
			local p1, p2 = players[player.opponent].opponent, player.opponent
			if turn==players[p1].id then
				p1, p2 = p2, p1
			end

			ui.displayWin('timer', displayName(p1), displayName(p2))
			eventWin(p1)
			turn = 0
			return
		end
		ui.addTextArea(ids.timer, ('<b><p align="center"><font size="20">%d'):format(math.floor(timer.time)), nil, 0, 90, 800, nil, 0x0, 0x0, 0, true)
	end
end

function eventNewGame()
	need_reload = false

	local id = 1000
	local idpp = function() id = id +1; return id end

	-- tfm.exec.addPhysicObject(idpp(), 400, 255, {type=12, width=350, height=270, color=0xff, miceCollision=true, groundCollision=false})
	for x=280, 520, 40 do
		for y=155, 355, 40 do
			tfm.exec.addPhysicObject(idpp(), x, y, {type=13, width=15, miceCollision=false, groundCollision=false, color=0x6A7495})
		end
		tfm.exec.addPhysicObject(idpp(), x-20, 200, {type=14, height=400, miceCollision=false})
	end
	tfm.exec.addPhysicObject(idpp(), 540, 200, {type=14, height=400, miceCollision=false})
	tfm.exec.addPhysicObject(idpp(), 400, 375, {type=14, width=270, miceCollision=false})
end

function eventMouse(name, x, y)
	x = x-(x+20)%40+20
	if x<280 or x>520 then return end

	local player = players[name]
	if not player then
		system.bindMouse(name, false)
		return
	end
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
		ui.removeTextArea(ids.timer)
		timer.active = false
		setTimeout(ui.displayWin, 1, 'won', displayName(name))
		eventWin(name, win)
		return
	end

	local color = player.id==1 and 'j' or 'r'
	for n in next, tfm.get.room.playerList do
		local txt = "<b><font size='16'>"..locale[n].turn:format(color, displayName(player.opponent))
		ui.addTextArea(ids.turn, txt, n, 580, 360, 225, nil, 0x0, 0x0, 0, true)
	end

	setTimeout(function(p) turn = players[p].id end, 0.5, player.opponent, true)
	timer.time = TIME_PER_TURN
	timer.active = true

	local draw = false
	for n in next, grid[1] do
		if n==0 then
			draw = true
			break
		end
	end


	if draw then
		print('Draw')
		-- ui.displayWin('draw')
		-- eventWin(nil)
	end
end

function eventWin(name, win)
	players = {nbr=0}
	timer.active = false

	ui.removeTextArea(ids.turn)

	local scale = function(p)
		return {
			240+p[2]*40,
			115+p[1]*40
		}
	end

	if win then
		draw(1, scale(win[2]), scale(win[3]), 0xffffff, 5)
	end
	setTimeout(new_game, 7)
end

-- Ui
ui.displayWin = function(type, ...)
	print(type)
	for n in next, tfm.get.room.playerList do
		local txt = locale[n].win[type]:format(...)
		ui.addTextArea(ids.won, '<p align="center"><font size="25">'..txt, n, 0, 50, 800, nil, 0x0, 0x0, 0, true)
	end
end
ui.addPopupArea = function(id, txt, name, callback, x, y, width, height)
	width = width or 200
	height = height or 100

	function addPopup(id, txt, x, y, w, h)
		ui.addTextArea(id+0, ' ', name, x-1, y-1, w, h, 0x5D7D90, 0x5D7D90, 1, true)
		ui.addTextArea(id+1, ' ', name, x+1, y+1, w, h, 0x000001, 0x000001, 1, true)
		ui.addTextArea(id+2, txt, name, x  , y  , w, h, 0x3C5064, 0x3C5064, 1, true)
	end
	addPopup(id*1000, txt, x, y, width, height) -- main body

	local h = 20
	local y, w = y+height-3*h/2, 3*width/10
	local txt = '<p align="center"><a href="event:%s%s">%s'
	addPopup(id*1000+3, txt:format(callback, '$yes', locale[name].yes), x+width/10, y, w, h) -- button 'yes'
	addPopup(id*1000+6, txt:format(callback, '$no', locale[name].no), x+3*width/5, y, w, h) -- button 'no'
end
ui.removePopupArea = function(id, name)
	for i=id*1000, id*1000+9 do
		ui.removeTextArea(i, name)
	end
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

	if map or need_reload then
		tfm.exec.newGame([[<C><P/><Z><S><S H="270" L="350" P="0,0,0.3,0.2,0,0,0,0" T="12" X="400" Y="255" c="3" o="ff"/><S H="10" L="34" P="0,0,0,1.5,0,0,0,0" T="2" X="110" Y="393"/><S H="10" L="34" P="0,0,0,1.5,0,0,0,0" T="2" X="690" Y="393"/><S H="20" L="380" P="0,0,0.3,0.2,0,0,0,0" T="12" X="400" Y="388" c="4" o="dd"/><S H="100" L="800" P="0,0,0.3,0.2,0,0,0,0" T="0" X="400" Y="440"/><S H="25" L="80" P="0,0,0.3,0.2,0,0,0,0" T="0" X="40" Y="305"/><S H="25" L="80" P="0,0,0.3,0.2,0,0,0,0" T="0" X="40" Y="205"/><S H="25" L="80" P="0,0,0.3,0.2,0,0,0,0" T="0" X="760" Y="305"/><S H="25" L="80" P="0,0,0.3,0.2,0,0,0,0" T="0" X="760" Y="205"/><S H="31" L="810" P="0,0,0.3,0,0,0,0,0" T="10" X="400" Y="8"/><S H="270" L="25" P="0,0,,,,0,0,0" T="9" m="" X="212" Y="255"/><S H="270" L="25" P="0,0,,,,0,0,0" T="9" m="" X="587" Y="255"/><S H="270" L="10" P="0,0,0,0,0,0,0,0" T="14" X="229" Y="255" c="3"/><S H="270" L="10" P="0,0,0,0,0,0,0,0" T="14" X="571" Y="255" c="3"/><S H="31" L="10" P="0,0,0,0,0,0,0,0" T="14" X="-1" Y="8" c="3"/><S H="31" L="10" P="0,0,0,0,0,0,0,0" T="14" X="801" Y="8" c="3"/></S><D><P C="427b8f" P="0,0" T="34" X="0" Y="0"/><P C="8a311b" P="0,0" T="19" X="40" Y="395"/><P C="8a311b" P="0,0" T="19" X="40" Y="295"/><P C="8a311b" P="0,0" T="19" X="40" Y="195"/><P C="8a311b" P="0,0" T="19" X="760" Y="395"/><P C="8a311b" P="0,0" T="19" X="760" Y="295"/><P C="8a311b" P="0,0" T="19" X="760" Y="195"/></D><O/></Z></C>]])
	end
	if not map then
		ui.removeTextArea(ids.won)
		ui.removeTextArea(ids.versus)
		draw(1, {10,0}, {11,0}, 0xffffff, 1) -- tfm.exec.removeJoint is not working >:(

		for i=-1, mfid, -1 do
			tfm.exec.removePhysicObject(i)
		end
		mfid = -1

		local p1, p2 = table.unpack(queue[1] or {})
		eventChatCommand(p1, 'join')
		eventChatCommand(p2, 'join')

		for i=1,#queue do
			queue[i] = queue[i+1]
		end
		update_queue()
	end
end

function update_queue()
	local txt = {'<font size="14"><b>%s:</b>'}

	for k, tbl in next, queue do
		txt[#txt+1] = ('<r>%s <g>vs <j>%s'):format(displayName(tbl[1]), tbl[2] and displayName(tbl[2]) or '?')
	end

	if #txt>1 then
		txt = table.concat(txt, '\n\t')
		for n in next, tfm.get.room.playerList do
			ui.addTextArea(ids.queue, txt:format(locale[n].queue), n, 0, 50, nil, nil, 0x0, 0x0, 0, true)
		end
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

-- ShowVersus
function showVersus()
	local txt = '<p align="center"><font size="20"><b><r>%s \n<v>vs\n <j>%s'
	local pl = {}
	for n in next, players do
		if n~='nbr' then
			pl[#pl+1] = n
		end
	end
	if #pl==0 then
		return
	elseif #pl==1 then
		pl[2] = 0
	end

	local p1, p2 = table.unpack(pl)
	if players[p1].id==2 then
		p1, p2 = p2, p1
	end
	ui.addTextArea(ids.versus, txt:format(displayName(p1), p2==0 and '?' or displayName(p2)), nil, 575, 120, 225, nil, 0x0, 0x0, 0, true)
end

-- SetTimeout
_timeout = {}
function setTimeout(f, seconds, ...)
	_timeout[#_timeout+1] = {t=os.time()+seconds*1000, f=f, args={...}}
end

main()