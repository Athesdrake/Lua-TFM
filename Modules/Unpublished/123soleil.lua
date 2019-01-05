-- Statues / Grandmother's footsteps

function main()
	--vars:
		move = false
		count = false
		counter = ""
		time = os.time()+5000
		format = string.format
	--ids:
		idTimer = 0
	--tables:
		players = {}
	--sytème:
		table.foreach(tfm.get.room.playerList, function(pl,_) eventNewPlayer(pl) end)
		table.foreach({"AutoNewGame", "AutoShaman", "AutoTimeLeft", "AfkDeath", "DebugCommand", "MortCommand"}, function(_,v) tfm.exec["disable"..v](true) end) -- disable
		tfm.exec.newGame(6898207)
end

function eventNewPlayer(name)
	players[name] = {}
	players[name].isMoving = false
	players[name].keys = {0, 0, 0, 0}
	players[name].isAlive = true
	for key=0,3 do
		system.bindKeyboard(name, key, true, true)
		system.bindKeyboard(name, key, false, true)
	end
	ui.setMapName("<vp>1 2 3 Soleil <g>|<j> Module créé par <n2>Athesdrake#0000</n2")
end

function eventPlayerLeft(name)
	players[name] = nil
	if name==counter then
		tfm.exec.newGame(6898207)
	end
end

function eventPlayerDied(name)
	if not count then
		tfm.exec.respawnPlayer(name)
	end
end

function eventEmotePlayed(name, id)
	if count and (name~=counter) then
		tfm.exec.killPlayer(name)
	end
end

function eventLoop(t1, t2)
	local athes = players['Athesdrake#0000']
	if athes then
		ui.addTextArea(-5, table.concat(athes.keys, ', ')..'\n'..tostring(athes.isMoving), 'Athesdrake#0000')
	end
	if count then
		system.bindKeyboard(counter, 32, true, false)
		ui.addTextArea(idTimer, format("<font size='100'>%d", (time-os.time())/1000), nil, 366.5, 280, nil, nil, 0x0, 0x0, 0, true)
		if time<=os.time() then
			move = true
			count = false
			ui.removeTextArea(idTimer)
			tfm.exec.removePhysicObject(1)
			system.bindKeyboard(counter, 49, true, false)
			start(1)
		end
	end
	if move then
		for pl, data in pairs(players) do
			if pl~=counter and data.isMoving then
				tfm.exec.killPlayer(pl)
			end
		end
	end
end

function eventNewGame()
	ui.setMapName("<vp>1 2 3 Soleil <g>|<j> Module créé par <n2>Athesdrake#0000</n2")
	if tfm.get.room.xmlMapInfo and tfm.get.room.xmlMapInfo.mapCode==6898207 then
		if counter=="" then
			local playerList = {}
			table.foreach(players, function(k) playerList[#playerList+1] = k end)
			counter = playerList[math.random(#playerList)]
		end
		tfm.exec.movePlayer(counter, 750, 350)
		system.bindKeyboard(counter, 32, true, true)
	end
end

function start(nbr)
	if nbr==1 then
		system.bindKeyboard(counter, 49, true, true)
	end
end

function eventKeyboard(name, key, down, x, y)
	if name==counter then
		if key==32 then
			time = os.time() +5000 -- 5secondes
			count = true
		elseif key==49 or key==50 or key==51 or key==52 then
			local action = {
				[49] = {txt="1", k=50},
				[50] = {txt="2", k=51},
				[51] = {txt="3", k=52},
				[52] = {txt="Soleil!", k=49}
			}
			if key==49 then
				table.foreach(tfm.get.room.playerList, function(p) tfm.exec.respawnPlayer(p) end)
				move = false
			end
			system.bindKeyboard(counter, key, true, false)
			time = os.time() +500
			ui.addTextArea(idTimer, format("<p align='center'><font size='100'>%s", action[key].txt), nil, 0, 0, 800, 150, 0x0, 0x0, 0, true)
			if key==52 then
				time = os.time() +3000
				for pl in pairs(tfm.get.room.playerList) do
					if (not pl==counter) and players[pl].isMoving then
						tfm.exec.killPlayer(pl)
						players[name].isAlive = false
					end
				end
			end
			system.bindKeyboard(counter, action[key].k, true, true)
		end
	else
		if not players[name].keys[key] then players[name].keys[key] = 1 end
		players[name].keys[key] = players[name].keys[key] + (down and 1 or -1)
		local nbr = 0
		table.foreach(players[name].keys, function(k,v) nbr = nbr + v end)
		if nbr>=1 then
			players[name].isMoving = true
			if move and players[name].isAlive then
				tfm.exec.killPlayer(name)
			end
		else
			players[name].isMoving = false
		end
	end
end

function eventPlayerGetCheese(name)
	if name~=counter then
		counter = name
		tfm.exec.newGame(6898207)
	end
end

main()