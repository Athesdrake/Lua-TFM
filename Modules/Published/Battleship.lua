--[           BattleShip           ]--
--[  Module created by Athesdrake  ]--
--[  link:  https://goo.gl/opffTE  ]--

-- Old module: the code is not perfect and not optimized.

function main()
--ids
	idUi = 1
	idJoueurs = 2
	idMsg = 3
	idBato = 4
	idLegende = 5
	idOPl = 6
--tables
	jeux = {}
	task = {}
	taskChange = {}
	players = {}
	directions = {"haut", "right", "bas", "left"}
	bato = {}
	bato[2] = {
			haut={"■", "<font color='#00FF00'>■</font>"};
			right={"<font color='#00FF00'>■</font>", "■"};
			bas={"<font color='#00FF00'>■</font>", "■"};
			left={"■", "<font color='#00FF00'>■</font>"}
		}
	bato[3] = {
			haut={"■", "■", "<font color='#00FF00'>■</font>"};
			right={"<font color='#00FF00'>■</font>", "■", "■"};
			bas={"<font color='#00FF00'>■</font>", "■", "■"};
			left={"■", "■", "<font color='#00FF00'>■</font>"}
		}
	bato[4] = {
			haut={"■", "■", "■", "<font color='#00FF00'>■</font>"};
			right={"<font color='#00FF00'>■</font>", "■", "■", "■"};
			bas={"<font color='#00FF00'>■</font>", "■", "■", "■"};
			left={"■", "■", "■", "<font color='#00FF00'>■</font>"}
		}
	bato[5] = {
			haut={"■", "■", "■", "■", "<font color='#00FF00'>■</font>"};
			right={"<font color='#00FF00'>■</font>", "■", "■", "■", "■"};
			bas={"<font color='#00FF00'>■</font>", "■", "■", "■", "■"};
			left={"■", "■", "■", "■", "<font color='#00FF00'>■</font>"}
		}
	playerList = tfm.get.room.playerList
	for pl in pairs(playerList) do
		eventNewPlayer(pl)
	end
end

function eventNewPlayer(name)
	players[name] = {isPlaying = false}
	showUi(name, 1)
end

function showUi(name, nbr)
	if nbr==1 then
		ui.addTextArea(idUi, "<a href='event:playPlayer'>Jouer contre un joueur</a>", name, 0, 30, nil, nil, nil, nil, 1, true)
	end
	if nbr==2 then
		ui.addTextArea(idUi, "<VP>Jouer contre un joueur</VP>", name, 0, 30, nil, nil, nil, nil, 1, true)
	end
	if nbr==3 then
		ui.addTextArea(idUi*100+2, "", name, 193, 231, 60, 0, 0xA4A7AC, 0xA4A7AC, 1, true)
		ui.addTextArea(idUi*100+3, "", name, 191, 214, 14, 60, 0xA4A7AC, 0xA4A7AC, 1, true)
		ui.addTextArea(idUi*100+4, "", name, 2, 174, 100, 100, 0xA4A7AC, 0xA4A7AC, 1, true)
		ui.addTextArea(idUi*100+5, "", name, 2, 28, 100, 100, 0xA4A7AC, 0xA4A7AC, 1, true)
		ui.addTextArea(idUi*100+6, "", name, 277, 28, 100, 100, 0xA4A7AC, 0xA4A7AC, 1, true)
		ui.addTextArea(idUi, "", name, 6, 229, 195, 41, 0x808080, 0x808080, 1, true)
		ui.addTextArea(idUi*100, "", name, 6, 32, 367, 195, 0x808080, 0x808080, 1, true)
		ui.addTextArea(idUi*100+1, "", name, 8, 220, 191, 14, 0x808080, 0x808080, 1, true)
	end
end

function eventTextAreaCallback(id, name, call)
	if call:sub(0,4)=="play" then
		if call:sub(5)=="Player" then
			local txt = ""
			for pl in pairs(playerList) do
				if pl==name then
				else
					txt = txt.."<a href='event:playWith"..pl.."'>"..pl.."</a>\n"
				end
			end
			txt = txt.."\n<a href='event:annuler'>annuler</a>"
			ui.addTextArea(idJoueurs, txt, name,  10, 75, nil, nil, nil, nil, 1, true)
		end
		if call:sub(5,8)=="With" and players[call:sub(9)].isPlaying==false then
			players[name].isPlaying = true
			players[call:sub(9)].isPlaying = true
			task[#task+1] = {name, call:sub(9)}
			ui.addPopup(idJoueurs, 1, "<p align='center'>"..name.." veut faire un touché-coulé avec toi !\nAccepter ?", call:sub(9), 250, 200, 300, true)
			ui.removeTextArea(idJoueurs, name)
			showUi(name, 2)
		end
	end
	if call:sub(0,4)=="boat" then
		local dir = ""
		for k,v in pairs(directions) do
			if v==players[name].dir then
				if call:sub(5,8)=="Left" then
					dir = k-1
					if dir==0 then
						dir = 4
					end
				else
					dir = k+1
					if dir==5 then
						dir = 1
					end
				end
			end
		end
		afficheBato(name, players[name].numBato, directions[dir])
	end
	if call:sub(0,5)=="place" then
		local place = {}
		for k, v in string.gmatch(call, "%S+") do
			table.insert(place, k)
		end
		local id = tonumber(place[5])
		local x = tonumber(place[3])
		local y = tonumber(place[4])
		local nbr = players[name].numBato
		if checkPlace(name, x, y, id, nbr, players[name].dir) then
			if nbr~=1 then
				for i=0, players[name].numBato-1 do
					if players[name].dir=="left" then
						jeux[id]["carte"..name][x-i][y] = 1
					elseif players[name].dir=="bas" then
						jeux[id]["carte"..name][x][y+i] = 1
					elseif players[name].dir=="right" then
						jeux[id]["carte"..name][x+i][y] = 1
					elseif players[name].dir=="haut" then
						jeux[id]["carte"..name][x][y-i] = 1
					end
				end
				nbr = nbr-1
				if players[name].bato3 and nbr==2 then
					nbr = 3
					players[name].bato3 = false
				end
				battle(id, false, false, "place", nbr, "haut", name)
			end
			if nbr==1 then
				players[name].finishPlace = true
				for _,pl in pairs(jeux[id].players) do
					if pl==name then
					else
						if players[pl].finishPlace then
							battle(id, jeux[id].players[1], jeux[id].players[2], "fire", 1)
						end
						ui.removeTextArea(idBato, name)
						ui.addTextArea(idLegende, "<p align='center'><font size='16'><b><u>Legende</u></b></p><p align='left'><font size='16'>\n■</font>\tPas découvert<font size='16' color='#00FF00'>\n■</font>\tBateau<font size='16' color='#007FFF'>\n■</font>\tEau<font size='16' color='#FF0000'>\n■</font>\tBateau Touché", name, 207, 35, 163, nil, nil, nil, 0, true)
						ui.addTextArea(idMsg, "<font color='#FF0000'><b>"..name.." est prêts pour le combat !</b></font>", pl, 9, 227, 189, 40, nil, nil, 0, true)
					end
				end
			end
		else
			ui.addTextArea(idMsg, "<b>Tu ne peux pas mettre le bateau la !</b>", name, 9, 227, 189, 40, nil, nil, 0, true)
		end
	end
	if call:sub(0,4)=="fire" and players[name].click then
		local fire = {}
		for k, v in string.gmatch(call, "%S+") do
			table.insert(fire, k)
		end
		local uid = tonumber(fire[2])
		local x = tonumber(fire[3])
		local y = tonumber(fire[4])
		local idP = tonumber(fire[5])
		local num = tonumber(fire[6])
		local name2 = jeux[idP].players[num]
		local toucher = false
		local txt = "<font size='16' color='#"
		if jeux[idP]["carte"..name2][x][y]==1 then
			txt = txt.."FF0000"
			jeux[idP]["carte"..name2][x][y] = 3
			toucher = true
		elseif jeux[idP]["carte"..name2][x][y]==0 then
			txt = txt.."007FFF"
			jeux[idP]["carte"..name2][x][y] = 2
		end
		txt = txt.."'>■</font>"
		for _,pl in pairs(jeux[idP].players) do
			ui.addTextArea(uid, txt, pl, 10+x*18, 35+y*18, nil, nil, nil, nil, 0, true)
		end
		if toucher then
			local boom = 0
			players[name].boom = players[name].boom + 1
			boom = players[name].boom
			ui.addTextArea(idMsg, "<p align='center'><font size='14' color='#FF0000'><b>Touché!", name, 9, 227, 189, 40, nil, nil, 0, true)
			ui.addTextArea(idMsg, "<p align='center'><font size='14' color='#FF0000'><b>Touché!", name2, 9, 227, 189, 40, nil, nil, 0, true)
			if boom==17 then
				players[name].click = false
				ui.addTextArea(idMsg, name.." a gagné !", name2, 9, 227, 189, 40, nil, nil, 0, true)
				ui.addTextArea(idMsg, "Tu as gagné !", name, 9, 227, 189, 40, nil, nil, 0, true)
				ui.addTextArea(idOPl, "<a href='event:"..idP.."'>Cliques ici pour voir\nle jeu de "..name2.."</a>", name, 210, 200, nil, nil, nil, nil, 0, true)
				ui.addTextArea(idOPl, "<a href='event:"..idP.."'>Cliques ici pour voir\nle jeu de "..name.."</a>", name2, 210, 190, nil, nil, nil, nil, 0, true)
			else
				battle(idP, jeux[idP].players[1], jeux[idP].players[2], "fire", num)
			end
		else
			ui.addTextArea(idMsg, "<p align='center'><font size='14' color='#007FFF'><b>Plouf !", name, 9, 227, 189, 40, nil, nil, 0, true)
			ui.addTextArea(idMsg, "<p align='center'><font size='14' color='#007FFF'><b>Plouf !", name2, 9, 227, 189, 40, nil, nil, 0, true)
			players[name].click = false
			table.insert(taskChange, {id = idP, p1 = jeux[idP].players[1], p2 = jeux[idP].players[2], stade = "fire", num = (num==1 and 2 or 1), time = os.time()+2000, name = name})
		end
	end
	if id==idOPl then
		local name2 = ""
		for _,pl in pairs(jeux[tonumber(call)].players) do
			if pl==name then
			else
				name2 = pl
			end
		end
		local txt = ""
		for x=0, 9 do
			for y=0, 9 do
				local uid = "666"..tostring(x).."0"..tostring(y)
				local carre = jeux[tonumber(call)]["carte"..name2][x][y]
				if carre==0 then
					txt = "<font size='16' color='#007FFF'>■</font>"
				elseif carre==1 or carre==3 then
					txt = "<font size='16' color='#00FF00'>■</font>"
				end
				ui.addTextArea(tonumber(uid), txt, name, 10+x*18, 35+y*18, nil, nil, nil, nil, 0, true)
			end
		end
	end
	if call=="annuler" then
		ui.removeTextArea(idJoueurs, name)
	end
end

function eventPopupAnswer(id, name, ans)
	if id==idJoueurs then
		for k, v in pairs(task) do
			if task[k][2]==name then
				local name2 = task[k][1]
				if ans=="yes" then
					local nbr = #jeux
					jeux[nbr] = {players = {name2, name}}
					jeux[nbr]["carte"..name2] = {}
					jeux[nbr]["carte"..name] = {}
					for i=0,9 do
						jeux[nbr]["carte"..name2][i] = {}
						jeux[nbr]["carte"..name][i] = {}
					end
					for i=0, 9 do
						for j=0, 9 do
							jeux[nbr]["carte"..name2][i][j] = 0
							jeux[nbr]["carte"..name][i][j] = 0
						end
					end
					for _,pl in pairs(jeux[nbr].players) do
						players[pl].click = true
						players[pl].bato3 = true
						players[pl].finishPlace = false
						players[pl].boom = 0
						battle(nbr, false, false, "place", 5, "haut", pl)
					end
				else
					players[name].isPlaying = false
					players[name2].isPlaying = false
					ui.addPopup(idJoueurs, 0, "<p align='center'>"..name.." a refusé :c</p>", name2, 300, 167.5, nil, true)
					showUi(name2, 1)
				end
				table.remove(task, k)
				break;
			end
		end
	end
end

function battle(id, p1, p2, stade, num, dir, pl)
	if stade=="place" then
		players[pl].dir = dir
		players[pl].numBato = num
		showUi(pl, 3)
		local txt = ""
		for x=0, 9 do
			for y=0, 9 do
				local uid = "666"..tostring(x).."0"..tostring(y)
				if jeux[id]["carte"..pl][x][y]==0 then
					txt = "<font size='16' color='#007FFF'><a href='event:place "..uid.." "..x.." "..y.." "..id.."'>■</a></font>"
				elseif jeux[id]["carte"..pl][x][y]==1 then
					txt = "<font size='16' color='#00FF00'>■</font>"
				end
				ui.addTextArea(tonumber(uid), txt, pl, 10+x*18, 35+y*18, nil, nil, nil, nil, 0, true)
			end
		end
		afficheBato(pl, num, dir)
	end
	if stade=="fire" then
		local twoPl = {}
		local name = ""
		local name2 = ""
		table.insert(twoPl, p1)
		table.insert(twoPl, p2)
		for k, v in pairs(twoPl) do
			name = (num==1 and p1 or p2)
			name2 = (num==2 and p1 or p2)
			for x=0, 9 do
				for y=0, 9 do
					local uid = "666"..tostring(x).."0"..tostring(y)
					local case = jeux[id]["carte"..name][x][y]
					local txt = ""
					if case==0 or case==1 then -- 0 = rien // 1 = bato // 2 = eau // 3 = bato touché
						txt = k==num and (case==1 and "<font size='16' color='#00FF00'>■" or "<font size='16' color='#FFFFFF'>■") or "<font size='16' color='#FFFFFF'><a href='event:fire "..uid.." "..x.." "..y.." "..id.." "..num.."'>■</a>"
					elseif case==2 then
						txt = "<font size='16' color='#007FFF'>■"
					elseif case==3 then
						txt = "<font size='16' color='#FF0000'>■"
					end
					txt = txt.."</font>"
					ui.addTextArea(tonumber(uid), txt, v, 10+x*18, 35+y*18, nil, nil, nil, nil, 0, true)
				end
			end
		end
	end
end

function afficheBato(name, numBato, dir)
	players[name].numBato = numBato
	players[name].dir = dir
	local txt = "<font size='16'>"
	for k, v in pairs(bato) do
		if k==numBato then
			if dir=="bas" or dir=="haut" then
				for i, j in pairs(bato[k][dir]) do
					txt = txt..j.."\n"
				end
			else
				txt = "<font size='22'>\n"
				for i, j in pairs(bato[k][dir]) do
					txt = txt..j
				end
				txt = txt.."\n\n"
			end
		end
	end
	txt = txt.."</font>"
	ui.addTextArea(idBato, "<p align='center'><font size='16'>Place le bateau</font>\n\n"..txt.."\n\n<a href='event:boatLeft'>←</a>\t\t\t\t<a href='event:boatRight'>→</a></p>", name, 207, 35, 163, nil, nil, nil, 0, true)
end

function checkPlace(name, x, y, id, numBato, dir)
	if (x-(numBato-1)<0 and dir=="left") or (x+(numBato-1)>9 and dir=="right") or (y-(numBato-1)<0 and dir=="haut") or (y+(numBato-1)>9 and dir=="bas") then
		return false;
	else
		local map = jeux[id]["carte"..name]
		for i=0,numBato-1 do
			if (dir=="left" and map[x-i][y]==0) or (dir=="right" and map[x+i][y]==0) or (dir=="haut" and map[x][y-i]==0) or (dir=="bas" and map[x][y+i]==0) then
			else
				return false;
			end
		end
		return true;
	end
end

function eventLoop(t1, t2)
	for k, v in ipairs(taskChange) do
		local tbl = taskChange[k]
		if tbl.time<=os.time() then
			battle(tbl.id, tbl.p1, tbl.p2, tbl.stade, tbl.num)
			players[tbl.name].click = true
			table.remove(taskChange, k)
		end
	end
end

main()