--[           Quizz Time           ]--
--[  Module created by Athesdrake  ]--
--[  Topic: https://goo.gl/UzCeQ1  ]--

-- Old module: the code is not perfect and not optimized.

separteur = ";" --Vous pouvez le remplacer par un autre caractère (spécial) si vous préférez, mais il ne dois pas se retrouver dans vos questions/réponses

function main()
	--vars:
		maitreDuJeu = "" -- Vous n'êtes pas obligés d'y mettre votre pseudo
		-- ^ Optionnal
--[			DO NOT MODIFY BELOW				]--
--[			NE MODIFIEZ PAS LA SUITE		]--
		game = nil
		gamedef = nil
		nbrPl = 0
	--ids:
		idType = 1
		idImport = 7
		--One
		idHaut = 2
		idModifRep = 3
		idModifQuest = 4
		idValidQuestRep = 5
		idMemo = 6
		--Four
		idPlus = 2
		idQuest = 3
		idRep = 4
		idValider = 5
		idPoints = 6
		idGA = 7
		idSettings = 8
		idDelete = 9
		idStart = 10
		idQuestionnaire = 11
		idChargement = 12
		idJoueurs = 13
	--tables:
		T = {
			one = {
				question = "",
				reponse = "",
				lastReponse = "",
				last = 0,
				players = {},
				egaux = {},
				gagnant = "",
				temps = 0,
				fin = false,
				questnum = 1,
				questTot = 0,
				validerQuest = false,
				validerRep = false,
				finale = false,
				points = 1,
				separator = (separateur or ";"),
				separation = ".-"..(separateur or ";")
			},
			four = {
				numRep = 1,
				goodAns = 1,
				points = 1,
				modif = false,
				numQuest = 1,
				start = false,
				realTime = false,
				repTemp = {},
				questions = {},
				player = {},
				scoreboard = {},
				scoreboardText = "",
				chosen = "</font><font face='Segoe MDL2 Assets' size='10' color='#565656'></font><font size='12' color='#565656'> ",
				noChosen = "</font><font face='Segoe MDL2 Assets' size='10' color='#565656'></font><font size='12' color='#565656'> ",
				separator = (separateur or ";"),
				separation = ".-"..(separateur or ";")
			}
		}
	--sytème:
		for k,v in pairs({"AutoNewGame", "AutoShaman", "AutoTimeLeft", "AfkDeath", "AutoScore", "MortCommand"})do
			tfm.exec["disable"..v](true)
		end
		table.foreach(tfm.get.room.playerList, function(v) eventNewPlayer(v) end)
		system.bindKeyboard(maitreDuJeu, 77, true, true)
end

function eventNewPlayer(name)
	ui.mapName()
	if gamedef and quizz.newPlayer then
		quizz.newPlayer(name)
	elseif maitreDuJeu=="" then
		system.bindKeyboard(name, 77, true, true)
	end
end

function eventPlayerLeft(name)
	ui.mapName()
	if gamedef and quizz.playerLeft then quizz.playerLeft(name) end
end

function eventPlayerDied(name) tfm.exec.respawnPlayer(name) end

function eventKeyboard(name, key)
	if key==77 then
		if maitreDuJeu=="" then
			table.foreach(tfm.get.room.playerList, function(v) system.bindKeyboard(v, 77, true, false) end)
			maitreDuJeu = name
			ui.popup(idType, "1 Question → 1 Réponse\t", "1 Question → 4 Réponses", "Quel mode de jeu choisis-tu ?", maitreDuJeu)
		else
			if game then
				gamedef = game
				play()
				for i=idType*100, idType*100+12 do ui.removeTextArea(i, name) end;ui.removeTextArea(idType, name)
			else
				main()
				table.foreach(tfm.get.room.playerList, function(v) system.bindKeyboard(v, 77, true, false) end)
				maitreDuJeu = name
				ui.popup(idType, "1 Question → 1 Réponse\t", "1 Question → 4 Réponses", "Quel mode de jeu choisis-tu ?", maitreDuJeu)
				maitreDuJeu = name
			end
		end
	end
end

function eventLoop() if gamedef and quizz.loop then quizz.loop() end end

function eventPopupAnswer(id, name, ans) if gamedef and quizz.popupAns then quizz.popupAns(id, name, ans) end end

function eventNewGame() ui.mapName();if gamedef and quizz.newGame then quizz.newGame() end end

function eventTextAreaCallback(id, name, call)
	if gamedef and quizz.callback then quizz.callback(id, name, call)
	elseif id==idType*100+8 or id==idType*100+11 then
		local arg, txt = {}, ""
		for word in call:gmatch(".-;") do
			table.insert(arg, word:sub(0, #word-1))
		end
		game = arg[1]
		ui.popup(tonumber(arg[2]), arg[3], arg[4], arg[5], name, arg[1]=="one", arg[1]=="four")
		system.bindKeyboard(name, 77, true, true)
	end
end

function eventChatCommand(name,cmd) if gamedef and quizz.command then quizz.command(name, cmd) end end

ui.popup = function(id, choice1, choice2, txt, name, bouton1, bouton2)
	local hauteur, largeur = 150, 250
	local x, y = (800-largeur)/2, (400-hauteur)/2
	local txt, ch1, ch2 = "<p align='center'>\n<font size='20'>"..txt, "<p align='center'><a href='event:one;"..id..";"..choice1..";"..choice2..";"..txt..";'>"..(choice1), "<p align='center'><a href='event:four;"..id..";"..choice1..";"..choice2..";"..txt..";'>"..choice2
	ui.addTextArea(id*100+0 ," ", name, x-8             , y-8         , largeur+16  , hauteur+16, 0x2D211A, 0x2D211A, 0.8, true)
	ui.addTextArea(id*100+1 ," ", name, x-7             , y-7         , largeur+14  , hauteur+14, 0x986742, 0x986742, 1  , true)
	ui.addTextArea(id*100+2 ," ", name, x-4             , y-4         , largeur+8   , hauteur+8 , 0x171311, 0x171311, 1  , true)
	ui.addTextArea(id*100+3 ," ", name, x-3             , y-3         , largeur+6   , hauteur+6 , 0x0C191C, 0x0C191C, 1  , true)
	ui.addTextArea(id*100+4 ," ", name, x-2             , y-2         , largeur+4   , hauteur+4 , 0x24474D, 0x24474D, 1  , true)
	ui.addTextArea(id*100+5 ," ", name, x-1             , y-1         , largeur+2   , hauteur+2 , 0x183337, 0x183337, 1  , true)
	ui.addTextArea(id       ,txt, name, x               , y           , largeur     , hauteur   , 0x122528, 0x122528, 1  , true)

	if bouton1 and bouton2 then
		error("<R>You can't push the two bouton in the same time</R>")
	elseif bouton1 or bouton2 then
		ui.addTextArea(id*100+12, "<p align='center'>Appuies sur 'M' pour confirmer", name, x, y-4, largeur, nil, 0x1, 0x1, 0, true)
	end
	ui.addTextArea(id*100+6 ," ", name, x+largeur*3/20-1+tonumber(bouton1 and 2 or "0"), y*2-y*0.36-1+tonumber(bouton1 and 2 or "0"), largeur*7/10, 22        , 0x5D7D90, 0x5D7D90, 1  , true)
	ui.addTextArea(id*100+7 ," ", name, x+largeur*3/20+1-tonumber(bouton1 and 2 or "0"), y*2-y*0.36+1-tonumber(bouton1 and 2 or "0"), largeur*7/10, 22        , 0x11171C, 0x11171C, 1  , true)
	ui.addTextArea(id*100+8 ,ch1, name, x+largeur*3/20  , y*2-y*0.36  , largeur*7/10, 22        , 0x324650, 0x324650, 1  , true)

	ui.addTextArea(id*100+9 ," ", name, x+largeur*3/20-1+tonumber(bouton2 and 2 or "0"), y*2-y*0.04-1+tonumber(bouton2 and 2 or "0"), largeur*7/10, 22        , 0x5D7D90, 0x5D7D90, 1  , true)
	ui.addTextArea(id*100+10," ", name, x+largeur*3/20+1-tonumber(bouton2 and 2 or "0"), y*2-y*0.04+1-tonumber(bouton2 and 2 or "0"), largeur*7/10, 22        , 0x11171C, 0x11171C, 1  , true)
	ui.addTextArea(id*100+11,ch2, name, x+largeur*3/20  , y*2-y*0.04  , largeur*7/10, 22        , 0x324650, 0x324650, 1  , true)
end

ui.mapName = function()
	nbrPl = 0;table.foreach(tfm.get.room.playerList, function() nbrPl=nbrPl+1 end);ui.setMapName(string.format("<VP>Quizz Time<BL> | <N>Souris: <V>%d<BL> | <N>Maître du jeu: <V>%s<BL> | <N>Créateur: <BV>Athesdrake\n", nbrPl, (maitreDuJeu=="" and "/"or maitreDuJeu)))
end

function play()
	if (not game) then print("<R>WARNING</R>: le type de jeu n'est pas défini !");return end
	quizz = jeu[game]()
	quizz.__init__(true)
end

jeu = {
	one = function()
		local self, var = {}, T.one

		self.__init__ = function(bool)
			ui.addPopup(1, 2, "Met le nombre de questions à poser.", maitreDuJeu, 150, 150, nil, true)
			T.one.players = {}
		end
		self.setup = function()
			table.foreach(tfm.get.room.playerList, function(v) eventNewPlayer(v) end)
			tfm.exec.newGame("@4474417")
			self.ask()
		end
		self.ask = function()
			T.one.points = 1
			ui.addTextArea(idHaut, "<p align='center'>Met la question et la réponse pour la question n°"..tostring(var.questnum).."\nPoints pour la question: <a href='event:modifPoint1'><font color='#00FF00'>1</font></a> <a href='event:modifPoint2'><font color='#FF0000'>2</font></a> <a href='event:modifPoint3'><font color='#FF0000'>3</font></a></p>", maitreDuJeu, 10, 30, 770, 50, 0x1, 0x1, 0)
			ui.addTextArea(idModifRep, "<a href='event:reponse'><font color='#FF0000'>Modifier la réponse</font></a>", maitreDuJeu, 430, 75, nil, nil, 0x1, 0x1, 0)
			ui.addTextArea(idModifQuest, "<a href='event:question'><font color='#FF0000'>Modifier la question</font></a>", maitreDuJeu, 250, 75, nil, nil, 0x1, 0x1, 0)
			ui.addTextArea(idValidQuestRep, "<font color='#FF0000'>Valider</font>", maitreDuJeu, 375, 75, nil, nil, 0x1, 0x1, 0)
			ui.addTextArea(idImport, "<a href='event:import'>Importer</a>", maitreDuJeu, 737, 26, nil, nil, 0x4A4B4C, 0x1)
		end
		self.gg = function()
			T.one.last = 0
			T.one.egaux = {}
			T.one.gagnant = ""
			T.one.temps = os.time()+10000
			T.one.fin = true
		end
		self.goodAns = function(ans)
			if string.lower(ans):gsub("%é", "e"):gsub("%è", "e")==string.lower(T.one.reponsedef):gsub("%é", "e"):gsub("%è", "e") then
				return true;
			else
				return false;
			end
		end
		self.newPlayer = function(name)
			ui.mapName()
			tfm.exec.setPlayerScore(name, 0)
			tfm.exec.respawnPlayer(name)
			table.insert(T.one.players, name)
		end
		self.popupAns = function(id, name, answer)
			if id==1 then
				if answer~="" then
					if tonumber(answer:match("%d+"))~=0 then
						T.one.questTot = tonumber(answer:match("%d+"))
						self.setup()
						return
					end
				end
				ui.addPopup(1, 2, "Met le nombre de questions à poser.", maitreDuJeu, 150, 150, nil, true)
			end
			if id==idQuest then
				T.one.question = answer
				ui.addTextArea(idModifQuest, "<a href='event:question'><font color='#18CD30'>Modifier la question</font></a>", maitreDuJeu, 250, 75, nil, nil, 0x4A4B4C)
				T.one.validerQuest = true
				if T.one.validerRep then
					ui.addTextArea(idValidQuestRep, "<a href='event:valider'><font color='#18CD30'>Valider</font></a>", maitreDuJeu, 375, 75.5, nil, nil, 0x4A4B4C)
				end
			end
			if id==idRep then
				T.one.reponse = answer
				ui.addTextArea(idModifRep, "<a href='event:reponse'><font color='#18CD30'>Modifier la réponse</font></a>", maitreDuJeu, 431, 75, nil, nil, 0x4A4B4C)
				T.one.validerRep = true
				if T.one.validerQuest then
					ui.addTextArea(idValidQuestRep, "<a href='event:valider'><font color='#18CD30'>Valider</font></a>", maitreDuJeu, 375, 75.5, nil, nil, 0x4A4B4C)
				end
			end
			if id==idHaut then
				if self.goodAns(answer) then
					tfm.exec.setPlayerScore(name, tfm.get.room.playerList[name].score+T.one.points)
					T.one.lastReponse = var.reponsedef
					tfm.exec.displayParticle(15, tfm.get.room.playerList[name].x+5, tfm.get.room.playerList[name].y, 0, -1, 0, 0)
					T.one.reponsedef = 1
					T.one.pop = false
					T.one.validerQuest = false
					T.one.validerRep = false
					ui.addTextArea(idHaut, "<p align='center'><font color='#BABD2F'>"..name.." a trouvé la réponse ! <br>Il(Elle) a gagné "..T.one.points.." point"..(T.one.points==1 and "" or "s").." !</font>\nLa réponse était: "..T.one.lastReponse..".</p>", all, 10, 30, 770,50, 0x1, nil, 0)
					ui.removeTextArea(idMemo, maitreDuJeu)
					if tonumber(T.one.questTot)==tonumber(T.one.questnum) then
						self.gg()
					else
						T.one.questnum = T.one.questnum+1
						self.ask()
					end
				elseif T.one.pop then
					ui.addPopup(idHaut, 2, "<p align='center'><font color='#FF0000'>\[Question "..tostring(T.one.questnum).."/"..tostring(T.one.questTot).."\]</font><br><font color='#009D9D'>"..T.one.question.."</font><br><font color='#BABD2F'>Si tu trouve la réponse, tu gagneras "..tostring(T.one.points).." point ! </font></p>", name, 306, 100)
				end
			end
			if id==idImport then
				local tbl = {}
				for arg in answer:gmatch(var.separation) do
					table.insert(tbl, arg:sub(0, #arg-1))
				end
				if tbl[1] then
					self.popupAns(idQuest, name, tbl[1])
				end
				if tbl[2] then
					self.popupAns(idRep, name, tbl[2])
				end
				badPrint(tbl[3])
				if tbl[3] and (tonumber(tbl[3])==1 or tonumber(tbl[3])==2 or tonumber(tbl[3])==3) then
					self.callback(id, name, "modifPoint"..tbl[3])
				end
			end
		end
		self.callback = function(id, name, call)
			if call=="question" then
				ui.addPopup(idQuest, 2, "Entre la question.", maitreDuJeu, 307, 100, 200)
			end
			if call=="reponse" then
				ui.addPopup(idRep, 2, "Entre la réponse.", maitreDuJeu, 307, 100, 200)
			end
			if call=="valider" then
				for _,v in pairs({idHaut, idModifQuest, idModifRep, idValidQuestRep}) do
					ui.removeTextArea(v, maitreDuJeu)
				end
				if T.one.finale then
					for k,v in pairs(T.one.egaux) do
						ui.addPopup(idHaut, 2, "<p align='center'><font color='#FF0000'>\[Question "..tostring(T.one.questnum).."/"..tostring(T.one.questTot).."\]</font><br><font color='#009D9D'>"..T.one.question.."</font><br><font color='#BABD2F'>Si tu trouve la réponse, tu gagneras "..tostring(T.one.points).." point ! </font></p>", v, 306, 100)
					end
				else
					ui.addPopup(idHaut,2, "<p align='center'><font color='#FF0000'>\[Question "..tostring(T.one.questnum).."/"..tostring(T.one.questTot).."\]</font><br><font color='#009D9D'>"..T.one.question.."</font><br><font color='#BABD2F'>Si tu trouve la réponse, tu gagneras "..tostring(T.one.points).." point ! </font></p>", all, 306, 100)
					T.one.reponsedef = T.one.reponse
					T.one.pop = true
					print(table.concat({var.question, var.reponse, var.points}, ";")..";")
					ui.addTextArea(idMemo, "La réponse est: "..T.one.reponsedef, maitreDuJeu, 60, 375, nil, nil, 0x4A4B4C)
				end
			end
			if call:sub(0,10)=="modifPoint" then
				local n, red, green = tonumber(call:sub(11)), "FF0000", "00FF00"
				T.one.points = n
				ui.updateTextArea(idHaut, "<p align='center'>Met la question et la réponse pour la question n°"..tostring(T.one.questnum).."\nPoints pour la question: <a href='event:modifPoint1'><font color='#"..(n==1 and green or red).."'>1</font></a> <a href='event:modifPoint2'><font color='#"..(n==2 and green or red).."'>2</font></a> <a href='event:modifPoint3'><font color='#"..(n==3 and green or red).."'>3</font></a></p>", maitreDuJeu)
			end
			if call=="import" then
				ui.addPopup(idImport, 2, "Syntaxe: Question"..var.separator.."Réponse"..var.separator.."Points"..var.separator)
			end
		end
		self.loop = function()
			if T.one.fin then
				if T.one.temps<=os.time() then
					for pl in pairs(tfm.get.room.playerList) do
						if tfm.get.room.playerList[pl].score>T.one.last then
							T.one.last = tfm.get.room.playerList[pl].score
							T.one.gagnant = pl
							T.one.egaux = {pl}
						elseif tfm.get.room.playerList[pl].score==T.one.last then
							table.insert(T.one.egaux, pl)
						end
					end
					if #T.one.egaux>1 then
						T.one.questnum = "LAST"
						T.one.questTot = "LAST"
						ui.addTextArea(idHaut, "<a>Le quizz n'est pas terminé, plusieurs candidats ont le même score!\nUne dernière question va les départagés!", all, 10, 30, 770, 50, 0x1, 0x1, 0)
						T.one.finale = true
						self.ask()
					else
						T.one.fin = false
						ui.addTextArea(idHaut, "<p align='center'>Le quizz est fini!\n Le gagnant (ou la gagnante) est ...\n<font color='#FF0000'>"..T.one.gagnant.."</font> !</p>", all, 10, 30, 770, 50, 0x1, 0x1, 0)
					end
				end
			end
		end
		self.newGame = function() if tfm.get.room.xmlMapInfo.mapCode==4474417 then tfm.exec.movePlayer(maitreDuJeu, 410, 255) end end

		return {
			newPlayer = self.newPlayer,
			popupAns = self.popupAns,
			callback = self.callback,
			loop = self.loop,
			newGame = self.newGame,
			__init__ = self.__init__
		}
	end,

	four = function()
		self, var = {}, T.four
		self.__init__ = function(bool)
			if bool then
				table.foreach(tfm.get.room.playerList, function(v) eventNewPlayer(v) end)
			end
			--variables
			var.numRep = 1
			var.goodAns = 1
			var.points = 1
			var.modif = false
			var.questTemp = nil
			--tables
			var.repTemp = {}
			--ajouter une question
			ui.addTextArea(idPlus*100, "", maitreDuJeu, 700, 28, 96, 33, 0x53453d, 0x53453d, 1, true)
			ui.addTextArea(idPlus*100+1, "", maitreDuJeu, 704, 32, 88, 25, 0xf2e5c5, 0xcab47b, 1, true)
			ui.addTextArea(idPlus, "<a href='event:start'><font size='24' color='#848484'></a><a href='event:import'></a></font><a href='event:add'><font size='25' color='#848484'><b>+</b></font></a><a href='event:settings'><font size='25' color='#848484'></font></a>", maitreDuJeu, 700, 27, nil, nil, nil, nil, 0, true)
		end
		self.questRep = function(name, nbr)
			if var.player[name].joue then
				var.player[name].text = ""
				local text = "<p align='center'><font size='25' color='#565656'><i><u>Question "..nbr.."</u></i></font></p>\n\n\t<font size='12' color='#565656'>"..var.questions[nbr].quest.."\n\n<a href='event:rep1'>"..var.noChosen.."Réponse 1: "..var.questions[nbr].ans1.."</a>\n<a href='event:rep2'>"..var.noChosen.."Réponse 2: "..var.questions[nbr].ans2.."</a>\n<a href='event:rep3'>"..var.noChosen.."Réponse 3: "..var.questions[nbr].ans3.."</a>\n<a href='event:rep4'>"..var.noChosen.."Réponse 4: "..var.questions[nbr].ans4.."</a>\n\n<p align='center'><a href='event:valider'>Valider</a></p>"
				ui.addTextArea(idQuestionnaire*100, "", name, 144, 44, 512, 312, 0xf2e5c5, 0x53453d, 0.8, true)
				ui.addTextArea(idQuestionnaire*100+1, "", name, 146, 46, 508, 308, 0x53453d, 0x53453d, 1, true)
				ui.addTextArea(idQuestionnaire*100+2, "", name, 148, 48, 504, 304, 0x53453D, 0x53453D, 1, true)
				ui.addTextArea(idQuestionnaire, text, name, 150, 50, 500, 300, 0xf2e5c5, 0xcab47b, 1, true)
				ui.addTextArea(idChargement, "<font size='8'></font>", name, 149, 340, nil, 300, nil, nil, 0, true)
			end
		end
		self.testForEnd = function()
			if var.start then
				local nbr, i = 0, 0
				for pl,_ in pairs(var.player)do
					nbr = nbr + 1
					if var.player[pl].finish or var.player[pl].joue==false then
						i = i +1
					end
				end
				if i==nbr then
					for i=1, nbr do
						local last, temp = -1, {}
						for k,v in pairs(var.player) do
							if var.player[k].joue then
								if var.player[k].points>last and var.player[k].test then
									T.four.scoreboard[i] = {name = k, points = var.player[k].points}; last = var.player[k].points
								end
							end
						end
						T.four.player[var.scoreboard[i].name].test = false
					end
					local text = "<p align='center'><font size='25' color='#565656'><u><b>Scoreboard</b></u></font></p>\n<font color='#565656' size='12'>"
					for k, v in pairs(var.scoreboard) do
						local espace = ""
						for i=1,20-#var.scoreboard[k].name do
							espace = espace.." "
						end
						text = text..k..". "..var.scoreboard[k].name..espace..var.scoreboard[k].points.." points\n"
					end
					var.scoreboardText = text
					ui.addTextArea(idQuestionnaire*100, "", nil, 144, 44, 512, 312, 0xf2e5c5, 0x53453d, 0.8, true)
					ui.addTextArea(idQuestionnaire*100+1, "", nil, 146, 46, 508, 308, 0x53453d, 0x53453d, 1, true)
					ui.addTextArea(idQuestionnaire*100+2, "", nil, 148, 48, 504, 304, 0x53453D, 0x53453D, 1, true)
					ui.addTextArea(idQuestionnaire, text, nil, 150, 50, 500, 300, 0xf2e5c5, 0xcab47b, 1, true)
					ui.addTextArea(idQuestionnaire*100+3, "<font size='25' color='#FF0000'><a href='event:fermer'><b>x</b></a></font>", nil, 630, 37, nil, nil, 0x0, 0x0, 0, true)
					var.start = false
				end
			end
		end
		self.loop = function()
			if var.start then
				for k, v in pairs(var.player) do
					local txt = var.player[k].text
					if (not var.player[k].finish) and var.player[k].joue then
						if  #txt<100 then
							local teinte = var.player[k].rgb + 10.24
							local rouge = 0
							local vert = 0
							local couleur = 0
							txt = txt.."__"
							var.player[k].text = txt
							var.player[k].rgb = teinte
							if #txt<=50 then
								rouge = string.format("%i", teinte)
								vert = 255
							else
								rouge = 255
								vert = string.format("%i", 1024 - teinte)
							end
							couleur = string.format("%X", rouge)..(#tostring(string.format("%X", vert))==1 and ("0"..string.format("%X", vert)) or string.format("%X", vert)).."00"
							var.player[k].couleur = couleur
							ui.addTextArea(idChargement*100, "", k, 149, 345, 502, 5, 0x53453d, 0x53453d, 1, true)
							ui.addTextArea(idChargement, "<font size='8' color='#"..couleur.."'>"..txt.."</font>", k, 145, 340, nil, nil, nil, nil, 0, true)
						elseif #txt==100 then
							if var.player[k].repChoose==0 then
								var.player[k].repChoose = 5
							end
							eventTextAreaCallback(idQuestionnaire, k, "valider")
						end
					end
				end
			end
		end
		self.callback = function(id, name, call)
			if id==idPlus then
				if call=="add" then
					ui.addTextArea(idPlus, "<font size='25' color='#FF0000'><a><b>+</b></a></font><a href='event:settings'><font size='25' color='#848484'></font></a>", maitreDuJeu, 737, 27, nil, nil, nil, nil, 0, true)
					--ui.addPopup(idQuest, 2, "Question"..var.numQuest..":", maitreDuJeu, nil, nil, nil, true)
					ui.addTextArea(idQuest*100, "", maitreDuJeu, 144, 44, 512, 312, 0xf2e5c5, 0x53453d, 0.8, true)
					ui.addTextArea(idQuest*100+1, "", maitreDuJeu, 146, 46, 508, 308, 0x53453d, 0x53453d, 1, true)
					ui.addTextArea(idQuest*100+2, "", maitreDuJeu, 148, 48, 504, 304, 0x53453D, 0x53453D, 1, true)
					local bool = (var.questTemp and var.repTemp[1] and var.repTemp[2] and var.repTemp[3] and var.repTemp[4])
					ui.addTextArea(idQuest, "<p align='center'><font size='25' color='#565656'><i><u>Question "..var.numQuest.."</u></i></font></p>\n<a href='event:modifQuest'>"..(var.questTemp and var.questTemp or "Modifier la question").."</a>\n\n\n\t\t\t<font size='12' color='#565656'><a href='event:modifPoints'>Nombre de points :"..var.points.."</a>\n\n\n<a href='event:modifGA1'>"..(var.goodAns==1 and var.chosen or var.noChosen).." Réponse 1:</a><a href='event:modifRep1'> "..(var.repTemp[1] and var.repTemp[1] or "Modifier la réponse").."</a>\n\n<a href='event:modifGA2'>"..(var.goodAns==2 and var.chosen or var.noChosen).." Réponse 2:</a><a href='event:modifRep2'> "..(var.repTemp[2] and var.repTemp[2] or "Modifier la réponse").."</a>\n\n<a href='event:modifGA3'>"..(var.goodAns==3 and var.chosen or var.noChosen).." Réponse 3:</a><a href='event:rep3'> "..(var.repTemp[3] and var.repTemp[3] or "Modifier la réponse").."</a>\n\n<a href='event:modifGA4'>"..(var.goodAns==4 and var.chosen or var.noChosen).." Réponse 4: </a><a href='event:modifRep4'>"..(var.repTemp[4] and var.repTemp[4] or "Modifier la réponse").."</a>\n\n<p align='center'>"..(bool and "<a href='event:valider'>Valider</a>" or "").."</p>", maitreDuJeu, 150, 50, 500, 300, 0xf2e5c5, 0xcab47b, 1, true)
				elseif call=="start" then
					self.command(maitreDuJeu, call)
				elseif call=="settings" then
					ui.addTextArea(idSettings, "Affichage des points en temps réel: <font color='#FF0000'><a href='event:realTime'>non</a></font><br><a href='event:joueurs'>Modifier les personnes qui peuvent jouer</a></font><br><br><br><p align='center'><a href='event:valider'>Valider</a></p>", maitreDuJeu, 532, 73, 263, 74, 0x324650, 0x0, 1, true)
				elseif call=="import" then
					ui.addPopup(idImport, 2, "Syntaxe: Question"..var.separator.."Réponse1"..var.separator.."Réponse2"..var.separator.."Réponse3"..var.separator.."Réponse4"..var.separator.."Bonne réponse"..var.separator.."Points"..var.separator.."\n<R>254 caractères max", maitreDuJeu, 100, 100, 400)
				end
			end
			if id==idSettings then
				if call=="realTime" then
					var.realTime = (not var.realTime)
					ui.addTextArea(idSettings, "Affichage des points en temps réel: <font color='#"..(var.realTime and "00FF00" or "FF0000").."'><a href='event:realTime'>"..(var.realTime and "oui" or "non").."</a></font><br><a href='event:joueurs'>Modifier les personnes qui peuvent jouer</a></font><br><br><br><p align='center'><a href='event:valider'>Valider</a></p>", maitreDuJeu, 532, 73, 263, 82, nil, nil, 1, true)
				end
			end
			if call:sub(0,7)=="joueurs" then
				if call:sub(8)~="" then
					var.player[call:sub(8)].joue = (not var.player[call:sub(8)].joue)
				end
				local txt = ""
				for pl in pairs(tfm.get.room.playerList) do
					txt = txt.."<a href='event:joueurs"..pl.."'><font color='#"..(var.player[pl].joue and "00FF00" or "FF0000").."'>"..pl.."</font></a>\n"
				end
				txt = txt.."\n<p align='center'><a href='event:valider'>Valider</a></p>"
				ui.addTextArea(idJoueurs, txt, maitreDuJeu, 532, 160, nil, nil, nil, nil, 1, true)
			end
			if call:sub(0,5)=="modif" then
				if call:sub(6)=="Quest" then
					self.popupAns(idQuest, maitreDuJeu, "")
				elseif call:sub(6,8)=="Rep" then
					var.numRep = tonumber(call:sub(9))
					self.popupAns(idRep, maitreDuJeu, "")
				elseif call:sub(6,7)=="GA" then
					var.goodAns = tonumber(call:sub(8))
					self.callback(idPlus, maitreDuJeu, "add")
				elseif call:sub(6,11)=="Points" then
					if call:sub(12)=="" then
						ui.addTextArea(idPoints, "<a href='event:modifPoints1'>1</a>\n<a href='event:modifPoints2'>2</a>\n<a href='event:modifPoints3'>3</a>", maitreDuJeu, nil, 200, nil, nil, nil, nil, 1, true)
					else
						ui.removeTextArea(idPoints, maitreDuJeu)
						var.points = tonumber(call:sub(12))
						self.callback(idPlus, maitreDuJeu, "add")
					end
				end
			end
			if call=="valider" then
				if id==idQuest then
					var.questions[var.numQuest] = {quest = var.questTemp, ans1 = var.repTemp[1], ans2 = var.repTemp[2], ans3 = var.repTemp[3], ans4 = var.repTemp[4], gA = var.goodAns, points = var.points}
					print(table.concat({var.questTemp, var.repTemp[1], var.repTemp[2], var.repTemp[3], var.repTemp[4], var.goodAns, var.points}, ";")..";")
					var.numQuest = var.numQuest + 1
					for _,v in pairs({idQuest, idQuest*100, idQuest*100+1, idQuest*100+2}) do
						ui.removeTextArea(v, maitreDuJeu)
					end
					self.__init__()
				elseif id==idSettings or id==idJoueurs then
					ui.removeTextArea(id, maitreDuJeu)
				elseif id==idQuestionnaire then
					local nbr = var.player[name].repChoose
					if nbr~=0 then
						if nbr==var.questions[var.player[name].num].gA then
							if var.realTime then
								tfm.exec.setPlayerScore(name, var.questions[var.player[name].num].points + var.player[name].points)
							end
							var.player[name].points = var.questions[var.player[name].num].points + var.player[name].points
						end
						if var.player[name].num==#var.questions then
							ui.removeTextArea(idQuestionnaire, name)
							ui.removeTextArea(idQuestionnaire*100, name)
							ui.removeTextArea(idQuestionnaire*100+1, name)
							ui.removeTextArea(idQuestionnaire*100+2, name)
							ui.removeTextArea(idChargement, name)
							ui.removeTextArea(idChargement*100, name)
							var.player[name].finish = true
							self.testForEnd()
						else
							var.player[name].num = var.player[name].num + 1
							self.questRep(name, var.player[name].num)
						end
					end
				end
			end
			if call=="delete" then
				ui.addPopup(idDelete, 1, "Supprimer définitivement cette question?", maitreDuJeu, nil, nil, nil, true)
			end
			if call:sub(0,3)=="rep" then
				local nbr = tonumber(call:sub(4))
				var.player[name].repChoose = nbr
				local text = "<p align='center'><font size='25' color='#565656'><i><u>Question "..var.player[name].num.."</u></i></font></p>\n\n\t<font size='12' color='#565656'>"..var.questions[var.player[name].num].quest.."\n\n<a href='event:rep1'>"..(nbr==1 and var.chosen or var.noChosen).."Réponse 1: "..var.questions[var.player[name].num].ans1.."</a>\n<a href='event:rep2'>"..(nbr==2 and var.chosen or var.noChosen).."Réponse 2: "..var.questions[var.player[name].num].ans2.."</a>\n<a href='event:rep3'>"..(nbr==3 and var.chosen or var.noChosen).."Réponse 3: "..var.questions[var.player[name].num].ans3.."</a>\n<a href='event:rep4'>"..(nbr==4 and var.chosen or var.noChosen).."Réponse 4: "..var.questions[var.player[name].num].ans4.."</a>\n\n<p align='center'><a href='event:valider'>Valider</a></p>"
				ui.addTextArea(idQuestionnaire, text, name, 150, 50, 500, 300, 0xf2e5c5, 0xcab47b, 1, true)
				ui.addTextArea(idChargement*100, "", name, 149, 345, 502, 5, 0x53453d, 0x53453d, 1, true)
				ui.addTextArea(idChargement, "<font size='8' color='#"..var.player[name].couleur.."'>"..var.player[name].text.."</font>", name, 145, 340, nil, nil, nil, nil, 0, true)
			end
			if call=="fermer" then
				ui.removeTextArea(idQuestionnaire, name)
				ui.removeTextArea(idQuestionnaire*100, name)
				ui.removeTextArea(idQuestionnaire*100+1, name)
				ui.removeTextArea(idQuestionnaire*100+2, name)
				ui.removeTextArea(idQuestionnaire*100+3, name)
				ui.addTextArea(idPlus*100, "", name, 737, 28, 56, 33, 0x53453d, 0x53453d, 1, true)
				ui.addTextArea(idPlus*100+1, "", name, 741, 32, 48, 25, 0xf2e5c5, 0xcab47b, 1, true)
				ui.addTextArea(idPlus, "<a href='event:scoreboard'><font size='18' color='#848484'>Score</font></a>", name, 737, 27, nil, nil, nil, nil, 0, true)
			end
			if call=="scoreboard" then
				ui.removeTextArea(idPlus, name)
				ui.removeTextArea(idPlus*100, name)
				ui.removeTextArea(idPlus*100+1, name)
				ui.addTextArea(idQuestionnaire*100, "", name, 144, 44, 512, 312, 0xf2e5c5, 0x53453d, 0.8, true)
				ui.addTextArea(idQuestionnaire*100+1, "", name, 146, 46, 508, 308, 0x53453d, 0x53453d, 1, true)
				ui.addTextArea(idQuestionnaire*100+2, "", name, 148, 48, 504, 304, 0x53453D, 0x53453D, 1, true)
				ui.addTextArea(idQuestionnaire, var.scoreboardText, name, 150, 50, 500, 300, 0xf2e5c5, 0xcab47b, 1, true)
				ui.addTextArea(idQuestionnaire*100+3, "<font size='25' color='#FF0000'><a href='event:fermer'><b>x</b></a></font>", name, 630, 37, nil, nil, 0x0, 0x0, 0, true)
			end
		end
		self.popupAns = function(id, name, answer, bool)
			if id==idQuest then
				if answer=="" then
					ui.addPopup(idQuest, 2, "Question"..var.numQuest..":", maitreDuJeu, nil, nil, nil, true)
				else
					var.questTemp = answer
					if var.modif then
						eventPopupAnswer(idRep, maitreDuJeu, var.repTemp[var.numRep])
					elseif (not bool) then
						ui.addPopup(idRep, 2, "Réponse 1:", maitreDuJeu, nil, nil, nil, true)
					end
				end
			end
			if id==idRep then
				if answer=="" then
					ui.addPopup(idRep, 2, "Réponse "..var.numRep..":", maitreDuJeu, nil, nil, nil, true)
				else
					var.repTemp[var.numRep] = answer
					if var.numRep==4  or var.modif then
						var.modif = true--ui.addTextArea(idValider, "Question "..var.numQuest..": <a href='event:modifQuest'>"..var.questTemp.."</a>\nRéponse 1: <a href='event:modifRep1'>"..var.repTemp[1].."</a>\nRéponse 2: <a href='event:modifRep2'>"..var.repTemp[2].."</a>\nRéponse 3: <a href='event:modifRep3'>"..var.repTemp[3].."</a>\nRéponse 4: <a href='event:modifRep4'>"..var.repTemp[4].."</a>\nRéponse correcte: <a href='event:modifGA'>"..var.goodAns.."</a>\nNombre de points: <a href='event:modifPoints'>"..var.points.."</a>\n<p align='center'><a href='event:delete'>Supprimer la question</a>\t<a href='event:valider'>Valider</a></p>", maitreDuJeu, nil, nil, nil, nil, nil, nil, 1, true)
						self.callback(idPlus, maitreDuJeu, "add")
					else
						var.numRep = var.numRep + 1
						if (not bool) then
							ui.addPopup(idRep, 2, "Réponse "..var.numRep..":", maitreDuJeu, nil, nil, nil, true)
						end
					end
				end
			end
			if id==idDelete and answer then
				ui.removeTextArea(idValider, maitreDuJeu)
				self.__init__()
			end
			if id==idStart and answer=="yes" then
				var.start = true
				for pl in pairs(tfm.get.room.playerList) do
					self.questRep(pl, 1)
				end
			end
			if id==idImport then
				local tbl = {}
				var.numRep = 1
				for arg in answer:gmatch(var.separation) do
					table.insert(tbl, arg:sub(0, #arg-1))
				end
				if tbl[1] then self.popupAns(idQuest, name, tbl[1], true) end
				if tbl[2] then self.popupAns(idRep, name, tbl[2], true) end
				if tbl[3] then self.popupAns(idRep, name, tbl[3], true) end
				if tbl[4] then self.popupAns(idRep, name, tbl[4], true) end
				if tbl[5] then self.popupAns(idRep, name, tbl[5], true) end
				if tbl[6] and (tbl[6]=="1" or tbl[6]=="2" or tbl[6]=="3" or tbl[6]=="4") then self.callback(id, name, "modifGA"..tbl[6]) end
				if tbl[7] and (tbl[7]=="1" or tbl[7]=="2" or tbl[7]=="3") then self.callback(id, name, "modifPoints"..tbl[7]) end
			end
		end
		self.command = function(name, cmd)
			if name==maitreDuJeu then
				if cmd=="start" then ui.addPopup(idStart, 1, "<p align='center'>Commencer ?</p>", maitreDuJeu, 300, 167.5, 200, true) end
			end
		end
		self.newPlayer = function(name)
			T.four.player[name] = {temps = os.time(), num = 1, points = 0, repChoose = 0, finish = false, test = true, text = "", rgb = 0, couleur = "00FF00", joue = true}
			if name==maitreDuJeu then self.__init__() end
			if var.start then self.questRep(name, 1) end
		end
		self.playerLeft = function(name)
			if var.start then
				var.player[name].joue = false
				self.testForEnd()
			end
		end

		return {
			newPlayer = self.newPlayer,
			popupAns = self.popupAns,
			callback = self.callback,
			loop = self.loop,
			playerLeft = self.playerLeft,
			command = self.command,
			__init__ = self.__init__
		}
	end
}

badPrint = print;print = function( ... ) badPrint(table.concat({...}, ",")) end

main()