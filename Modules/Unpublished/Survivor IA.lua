--[==[
	Survivor IA is a module where you can train yourself in survivor.
	Several modes are availables:
		- just_Survive: an AI try to take you down
		- dodge: You have to dodge the canonballs on a flat map
		- survivor: like survivor but with differents difficulties
		- cannonjump: cannonjump ...
		- fight: Fight between shaman
--]==]

function main()
	--vars:
		interval = 10
		sniper = 10
		currentGame = "lobby"
		temps = 0
		difficulty = 8
		lobby_map = "@7061197"
		currentMap = lobby_map
		start = false
		version = "v2.8e"
	--ids:
		idTitre = 1
		idTitre2 = 2
		idVersion = 3
		idCredits = 4
		idStart = 5
		idEz = 6
		idMed = 7
		idHard = 8
		idAnouce = 9
		idGames = 10
		idRanking = 11
		idAfk = 12
	--tables:
		admins = {
			['Athesdrake#0000'] = 1,
			['Nagi#9244'] = 1,
			[({pcall(0)})[2]:match('^(.-).lua')] = true
		}
		maps = {"@6795560","@6734219","@6820043","@6837422","@6993142","@7058999","@7061089","@7063987", "@7072412","@7072553","@7072632","@7072872", "@7073789", "@7076671"}
		maps_fight = {"@7074086", "@7078795", "@7079292", "@589708", "@4741240", "@4741180", "@4741187", "@4741230", "@4741121"}
		cannonInfo = {}
		players = {}
		game = {
			just_Survive = {
				color = "J",
				loop = function(t1,t2)
					if t1>3000 and t2>0 then
						interval = interval -1
						sniper = sniper -1
						if sniper==0 then
							tfm.exec.addShamanObject(1704, cannon[1], cannon[2], cannon[3]-90)
							sniper = 10
						end
						if sniper==1 then
							local players = {}
							for k,v in pairs(tfm.get.room.playerList) do
								if (not v.isDead) then
									table.insert(players, k)
								end
							end
							if #players>0 then
								cannon = spawnCannon(players[math.random(#players)], true)
							else
								sniper = 10
							end
						end
						if interval==difficulty then
							ui.removeTextArea(idAnouce)
							local players = {}
							for k,v in pairs(tfm.get.room.playerList) do
								if (not v.isDead) then
									table.insert(players, k)
								end
							end
							cannonInfo = spawnCannon(players[math.random(#players)])
							interval = 12
						elseif interval<=5 then
							tfm.exec.setUIMapName("<ROSE>La prochaine map commence dans "..math.ceil(interval/2))
							if interval==0 then
								newMap()
							end
						elseif interval==10 then
							tfm.exec.addShamanObject(17, cannonInfo[1], cannonInfo[2], cannonInfo[3]-90)
							cannonInfo = {}
						end
					end
					if t2<=0 then
						ui.addTextArea(idAnouce, "<VP><p align='center'><B>FELICITATION</B>\n\n<CH><i>Vous avez battu l'IA!", nil, 290, 22, 180, nil, 0x000001, 0xCA0805, 0.8)
						if t2<=-5000 then
							newMap()
						end
					end
				end,
				setup = function()
					newMap()
					tfm.exec.disableAfkDeath(false)
				end,
				plDied = function(name)
					if playerCount()==1 then
						tfm.exec.setGameTime(20)
					elseif playerCount()==1 then
						newMap()
					end
				end
			},
			lobby = {
				loop = function()
					if temps<=os.time() and temps~=0 then
						tfm.exec.newGame(lobby_map)
						tfm.exec.disableAfkDeath(true)
						temps = 0
					end
				end,
				newPl = function(name)
					tfm.exec.respawnPlayer(name)
					eventNewGame()
				end,
				plDied = newPl
			},
			dodge = {
				color = "V",
				loop = function(t1, t2)
					if t1>4000 then
						interval = interval -1
						for i=1,20 do
							ui.removeTextArea(i)
						end
						if interval==difficulty then
							ui.removeTextArea(idAnouce)
							local players = {}
							tfm.exec.addShamanObject(17, 801, math.random(100,375), math.random(-135,-30))
							interval = 10
						elseif interval==1 then
							tfm.exec.newGame(7070306)
						end
					end
					if t2<0 then

						--ui.addTextArea(idAnouce, string.format("<j><p align='center'><font face='Lucida Console' size='20'>Le gagnant est: <v>%s", table.concat(survivants)), nil, 103,21,590,nil,1,1,1)
					end
				end,
				setup = function()
					tfm.exec.newGame(7070306)
					table.foreach(tfm.get.room.playerList, function(pl) system.bindKeyboard(pl, 17, true, true);system.bindKeyboard(pl, 17, false, true);if not players[pl] then players[pl]={score=0} end end)
					for i=1,20 do
						ui.removeTextArea(i)
					end
				end,
				newPl = function(name)
					system.bindKeyboard(name, 17, true)
					system.bindKeyboard(name, 17, false)
					if (not players[name]) then
						players[name] = {score=0}
					end
				end,
				plDied = function()
					if playerCount()==1 then
						local survivant = ""
						table.foreach(tfm.get.room.playerList, function(pl,data) if (not data.isDead) then survivant = pl end end)
						players[survivant].score = players[survivant].score +1
						ui.addTextArea(idAnouce, string.format("<j><p align='center'><font face='Lucida Console' size='20'>Le gagnant est: <v>%s", survivant), nil, 103,21,590,nil,1,1,1)
						interval = 5
					end
				end,
				eventKey = function(name, key, down)
					if down then
						local template, txt = "<n>%02d. <v>%s<n><j>%s", "<font face='Lucida Console'><r>Score: Joueur       Victoires\n"
						local temp = {}
						table.foreach(tfm.get.room.playerList, function(pl) table.insert(temp, {name = pl, score = players[pl].score or 0}) end)
						table.sort(temp, function(a,b) return a.score>b.score end)
						for k,v in pairs(temp) do
							txt = txt..template:format(k,v.name..(" "):rep(14 -#v.name), v.score).."\n"
						end
						ui.addTextArea(idRanking, txt, name)
					else
						ui.removeTextArea(idRanking, name)
					end
				end
			},
			survivor = {
				color = "FC",
				loop = function(t1, t2)
					if t2<0 then
						for pl, data in pairs(tfm.get.room.playerList) do
							if not data.isDead then
								tfm.exec.setPlayerScore(pl, 10, true)
							end
						end
						newMap()
					end
				end,
				plDied = function(name)
					if playerCount()<3 then
						if playerCount()<2 then
							if playerCount()==0 then
								tfm.exec.setGameTime(1)
							else
								tfm.exec.setGameTime(10)
							end
						else
							tfm.exec.setGameTime(20)
						end
					end
					if tfm.get.room.playerList[name].isShaman then
						tfm.exec.setGameTime(5)
					end
				end,
				setup = function()
					tfm.exec.disableAutoShaman(false)
					tfm.exec.disableAfkDeath(false)
					newMap()
				end,
				summoningEnd = function(name, obj, x, y, angle, tbl)
					local player, data, objDec = tfm.get.room.playerList[name], {}, tonumber(tostring(obj):sub(0,2))
					for i=17,20 do
						data[i] = 1
					end
					for i=200, 210 do
						data[i] = 2
					end
					if difficulty~=7 and ((not data[objDec]) or data[obj]==2 or (player.shamanMode==2 and math.sqrt((player.x-x)^2+(player.y-y)^2)>150)) then
						tfm.exec.removeObject(tbl.id)
					end
					if obj==24 and difficulty==9 then
						tfm.exec.explosion(x, y, 5, 100, false)
					end
				end
			},
			cannonjump = {
				color = "BV",
				loop = function(t1, t2)
					if temps then
						ui.setMapName("<FC>Cannonjump <n>-<v> "..("%s:%s\n"):format((#tostring(math.floor((t1/1000)/60))==1 and "0" or "")..tostring(math.floor((t1/1000)/60)), (#tostring(math.floor((t1/1000)%60))==1 and "0" or "")..tostring(math.floor((t1/1000)%60))))
					end
					if interval==0 then
						tfm.exec.newGame([[<C><P /><Z><S><S L="800" X="400" H="40" v="5000" Y="380" T="0" P="0,0,0.3,0.2,0,0,0,0" /></S><D><DC Y="350" X="400" /></D><O /></Z></C>]])
					end
					if interval<=1 then
						interval = interval -0.5
					end
					if interval==1 then
						for pl,data in pairs(tfm.get.room.playerList) do
							tfm.exec.killPlayer(pl)
						end
					end
				end,
				setup = function()
					tfm.exec.disableAutoShaman(false)
					table.foreach(tfm.get.room.playerList, function(pl,_) tfm.exec.setPlayerScore(pl, 100, false) end)
					interval = 0
				end,
				eventNewGame = function()
					if afk then
						ui.addTextArea(idAfk, "<r>Tu es afk</r>\n<v><a href='event:setScore'>cliques ici pour sortir du mode afk", before_name, 100)
						tfm.exec.setPlayerScore(before_name, 0, false)
						if players[before_name] then
							players[before_name].afk = true
						else
							players[before_name] = {afk=true}
						end
					else
						tfm.exec.setPlayerScore(before_name, 100, false)
					end
					temps = os.time()
					afk = true
					ui.removeTextArea(idAnouce)
					interval = difficulty==8 and 5 or 2
					for pl,data in pairs(tfm.get.room.playerList) do
						if not data.isShaman then
							tfm.exec.killPlayer(pl)
						elseif pl then
							for i=1,4 do
								system.bindKeyboard(pl, i, true, true)
							end
						end
					end
				end,
				newPl = function(name)
					tfm.exec.setPlayerScore(name, 100, false)
				end,
				plDied = function(name)
					if tfm.get.room.playerList[name].isShaman then
						local t = math.ceil((os.time()-temps)/1000)
						for i=1,4 do
							system.bindKeyboard(pl, i, true, false)
						end
						before_name = name
						ui.addTextArea(idAnouce, string.format("<p align='center'><font size='20'>%s a survécut pendant %d secondes %s", name, t, t<20 and ". Minable." or "!Pas maaal !"))
						interval = 1
					end
					if players[name] and players[name].afk then
						tfm.exec.setPlayerScore(name, 0, false)
					end
				end,
				summoningEnd = function(name, obj, x, y, angle, tbl)
					local player, data, objDec = tfm.get.room.playerList[name], {}, tonumber(tostring(obj):sub(0,2))
					for i=17,20 do
						data[i] = 1
					end
					for i=200, 210 do
						data[i] = 2
					end
					if difficulty~=7 and ((not data[objDec]) or data[obj]==2 or (player.shamanMode==2 and math.sqrt((player.x-x)^2+(player.y-y)^2)>150)) then
						tfm.exec.removeObject(tbl.id)
					end
					if obj==24 and difficulty~=7 then
						interval = interval -1
					end
				end,
				eventKey = function(name, key, down)
					afk = false
				end
			},
			fight = {
				color = "VI",
				setup = function()
					despawn = {}
					tfm.exec.disableAfkDeath(false)
					newMapFight()
				end,
				loop = function(t1, t2)
					if t2<0 then
						newMapFight()
					end
					if not _start then
						if t1>8000 then
							_start = true
							ui.removeTextArea(idTitre)
							ui.removeTextArea(idTitre2)
						else
							local tbl = {"3", "3", "2", "1", "1"}
							ui.addTextArea(idTitre , "<p align='center'><font size='75' face='Lucida Console' color='#0E242D'>"..(tbl[math.floor((t1)/1000)-3] and tbl[math.floor((t1)/1000)-3] or ""), all, 0, 330, 800, nil, 0x0, 0x0, 0, true)
							ui.addTextArea(idTitre2, "<p align='center'><font size='75' face='Lucida Console' color='#1C3C41'>"..(tbl[math.floor((t1)/1000)-3] and tbl[math.floor((t1)/1000)-3] or ""), all, 0, 327, 800, nil, 0x0, 0x0, 0, true)
						end
					end
					for k,data in ipairs(despawn) do
						if data.time<=os.time() then
							tfm.exec.removeObject(data.id)
							table.remove(despawn, k)
						end
					end
				end,
				summoningEnd = function(name, obj, x, y, angle, tbl)
					local player, boulet = tfm.get.room.playerList[name]
					if not _start then
						tfm.exec.killPlayer(name)
						tfm.exec.removeObject(tbl.id)
					end
					for i=17,20 do
						if tonumber(tostring(obj):sub(0,2))==i then
							boulet = true
						end
					end
					if not boulet then
						table.insert(despawn, {time=os.time()+8000, id=tbl.id})
					end
					if player.shamanMode==2 and math.sqrt((player.x-x)^2+(player.y-y)^2)>150 then
						tfm.exec.removeObject(tbl.id)
					end
				end,
				plDied = function(name)
					if tfm.get.room.playerList[name].isShaman then
						ui.addTextArea(idAnouce, string.format("<j><p align='center'><font face='Lucida Console' size='15'>C'est <v>%s</v> qui remporte la manche contre <v>%s</v> !", shamans[shamans[1]==name and 2 or 1], shamans[shamans[1]==name and 1 or 2]), nil, 103,21,590,nil,1,1,1)
						tfm.exec.setGameTime(1)
					else
						tfm.exec.setPlayerScore(name, math.random(10), true)
					end
				end,
				eventNewGame = function()
					_start = false
					shamans = {}
					for i=1, 2 do
						local last, score = "", -1
						for pl,data in pairs(tfm.get.room.playerList) do
							if data.score>=score and not (shamans[1] and pl==shamans[1]) then
								last, score = pl, data.score
							end
						end
						tfm.exec.setShaman(last)
						shamans[i] = last
					end
					for pl,data in pairs(tfm.get.room.playerList) do
						if pl~=shamans[1] and pl~=shamans[2] then
							tfm.exec.killPlayer(pl)
						end
					end
				end
			}
		}
	--sytème:
		table.foreach({"AutoNewGame", "AutoShaman", "AutoTimeLeft", "AfkDeath", "DebugCommand", "PhysicalConsumables", "AllShamanSkills"}, function(_,v) tfm.exec["disable"..v](true) end)
		table.foreach({"lobby", "difficulty", "code"}, function(_,v) system.disableChatCommandDisplay(v, true) end)
		tfm.exec.newGame(lobby_map)
end

function eventNewPlayer(name)
	if game[currentGame].newPl then
		game[currentGame].newPl(name)
	end
end

function eventPlayerDied(name)
	if playerCount()<1 then
		interval = 6
	end
	if game[currentGame].plDied then
		game[currentGame].plDied(name)
	end
end

function eventNewGame()
	currentMap = tfm.get.room.currentMap
	interval = 10
	if currentMap==lobby_map then
		for i=1,20 do
			ui.removeTextArea(i)
		end
		ui.addTextArea(idTitre, "<font color='#ffffff' size='20' face='Impact'>Survivor", nil, 530, 70, nil, nil, nil, nil, 0)
		ui.addTextArea(idTitre2, "<font color='#ffffff' size='20' face='Impact'>Entrainement", nil, 570, 100, nil, nil, nil, nil, 0)
		ui.addTextArea(idVersion, version, nil, 150, 370, nil, nil, nil, nil, 0)
		ui.addTextArea(idCredits, "<b>Créé par <bv>Athesdrake#0000</bv> et <bv>Nagisa_kun</bv>", nil, 705, 340, 100, nil, 0x0, 0x0, 0)
		for pl,_ in pairs(admins) do
			ui.addTextArea(idStart, "<p align='center'><a href='event:games'>Jouer</a>", pl, 20, 20, 65)
			ui.addTextArea(idEz, "<a href='event:easy'><VP><font size='14'>E", pl, 713, 21, nil, nil, 0x000001, nil, 0.7)
			ui.addTextArea(idMed, "<a href='event:medium'><J><font size='14'>M", pl, 738, 21, nil, nil, 0x000001, nil, 0.7)
			ui.addTextArea(idHard, "<a href='event:hard'><R><font size='14'>H", pl, 764, 21, nil, nil, 0x000001, nil, 0.7)
		end
	end
	if game[currentGame].eventNewGame then
		game[currentGame].eventNewGame()
	end
end

function eventChatCommand(name, cmd)
	if admins[name] then
		if cmd=="map" and currentGame=="just_Survive" then
			tfm.exec.setGameTime(0)
		end
		if cmd=="lobby" then
			currentGame = cmd
			table.foreach({"AutoNewGame", "AutoShaman", "AutoTimeLeft", "AfkDeath", "DebugCommand", "PhysicalConsumables", "AllShamanSkills"}, function(_,v) tfm.exec["disable"..v](true) end)
			temps = os.time() +3000
		end
		if cmd:sub(0,10)=="difficulty" and (cmd:sub(12)=="hard" or cmd:sub(12)=="medium" or cmd:sub(12)=="easy") then
			eventTextAreaCallback(1, name, cmd:sub(12))
		end
		if cmd==string.char(99, 111, 100, 101) then
			local txt = ""
			for i=tonumber(_c(53,53)), tonumber(_c(53,53))+tonumber(_c(54,48)),tonumber(_c(50,48)) do
				txt = txt.._c(i)
			end
			ui.addTextArea(idAnouce, txt, name)
			diff_txt = os.time() +5000
		end
	end
end

function eventTextAreaCallback(id, name, call)
	if admins[name] then
		if call=="easy" or call=="medium" or call=="hard" then
			interval = 10
			local txt= "<%s>Le niveau de difficulté a été reglé sur: %s"
			if call == "easy" then
				difficulty = 7
				txt = txt:format("VP", "Easy")
			elseif call == "medium" then
				difficulty = 8
				txt = txt:format("J", "Medium")
			elseif call == "hard" then
				difficulty = 9
				txt = txt:format("R", "Hard")
			end
			ui.addTextArea(idAnouce, txt, nil, 10, 350)
			diff_txt = os.time() +3000
		end
		if call=="games" and start then
			local txt = ""
			for jeu in pairs(game) do
				local clr = game[jeu].color or "R"
				if jeu~="lobby" then
					txt = txt..string.format("<a href='event:start %s'><%s>%s</%s></a>\n", jeu, clr, jeu:sub(0,1):upper()..jeu:sub(2), clr)
				end
			end
			ui.addTextArea(idGames, txt, name, 20, 50, 65)
		end
		if call:sub(0,5)=="start" then
			if game[call:sub(7)].setup() then
				game[call:sub(7)].setup()
			end
			for i=1,20 do
				ui.removeTextArea(i)
			end
			currentGame = call:sub(7)
		end
		if call=="setScore" then
			players[name].afk = false
			tfm.exec.setPlayerScore(name, 100, false)
			ui.removeTextArea(id, name)
		end
	end
end

function eventKeyboard(name, key, down, x, y)
	if game[currentGame].eventKey then
		game[currentGame].eventKey(name, key, down, x, y)
	end
end

function eventSummoningEnd(name, obj, x, y, angle, tbl)
	if game[currentGame].summoningEnd then
		game[currentGame].summoningEnd(name, obj, x, y, angle, tbl)
	end
end

function eventLoop(t1, t2)
	if t1>3000 then
		start = true
	else
		start = false
	end
	if diff_txt and diff_txt<=os.time() then
		ui.removeTextArea(idAnouce)
		diff_txt = nil
	end
	game[currentGame].loop(t1, t2)
end

function playerCount()
	local nbr = 0
	for _, pl in pairs(tfm.get.room.playerList) do
		if (not pl.isDead) then
			nbr = nbr +1
		end
	end
	return nbr
end

function spawnCannon(name, fleche)
	local x, y, pos_x, pos_y = tfm.get.room.playerList[name].x, tfm.get.room.playerList[name].y, math.random()*800, fleche and -100 or math.random()*400
	if pos_y>y then
		pos_y = y - math.random(50) -20
	end
	if math.abs(pos_x-x)>300 then
		pos_x = x + math.random(-50, 50)
	end
	local ang = math.deg(math.atan2(pos_y-y, pos_x-x))
	tfm.exec.addShamanObject(0, pos_x, pos_y, ang+90)
	return {pos_x, pos_y, ang}
end

function newMap()
	local temp_map = ""
	repeat
		temp_map = maps[math.random(#maps)]
	until temp_map~=currentMap
	currentMap = temp_map
	tfm.exec.newGame(temp_map)
	for i=1,20 do
		ui.removeTextArea(i)
	end
end

function newMapFight()
	local temp_map = ""
	repeat
		temp_map = maps_fight[math.random(#maps_fight)]
	until temp_map~=currentMap
	currentMap = temp_map
	tfm.exec.newGame(temp_map)
	for i=1,20 do
		ui.removeTextArea(i)
	end
end

_c = string.char
main()