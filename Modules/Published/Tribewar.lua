--[[      Module Tribewar      ]]--
--[[   Created by Athesdrake   ]]--

-- Old module: the code is not perfect and not optimized.

function main()
		chefs  = {"Chef1", "Chef2"} -- Vous pouvez rajouter plus de tribus en rajoutant un chef en plus !
		colors = {0xFF0000, 0xFF, 0x1} -- Vous pouvez changer les couleurs. La première couleur est associée à la première personne juste au-dessus
		bannis = {}
		maps = {0,1,2,3,4,5,6,10,11,14,16,17,18,19,20,21,22,24,25,26,27,28,29,31,32,36,39,40,41,42,44,45,46,47,48,49,50,51,52,53,54,55,57,58,60,61,62,66,67,69,70,71,72,73,74,75,7,77,79,80,85,86,90,91,93,96,97,98,99,100,109,115,119,122,123,127,128,129,130,131,133,134,138,139,140,142,143,144,145,146,147,150}
	-- NE RIEN MODIFIER EN DESSOUS !! --
		players = {}
		tribu = {}
		game = {}
		list_map = {}
		after_tbl = {}
	--vars:
		currentMap = 0
		version = "1.2a"
	--ids:
		id_annonce = 1
		id_scoreboard = 2
		id_quest = 3
	--sytème:
		table.foreach({"AutoNewGame", "AutoShaman", "AutoTimeLeft", "AfkDeath", "DebugCommand", "PhysicalConsumables"}, function(_,v) tfm.exec["disable"..v](true) end)
		tfm.exec.setAutoMapFlipMode(false)
		table.foreach({"next", "ban", "score"}, function(_,v) system.disableChatCommandDisplay(v, true) end)
		table.foreach(tfm.get.room.playerList, function(v) eventNewPlayer(v) end)
		--tfm.exec.newGame([[<C><P /><Z><S><S L="800" o="324650" H="30" X="400" Y="385" T="12" P="0,0,0.3,0.2,0,0,0,0" /></S><D><DS Y="357" X="322" /></D><O /></Z></C>]])
		--currentMap = -1
		setup()
end

function setup()
	if checkChefs() then
		if checkChefs()==1 then
			ui.removeTextArea(id_annonce)
			for key,chef in pairs(chefs) do
				if type(chef)=="string" then
					table.insert(tribu, {chefs = chef, nom = tfm.get.room.playerList[chef].tribeName, players = {}, score = 0})
					chefs[chef] = key
				end
			end
			table.insert(tribu, {nom="None", players = {}, score = 0})
			table.foreach(tfm.get.room.playerList, function(v) eventNewPlayer(v) end)
			table.foreach({"AutoShaman", "AutoTimeLeft", "AfkDeath"}, function(_,v) tfm.exec["disable"..v](false) end)
			for i=1,30 do
				local map = 0
				repeat
					map = maps[math.random(#maps)]
				until (not inTable(list_map, map))
				table.insert(list_map, map)
			end
			table.sort(list_map)
			after(5, newMap())
		else
			ui.annonce("Les Représentants de Tribu ne sont pas encore présents dans le salon !")
			after(5, setup)
		end
	else
		ui.annonce("Les Représentants de Tribu ne sont pas référencés (ou mal) !")
	end
end

function eventNewPlayer(name)
	if not players[name] then
		players[name] = {score = 0}
	end
	if tribu[1] then
		local tp = tfm.get.room.playerList[name].tribeName
		tp = (tp==tribu[1].nom and 1 or (tp==tribu[2].nom and 2 or 3))
		tfm.exec.setNameColor(name, colors[tp])
		if not table.isIn(tribu[tp].players, name) then
			table.insert(tribu[tp].players, name)
		end
		players[name].tribe = tp
	end
	if currentMap==-1 then
		tfm.exec.respawnPlayer(name)
	end
	system.bindKeyboard(name, 17, true, true)
	system.bindKeyboard(name, 17, false, true)
end

function eventPlayerLeft(name) eventPlayerDied(name) end

function eventPlayerDied(name)
	if countPlayer(true)<=2 then
		tfm.exec.setGameTime(20)
	end
	if countPlayer(true)<=0 then
		newMap()
	end
	if currentMap==-1 then
		tfm.exec.respawnPlayer(name)
	end
end

function eventPlayerWon(name)
	if game.enter and players[name].tribe~=3 then
		if not game.winners then
			game.winners = {}
		end
		table.insert(game.winners, name)
		players[name].score = players[name].score +game.enter
		tribu[players[name].tribe].score = tribu[players[name].tribe].score +game.enter
		ui.annonce(string.format("%s vient de marquer %d point%s pour sa tribu, %s", name, game.enter, game.enter==1 and "" or "s", tribu[players[name].tribe].nom), true)
		game.enter = game.enter -1
		if game.enter==0 then
			game.enter = nil
		end
	end
	eventPlayerDied(name)
end

function eventTextAreaCallback(id, name, call)
	if call:sub(0,4)=="next" then
		ui.removeTextArea(id_quest, name)
		if call:sub(6)=="accept" then
			newMap()
		else
			ui.addTextArea(id_quest, name.." a refuser de passer cette map.", chefs[chef[1]==name and 2 or 1], 6, 200, nil, nil, nil, 0xff, 0.5, true)
			after(5, function() ui.removeTextArea(id_quest) end)
		end
	end
	if call:sub(0,3)=="ban" then
		ui.removeTextArea(id_quest, name)
		if call:sub(5,11)=="accept" then
			ban(call:sub(13))
		else
			ui.addTextArea(id_quest, name.." a refuser de bannir "..call:sub(13), chefs[chef[1]==name and 2 or 1], 6, 200, nil, nil, nil, 0xff, 0.5, true)
		end
	end
end

function eventChatCommand(name, cmd)
	if cmd=="score" then
		eventKeyboard(name, 1, true)
	end
	if chefs[name] and false then
		if cmd=="next" then
			ui.addTextArea(id_quest, string.format("%s, le représentant de la tribu %s, souhaite passer cette map.\n<p align='center'><a href='event:next accept'>Accepter</a>\t\t<a href='event:next refuse'>Refuser</a>", name, tribu[players[name].tribe].nom), chefs[chefs[1]==name and 2 or 1], 6, 200, nil, nil, nil, 0xff, 0.5, true)
		end
		if cmd:sub(0,3)=="ban" then
			if cmd:sub(5)~="" and tfm.get.room.playerList[cmd:sub(5)] then
				ui.addTextArea(id_quest, string.format("%s, le représentant de la tribu %s, souaite bannir %s.\n<p align='center'><a href='event:ban accept %s'>Accepter</a>\t\t<a href='event:ban refuse %s'>Refuser</a>", name, tribu[players[name].tribe].nom, call:sub(5), call:sub(5), call:sub(5)), chefs[1], 6, 200, nil, nil, nil, 0xff, 0.5, true)
			end
		end
	end
end

function eventKeyboard(name, key, down, x, y)
	if down and tribu[1] then
		local txt = "<p align='center'><font size='30'><u>Scoreboard</u></font></p>\n"
		for k,data in pairs(tribu) do
			if data.nom~="None" then
				txt = txt..("<font size='20'><u><b>%s</b></u></font>\t\t%s points<font face='Lucida Console'><r>\n\tn. joueur           points\n</r>"):format(data.nom, data.score)
				table.sort(data.players, function(a,b) return players[a].score>players[b].score end)
				for key,pl in pairs(data.players) do
					txt = txt..("   <n>%0d. <v>%s<n><j>%d</j></n></v></n>\n"):format(key, pl..(" "):rep(20 -#pl), players[pl].score)
				end
				txt = txt.."</font>"
			end
		end
		ui.addBox(id_scoreboard, txt, name, 50, 27, 700, 350)
		ui.addTextArea(id_scoreboard*100+6, "<b>"..string.char(77, 111, 100, 117, 108, 101, 32, 99, 114, 101, 97, 116, 101, 100, 32, 98, 121, 32, 65, 116, 104, 101, 115, 100, 114, 97, 107, 101), name, 57, 357, nil, nil, 0x0, 0x0, 0, true)
		ui.addTextArea(id_scoreboard*100+7, "<b>V"..version, name, 707, 357, nil, nil, 0x0, 0x0, 0, true)
	else
		ui.removeBox(id_scoreboard, name)
	end
end

function eventNewGame()
	if game.winners then
		local tribu1, tribu2, point1, nbrwin1, point2, nbrwin2 = tribu[1], tribu[2], countPoint(1), countPoint(2)
		if tribu1.score==tribu2.score then
			ui.annonce(("La tribu %s et la tribu %s sont à ex-aequo! Serrez les fesses pour démarquer votre tribu !"):format(tribu[1].nom, tribu[2].nom), true)
		elseif nbrwin1==3 then
			ui.annonce(("La tribu %s a mis la patate, elle remporte les 3 firsts!"):format(tribu1.nom), true)
		elseif nbrwin2==3 then
			ui.annonce(("La tribu %s a mis la patate, elle remporte les 3 firsts!"):format(tribu2.nom), true)
		else
			ui.annonce(("La tribu %s a mis %s point%s et %s en a mis %s"):format(tribu1.nom, point1, point1==1 and "" or "s", tribu2.nom, point2), true)
		end
		game.winners = {}
		for _,pl in pairs(bannis) do
			tfm.exec.killPlayer(name)
		end
	end
	game.enter = 3
end

function eventLoop(t1, t2)
	if after_tbl then
		for k,v in ipairs(after_tbl) do
			if v.time<=os.time() then
				v.fonction()
				table.remove(after_tbl, k)
			end
		end
	end
	if t2<0 and currentMap~=-1 then
		newMap()
	end
end

function countPlayer(bool)
	local nbr = 0
	for k,v in pairs(tfm.get.room.playerList) do
		if (not bool) or (not v.isDead) then
			nbr = nbr +1
		end
	end
	return nbr
end

function countPoint(n)
	local tbl, points, pl = {3,2,1}, 0, 0
	table.foreach(game.winners, function(k,v) if players[v] and players[v].tribe==n then points = points +tbl[k];pl = pl +1 end end)
	return points, pl
end

function after(temps, fonction)
	if fonction then
		table.insert(after_tbl ,{time = os.time()+temps*1000, fonction = fonction})
	end
end

function inTable(tbl, cherche)
	for k,v in pairs(tbl) do
		if v==cherche then
			return true
		end
	end
	return false
end

function newMap()
	currentMap = currentMap +1
	if list_map[currentMap] then
		tfm.exec.newGame(list_map[currentMap], (not list_map[currentMap]) and math.random(10)==3)
		table.remove(list_map, currentMap)
		table.sort(list_map)
	else
		table.foreach({"AutoNewGame", "AutoShaman", "AutoTimeLeft", "AfkDeath", "DebugCommand", "PhysicalConsumables"}, function(_,v) tfm.exec["disable"..v](true) end)
		currentMap = -1
		tfm.exec.newGame([[<C><P /><Z><S><S L="800" o="324650" H="30" X="400" Y="385" T="12" P="0,0,0.3,0.2,0,0,0,0" /></S><D><DS Y="357" X="322" /></D><O /></Z></C>]])
		eventKeyboard(name, 1, true)
	end
end

function table.isIn(tbl, var)
	if not type(tbl)=="table" then
		return false
	end
	for k,v in pairs(tbl) do
		if v==var then
			return true
		end
	end
	return false
end

function ban(name)
	ui.addTextArea(id_ban, "Banni !", name, -10^4, -10^4, 2*10^4, 2*10^4, 0x0, 0x0, 1, true)
	tfm.exec.killPlayer(name)
	table.insert(bannis, name)
end

function checkChefs()
	for key,chef in pairs(chefs) do
		if type(chef)=="string" then
			for key2,chef2 in pairs(chefs) do
				if key~=key2 and chef==chef2 then
					return false
				end
			end
			if not tfm.get.room.playerList[chef] then
				return true
			end
		end
	end
	return 1
end

ui.annonce = function(txt, supp)
	ui.addTextArea(id_annonce, "<p align='center'><font size='15'>"..txt, nil, 50, 25, 700, 50, nil, 0xff, 0.5, true)
	if supp then
		after(7, function() ui.removeTextArea(id_annonce) end)
	end
end

ui.addBox = function(id, txt, name, x, y, largeur, hauteur)
	if (not txt) then txt = "" end
	if (not x) then x = 100 end
	if (not y) then y = 100 end
	if (not hauteur) then hauteur = 200 end
	if (not largeur) then largeur = 200 end
	ui.addTextArea(id*100+0 ," ", name, x+0, y+0, largeur     , hauteur   , 0x2D211A, 0x2D211A, 0.8, true)
	ui.addTextArea(id*100+1 ," ", name, x+1, y+1, largeur-2   , hauteur-2 , 0x986742, 0x986742, 1  , true)
	ui.addTextArea(id*100+2 ," ", name, x+4, y+4, largeur-8   , hauteur-8 , 0x171311, 0x171311, 1  , true)
	ui.addTextArea(id*100+3 ," ", name, x+5, y+5, largeur-10  , hauteur-10, 0x0C191C, 0x0C191C, 1  , true)
	ui.addTextArea(id*100+4 ," ", name, x+6, y+6, largeur-12  , hauteur-12, 0x24474D, 0x24474D, 1  , true)
	ui.addTextArea(id*100+5 ," ", name, x+7, y+7, largeur-14  , hauteur-14, 0x183337, 0x183337, 1  , true)
	ui.addTextArea(id       ,txt, name, x+8, y+8, largeur-16  , hauteur-16, 0x122528, 0x122528, 1  , true)
end

ui.removeBox = function(id, name)
	if id then
		ui.removeTextArea(id, name)
		for i=id*100, id*100+15 do
			ui.removeTextArea(i, name)
		end
	end
end

main()