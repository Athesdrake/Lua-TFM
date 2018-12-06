--[[                       Meepvivor                       ]]--
--[[ Module created by Athesdrake originally by Fireicefly ]]--
---------------------------------------------------------------
--[[            MapCrews: Viaxeiro                         ]]--
--[[            Owners: Athesdrake & Viaxeiro              ]]--
--[[            Topic: None                                ]]--
---------------------------------------------------------------

function main()
	--vars:
		version    = "1.2.0 b12"
		currentMap = "0"
		podium     = 0
		fireworks  = false
		format     = string.format
		mapName    = "<BV>Meepvivor <G>  | <J> %s <BL> - @%d<G>  |  <N>%s : <V>%s<G>  |  <N>%s : <V>%d<G>  |  <N>%s : <V>%d/10\n"
		--                            MapAuthor ↑, MapCode ↑,  timeLeft ↑,     ↑ timeFormat, ↑ mice, ↑ miceN,    ↑ podium,↑ podiumN
		comRoom    = "fr"
		C = "center"
		R = "right"
		L = "left"
	--ids:
		idMeep        = 1
		idProfile     = 2
		idProfileName = 3
		idLoadBack    = 4
		idLoadFore    = 5
		idWon         = 6
		idExpBg       = 7
		idExpBgBorder = 8
		idExpFg       = 9
		idExpTxt      = 10
		idHelp        = 11
		idHelpClose   = 12
		idHelpPrev    = 13
		idHelpNext    = 14
		idLeaderboard = 15
		idOffChange   = 16
		idMenuH       = 17
		idMenuL       = 18
		idMenuP       = 19
		idLang        = 20
	--tables:
		players  = {}
		teams    = {}
		bans     = {}
		coders   = {['Athesdrake#0000']=1, ['Fireicefly#0000']=2}
		admins   = {['Athesdrake#0000']=1, ['Viaxeiro#0000']=1}
		mapCrews = {['Viaxeiro#0000']=1}
		mods     = {}
		aft      = {}
		--Map List:
			maps={"@5785097","@5779599","@5229496","@5233166","@5230255","@5255658","@4806014","@5338931","@5151115","@5287678","@5295879","@5398275","@7234504","@7235838","@7290337"}
			-- 15 maps
		T = { -- Traduction table
			fr = {
				close = "Fermer cette fenêtre",
				currentMeep = "Nombre de meeps effectués sur cette map: %d",
				won = "%s a gagné !",
				team = {
					green  = "Verte",
					yellow = "Jaune",
					won    = "L'équipe %s a gagné !"
				},
				offset = "Ton offset a bien été changé en X:%d Y:%d.",
				map = {
					timeLeft = "Temps restant",
					mice     = "Souris",
					podium   = "Tour"
				},
				leaderboard = {
					player = "Joueur",
					points = "Points"
				},
				profile = {
					meeps     = "Meeps total: %d",
					podium    = "Nombre de podiums: %d",
					mapPlayed = "Parties jouées: %d",
					wins      = "Parties gagnées: %d",
					loses     = "Parties perdues: %d",
					ratio     = "Ratio: %d%%"
				},
				HELP = {
					{
						title={txt="Meepvivor", color=nil, bcolor="VP", size=30, align=C, u=false, b=false, i=false},
						p={
							{txt="But du jeu:", b=true, u=true, t=true,
							content={
								{txt="Le but du jeu est de tuer les autres joueurs et de survivre."},
								{txt="Pour cela, chaque joueur peut appuyer sur la touche espace pour Meeper. Attention, celui-ci peut aussi vous propulser."},
								{txt="\nChaque map dure 5 minutes. Dès qu'il ne reste plus qu'une personne, celle-ci gagne et gagne 16 points."}
							}
							}
						}
					},
					{
						title={txt="Meepvivor", color=nil, bcolor="VP", size=30, align=C, u=false, b=false, i=false},
						p={
							{txt="Expérience:", b=true, u=true, t=true,
							content={
								{txt="Vous gagnez de l'expérience lorsque vous survivez à une partie (5 points) et lorsque vous gagnez une partie (10 points)."},
								{txt="Lorsque vous avez assez de points d'expérience, vous augmentez d'un niveau."},
								{txt="Vous pouvez utiliser les points de vos niveaux pour améliorer votre meep et vos compétences. Pas encore implémenté."}
							}
							}
						}
					},
					{
						title={txt="Meepvivor", color=nil, bcolor="VP", size=30, align=C, u=false, b=false, i=false},
						p={
							{txt="Commandes:", b=true, u=true, t=true,
							content={
								{txt="!offset [x] [y]  - Change l'offset.", face='Consolas'},
								{txt="!off    [x] [y]  - Change l'offset.", face='Consolas'},
								{txt="!profil [pseudo] - Affiche le profile de quelqu'un.", face='Consolas'},
							}
							},
							{txt="Touches:", b=true, u=true, t=true,
							content={
								{txt="[L] - Affiche le leaderboard."},
								{txt="[P] - Affiche votre profile. "},
								{txt="[H] - Affiche le menu d'aide."},
							}
							}
						}
					},
					{
						title={txt="Meepvivor", color=nil, bcolor="VP", size=30, align=C, u=false, b=false, i=false},
						p={
							{txt="Crédits:", b=true, u=true, t=true,
							content={
								{txt="Module crée par <n2>Athesdrake#0000</n2>, originellement par <n>Fireicefly</n>."},
								{txt="Admins du module: <v>Viaxeiro</v> & <n2>Athesdrake#0000</n2>"},
								{txt="MapCrews: <v>Viaxeiro</v>"},
								{txt="\nSi vous trouvez un bug, signalez-le à <n2>Athesdrake#0000</n2> ou à <v>Viaxeiro</v>, en jeu ou sur le forum."},
								{txt="Tout retour sur le module ainsi que les suggestions sont les bienvenus."}
							}
							}
						}
					}
				}
			},
			en = {
				close = "Close",
				currentMeep = "Number of meeps used on this map: %d",
				won = "%s has won !",
				offset = "Your offset has been changed into X:%s Y:%s.",
				team = {
					green  = "Green",
					yellow = "Yellow",
					won    = "The %s team has won !"
				},
				leaderboard = {
					timeLeft = "Time left",
					mice     = "Mice",
					podium   = ""
				},
				leaderboard = {
					player = "Player",
					points = "Points"
				},
				profile = {
					meeps     = "Meeps used: %d",
					podium    = "Number of podiums: %d",
					mapPlayed = "Games played: %d",
					wins      = "Games won: %d",
					loses     = "Lost games: %d",
					ratio     = "Ratio: %d%%"
				},
				HELP = {
					{
						title={txt="Meepvivor", color=nil, bcolor="VP", size=30, align=C, u=false, b=false, i=false},
						p={
							{txt="Goal of the game:", b=true, u=true, t=true,
							content={
								{txt="The goal is to kill all other players and survive."},
								{txt="For that, each player can press Space to Meep. Warning ! Your own meep can also eject you."},
								{txt="\nEach game last 5 min. As soon as there is one player left, this player win."}
							}
							}
						}
					},
					{
						title={txt="Meepvivor", color=nil, bcolor="VP", size=30, align=C, u=false, b=false, i=false},
						p={
							{txt="Experience:", b=true, u=true, t=true,
							content={
								{txt="You earn exp points when you survive a game (5 points) and when you won a game (10 points)."},
								{txt="When you have enough exp points, you level up."},
								{txt="\nYou can use yours level points to upgrade your meep or yours skills. Not yet implemented"}
							}
							}
						}
					},
					{
						title={txt="Meepvivor", color=nil, bcolor="VP", size=30, align=C, u=false, b=false, i=false},
						p={
							{txt="Commands:", b=true, u=true, t=true,
							content={
								{txt="!offset [x] [y]  - Change your offset.", face='Consolas'},
								{txt="!off    [x] [y]  - Change your offset.", face='Consolas'},
								{txt="!profil [pseudo] - Shows the profil of someone.", face='Consolas'},
							}
							},
							{txt="Keys:", b=true, u=true, t=true,
							content={
								{txt="[L] - Shows the leaderboard."},
								{txt="[P] - Shows your profil. "},
								{txt="[H] - Shows the help's menu."},
							}
							}
						}
					},
					{
						title={txt="Meepvivor", color=nil, bcolor="VP", size=30, align=C, u=false, b=false, i=false},
						p={
							{txt="Credits:", b=true, u=true, t=true,
							content={
								{txt="Module created by <n2>Athesdrake#0000</n2>, originally by <n>Fireicefly</n>."},
								{txt="Admins of the module: <v>Viaxeiro</v> & <n2>Athesdrake#0000</n2>"},
								{txt="MapCrews: <v>Viaxeiro</v>"},
								{txt="\nIf you find a bug please report it to <n2>Athesdrake#0000</n2> or to <v>Viaxeiro</v>, in game or send PM on the forum."},
								{txt="The feedbacks and the suggestions are welcomed."}
							}
							}
						}
					}
				}
			}
		}
	--metatables:
		setmetatable(players, PlayersMethods)
	--sytem:
		comRoom = T[tfm.get.room.community] and tfm.get.room.community or comRoom
		table.foreach({"AutoScore", "AutoNewGame", "AutoShaman", "MortCommand", "DebugCommand", "PhysicalConsumables"}, function(k,v) tfm.exec["disable"..v](true) end) -- Disable system
		table.foreach({'off', 'offset', 'ban', 'unban', 'np', 'profil', 'profile', 'lang'}, function(k,v) system.disableChatCommandDisplay(v) end) -- Disable command display
		system.disableChatCommandDisplay("p", true)
		table.foreach(tfm.get.room.playerList, function(pl) eventNewPlayer(pl) end)
		newMap()
end

--[[   Classes   ]]--
	PlayersMethods = {}
	function PlayersMethods:len()
		local i = 0
		for k,v in pairs(self) do if v.isPlaying then i = i +1 end end
		return i
	end
	PlayersMethods.__index = PlayersMethods
--[[ End Classes ]]--

function eventNewPlayer(name)
	local com = tfm.get.room.playerList[name].community
	com = T[com] and com or "en"
	tfm.exec.setPlayerScore(name, 0, false)
	if players[name] then -- Keep the current data of the player
		players[name].isPlaying = true
	else
		players[name] = {}
		players[name].isPlaying = true
		players[name].offset    = {x=0, y=3}
		players[name].stats     = {}
		local stats             = players[name].stats
		stats.totalMeep         = 0
		stats.mapMeep           = 0
		stats.mapPlayed         = 0
		stats.wins              = 0
		stats.loses             = 0
		stats.nul               = 0
		stats.podium            = 0
		players[name].xp        = 0
		players[name].lvl       = 1
	end
	players[name].com        = com
	players[name].interfaces = {}
	local interfaces         = players[name].interfaces
	interfaces.help          = false
	interfaces.leaderboard   = false
	interfaces.profile       = false
	players[name].timestamp  = os.time() +100

	for _, key in pairs({32, 72, 76, 80}) do
		tfm.exec.bindKeyboard(name, key, true, true)
	end
	if admins[name] then
		tfm.exec.setNameColor(name, 0xEB1D51)
	elseif mapCrews[name] then
		tfm.exec.setNameColor(name, 0x2E72CB)
	end
	local colors1 = {'ch','bv' ,'v'   ,'vp','pt'}
	local colors2 = {'j' ,'cs' ,'cep' ,'ce','fc'}
	local colors3 = {'fc','ch2','rose','vi','r' }
	ui.addTextArea(idMenuH, format("<a href='event:$call$eventKeyboard$n$N72$N1$N0$N0'><%s>H", colors1[math.random(#colors1)]), name, 25, 382, nil, nil, nil, nil, 0.7, true)
	ui.addTextArea(idMenuL, format("<a href='event:$call$eventKeyboard$n$N76$N1$N0$N0'><%s>L", colors2[math.random(#colors2)]), name, 48, 382, nil, nil, nil, nil, 0.7, true)
	ui.addTextArea(idMenuP, format("<a href='event:$call$eventKeyboard$n$N80$N1$N0$N0'><%s>P", colors3[math.random(#colors3)]), name, 69, 382, nil, nil, nil, nil, 0.7, true)
end

function eventPlayerLeft(name)
	players[name].isPlaying = false
end

function eventPlayerDied(name)
	players[name].stats.mapPlayed = players[name].stats.mapPlayed +1
	players[name].stats.loses     = players[name].stats.loses     +1
	if (not teams.green) then
		if playerLeft()==0 then
			tfm.exec.setGameTime(1)
		elseif playerLeft()==1 then
			fireworks      = true
			local survivor = ""
			tfm.exec.setGameTime(5)
			table.foreach(tfm.get.room.playerList, function(pl, data) if players[pl].isPlaying and not data.isDead then survivor=pl end end)
			tfm.exec.giveCheese   (survivor)
			tfm.exec.playerVictory(survivor)
			players[survivor].stats.mapPlayed = players[survivor].stats.mapPlayed +1
			players[survivor].stats.wins      = players[survivor].stats.wins      +1
			addExp(survivor, 10)
			forEachPlayer(function(pl) ui.addTextArea(idWon, "<font size='60'>\n\n<p align='center'>"..format(translate("won", pl), survivor), pl, 4, 4, 796, 396, nil, nil, 0.2, true) end)
		elseif playerLeft()==2 then
			tfm.exec.setGameTime(20)
		end
	else
		local winner = "green"
		for _,pl in pairs(teams.yellow.playerList) do
			if players[pl].isPlaying and not tfm.get.room.playerList[pl].isDead then
				winner = "yellow"
				break
			end
		end
		for _,pl in pairs(teams.green.playerList) do
			if players[pl].isPlaying and not tfm.get.room.playerList[pl].isDead then
				winner = winner=="yellow" and "None" or "green"
				break
			end
		end
		if playerLeft()==0 then return tfm.exec.setGameTime(1) end
		if winner~="None" then
			fireworks = true
			tfm.exec.setGameTime(5)
			for pl, data in pairs(players) do
				if data.isPlaying and not tfm.get.room.playerList[pl].isDead then
					tfm.exec.giveCheese   (pl)
					tfm.exec.playerVictory(pl)
					data.stats.mapPlayed = data.stats.mapPlayed +1
					data.stats.wins      = data.stats.wins      +1
					addExp(pl, 10)
				end
				ui.addTextArea(idWon, "<font size='60'>\n\n<p align='center'>"..format(translate("team", pl).won, translate("team", pl)[winner]), pl, 4, 4, 796, 396, nil, nil, 0.2, true)
			end
		end
	end
end

function eventPlayerWon(name)
	tfm.exec.setPlayerScore(name, 16, true)
end

function eventKeyboard(name, key, down, x, y)
	local data = players[name]
	if key==0 then
		tfm.get.room.playerList[name].isFacingRight = false
		pl.isFacingRight = false
	end
	if key==2 then
		tfm.get.room.playerList[name].isFacingRight = true
		pl.isFacingRight = true
	end
	if key==32 and data.timestamp<=os.time() then
		tfm.exec.explosion(x +(tfm.get.room.playerList[name].isFacingRight and data.offset.x or -data.offset.x), y +data.offset.y, 15, 75, true)
		tfm.exec.displayParticle(20, x, y+10, 0, -2.5, 0, 0.1)
		for i=1,3 do
			tfm.exec.displayParticle(3, x +(tfm.get.room.playerList[name].isFacingRight and data.offset.x or -data.offset.x), y +data.offset.y, math.rand_negative(), math.rand_negative())
		end
		data.timestamp = os.time() +2000
		data.stats.totalMeep    = data.stats.totalMeep +1
		data.stats.mapMeep      = data.stats.mapMeep   +1

		ui.addTextArea(idMeep, "\n"..format(translate("currentMeep", name), data.stats.mapMeep), name, 490, 10, 300, 30, nil, nil, 0.5, true)
	elseif key==72 or key==76 or key==80 then
		local tbl = {
			[72] = {txt="help",        open=function() help(name, 1)       end, close=function() ui.removeBox(idHelp);ui.removeButton(idHelpClose);ui.removeButton(idHelpPrev);ui.removeButton(idHelpNext)            end},
			[76] = {txt="leaderboard", open=function() leaderboard(name)   end, close=function() ui.removeBox(idLeaderboard, name)                                                                                    end},
			[80] = {txt="profile",     open=function() profile(name, name) end, close=function() ui.removeBox(idProfile, name);ui.removeBox(idProfileName, name);for i=idExpBg,idExpTxt do ui.removeTextArea(i, name) end end}
		}
		if data.interfaces[tbl[key].txt] then
			data.interfaces[tbl[key].txt] = false
			tbl[key].close()
		else
			data.interfaces[tbl[key].txt] = true
			tbl[key].open()
		end
	end
end

function eventNewGame()
	if podium==10 then
		podium = 0
		local leaderTable = {}
		for pl, data in pairs(players) do if data.isPlaying then table.insert(leaderTable, pl) end end
		table.sort(leaderTable, function(p1, p2) return tfm.get.room.playerList[p1].score>tfm.get.room.playerList[p2].score end)
		local xpToGive = {15, 10, 5}
		players[leaderTable[1]].stats.podium = players[leaderTable[1]].stats.podium +1
		for i=1, 3 do
			if leaderTable[i] then
				addExp(leaderTable[i], xpToGive[i])
			end
		end
		for pl, data in pairs(players) do if data.isPlaying then tfm.exec.setPlayerScore(pl, 0, false) end end
	end
	podium    = podium +1
	fireworks = false
	ui.removeTextArea(idWon)
	tfm.exec.setGameTime(300)
	setMapName(3*10^5)
	for pl in roomPl() do
		if players[pl].ban then
			players[pl].ban = players[pl].ban -1
			if players[pl].ban==1 then players[pl].ban = false end
			tfm.exec.killPlayer(pl)
		elseif players[pl].isPlaying then
			players[pl].timestamp     = os.time() +4000
			players[pl].stats.mapMeep = 0
		end
	end
	if teams.green then
		for tname, data in pairs(teams) do
			for _, pl in pairs(data.playerList) do
				tfm.exec.setNameColor(pl, data.color)
			end
		end
	else
		for pl in roomPl() do
			if admins[pl] then
				tfm.exec.setNameColor(pl, 0xEB1D51)
			elseif mapCrews[pl] then
				tfm.exec.setNameColor(pl, 0x2E72CB)
			else
				tfm.exec.setNameColor(pl, 0xd7d7d7)
			end
		end
	end
end

function eventTextAreaCallback(id, name, call)
	local arg = {}
	for a in call:gmatch("[^$]+") do -- Split the callback into a table with the '$' separator (eg: 'test$1' → {'test', '1'})
		table.insert(arg, a)
	end
	if arg[1]=="close" then
		if arg[2]:lower()=="box" then
			ui.removeBox(tonumber(arg[3]), name)
		end
	elseif arg[1]=="call" then
		local sub = {}
		for i=3, #arg do
			if arg[i]=="n" then
				table.insert(sub, name)
			elseif arg[i]:sub(0,1)=="N" then
				table.insert(sub, tonumber(arg[i]:sub(2)))
			else
				table.insert(sub, arg[i])
			end
		end
		_G[arg[2]](table.unpack(sub))
	end
end

function eventChatCommand(name, cmd)
	local arg = {}
	for w in cmd:gmatch("%S+") do
		table.insert(arg, w)
	end
	print(format(">%s a effectué la commande '%s', avec '%s' comme arguments.", name, arg[1], table.concat(arg, "', '", 2)))
	if staff(name) then
		if     arg[1]=="ban"   and arg[2] then
			if tfm.get.room.playerList[capitalize(arg[2])] then
				table.insert(bans, capitalize(arg[2]))
				players[capitalize(arg[2])].ban = arg[3] and tonumber(arg[3]) or 10
				tfm.exec.killPlayer(capitalize(arg[2]))
			end
		elseif arg[1]=="unban" and arg[2] then
			if tfm.get.room.playerList[capitalize(arg[2])] then
				table.remove(bans, searchIndex(bans, capitalize(arg[2])))
				players[capitalize(arg[2])].ban = false
			end
		elseif arg[1]=="np"    and arg[2] and arg[2]:match("@%d+") then
			tfm.exec.newGame(arg[2]:match("@%d+"))
		end
	end
	if arg[1]:sub(0,6)=="profil" and arg[2] and arg[2]~="" and tfm.get.room.playerList[capitalize(arg[2])] then
		players[name].interfaces.profile = true
		profile(capitalize(arg[2]), name)
	elseif (arg[1]=="off" or arg[1]=="offset") and arg[2] and arg[2]~="" and arg[3] and arg[3]~="" then
		local x, y = tonumber(arg[2]:match("%-?%d+")), tonumber(arg[3]:match("%-?%d+"))
		if (not (x and y)) then
			ui.message(idOffChange, "<r><b>Invalid Offset", name, 380)
		else
			players[name].offset.x = x<-25 and -25 or (x>25 and 25 or x)
			players[name].offset.y = y<-25 and -25 or (y>25 and 25 or y)
			ui.message(idOffChange, format(translate("offset", name), players[name].offset.x, players[name].offset.y), name, 380)
		end
		after(3, function() ui.removeTextArea(idOffChange, name) end)
	elseif arg[1]=="lang" then
		if not arg[2] then
			local text_lang = "Your current language are <vp>%s</vp>. The supported languages are: <ce>%s</ce> and <ce>%s</ce>"
			local langs = {}
			table.foreach(T, function(k,v) table.insert(langs, k) end)
			ui.message(idLang, format(text_lang, players[name].com, table.concat(langs, "</ce>, <ce>", #langs-1), langs[#langs]), name, 380)
		elseif #arg[2]~=2 then
			ui.message(idLang, format("<vp>%s</vp> is not a valid language format.", capitalize(arg[2])), name, 380)
		elseif T[arg[2]:lower()] then
			players[name].com = arg[2]:lower()
			ui.message(idLang, format("Your language has been set to <vp>%s</vp>.", capitalize(arg[2])), name, 380)
		else
			local text_lang = "<vp>%s</vp> is not supported yet. The supported languages are: <ce>%s</ce> and <ce>%s</ce>"
			local langs = {}
			table.foreach(T, function(k,v) table.insert(langs, k) end)
			ui.message(idLang, format(text_lang, capitalize(arg[2]), table.concat(langs, "</ce>, <ce>", 1, #langs-1), langs[#langs]), name, 380)
		end
		after(5, function() ui.removeTextArea(idLang, name) end)
	end
end

function addExp(name, amount)
	players[name].xp = players[name].xp + amount
	local lvl, xp    = players[name].lvl, players[name].xp
	if getExpLvl(xp, lvl)<=xp then
		players[name].xp  = xp  -getExpLvl(xp, lvl)
		players[name].lvl = lvl +1
		addExp(name, 0)
	end
end

function getExpLvl(xp, lvl)
	local lvl32_   = math.ceil((4.5 * lvl^2 -162.5 * lvl + 2220)/10)*10
	local lvl17_31 = math.ceil((2.5 * lvl^2 -40.5  * lvl + 360 )/10)*10
	local lvl1_16  = math.ceil((1.0 * lvl^2 +6     * lvl + 0   )/10)*10
	return lvl<17 and lvl1_16 or (lvl<32 and lvl17_31 or lvl32_)
end

function newMap()
	local temp_map = ""
	repeat
		math.randomseed(os.time())
		temp_map = maps[math.random(#maps)]
	until temp_map~=currentMap
	currentMap = temp_map
	if math.random()<=0.2 and players:len()>=4 then -- 20%
		teams = {
			green  = {},
			yellow = {}
		}
		local i           = 0
		local green       = teams.green
		local yellow      = teams.yellow
		green.color       = 0x00ff00
		green.playerList  = {}
		yellow.color      = 0xffff00
		yellow.playerList = {}

		for pl, data in pairs(players) do
			if data.isPlaying then i = i +1
				if i%2==0 then
					table.insert(green.playerList , pl)
				else
					table.insert(yellow.playerList, pl)
				end
			end
		end
	else teams = {}
	end
	tfm.exec.newGame(temp_map)
end

function setMapName(time)
	local author   = tfm.get.room.xmlMapInfo and tfm.get.room.xmlMapInfo.author  or "Athesdrake#0000"
	local mapCode  = tfm.get.room.xmlMapInfo and tfm.get.room.xmlMapInfo.mapCode or "0"
	local timeLeft = T[comRoom].map.timeLeft
	local time     = os.date("%M:%S", time)
	local miceTxt  = T[comRoom].map.mice
	local mice     = players:len()
	local round    = T[comRoom].map.podium
	local roundNbr = podium
	ui.setMapName(mapName:format(author, mapCode, timeLeft, time, miceTxt, mice, round, roundNbr))
end

--[[ function countPlayers()
	local i = 0
	for k,v in pairs(players) do if v.isPlaying then i = i +1 end end
	return i
end]]

function staff(name)
	return admins[name] or mods[name]
end

function roomPl() -- Return a generator of the tfm.get.room.playerList table
	return next, tfm.get.room.playerList, nil
end

function capitalize(str) -- Capitalize the given string
	if type(str)=="string" then
		return str:sub(0,1):upper()..str:sub(2):lower()
	end
end

function math.rand_negative(...) -- Return a random negative or positive number with the given args | usefull in this case: math.random(5, 10)*math.random(-1 or 1)
	return (math.random()>0.5 and 1 or -1)*math.random(table.unpack({...}))
end

function torad(deg) -- Convert ° to rad.
	return deg*math.pi/180
end

function firework(id, x, y, name) -- Spawns a firework
	for i=0, 10 do
		local angle = math.rand_negative(0, 180)
		local xs    = 2*math.cos(torad(angle))
		local ys    = 2*math.sin(torad(angle))
		local xa    = math.rand_negative()/10
		local ya    = math.rand_negative()/10
		tfm.exec.displayParticle(id, x, y, xs, ys, 0, 0, name)
		tfm.exec.displayParticle(id, x, y, xs, ys, xa, ya, name)
	end
end

function after(temps, func) -- Exec a function after the given time
	table.insert(aft, {t=os.time()+temps*1000, f=func})
end

function forEachPlayer(func)
	for pl,v in roomPl() do
		if players[pl].isPlaying then
			func(pl)
		end
	end
end

function searchIndex(tbl, value)
	for k,v in ipairs(tbl) do
		if v==value then
			return k
		end
	end
end

function help(name, page)
	local HELP = T[players[name].com].HELP
	local H    = HELP[page]
	local txt  = fontage(H.title.txt, H.title).."\n"
	for kp,vp in pairs(H.p) do
		txt = txt..(vp.t and "\t" or "")..fontage(vp.txt, vp)
		for kc,vc in pairs(vp.content) do
			txt = txt..(vc.t and "\t" or "")..fontage(vc.txt, vc)
		end
	end
	ui.addBox(idHelp, txt, name, 200, 70, 400, 300)
	ui.addButton(idHelpClose, format("<p align='center'><a href='event:$call$eventKeyboard$n$N72'>%s", translate("close", name)), name, 250, 345, 300)
	if (page-1)>0 then ui.addButton(idHelpPrev, format("<p align='center'><a href='event:$call$help$n$N%d'>&lt;", page-1), name, 215, 345, 20) end
	if page<#HELP then ui.addButton(idHelpNext, format("<p align='center'><a href='event:$call$help$n$N%d'>&gt;", page+1), name, 565, 345, 20) end
end

function fontage(txt, f) -- color, bcolor, face, size, align, u, b, i
	f.color = f.color or ""
	f.size  = f.size  or 12
	f.align = f.align or L
	if f.b then txt = format("<b>%s</b>", txt) end;if f.u then txt = format("<u>%s</u>", txt) end;if f.i then txt = format("<i>%s</i>", txt) end
	if f.bcolor then txt = format("<%s>%s</%s>", f.bcolor, txt, f.bcolor) end
	return format("<p align='%s'><font %s color='%s' size='%d'>%s</font></p>", f.align, f.face and format("face='%s'", f.face) or '', f.color, f.size, txt)
end

function leaderboard(name)
	local txt = "<p align='center'><font size='30'><u>Leaderboard</u></font></p>\n"
	txt = txt.."<font face='Lucida Console'><r>\n  n. joueur           points\n</r>"
	local leaderTable = {}
	for pl, data in pairs(players) do if data.isPlaying then table.insert(leaderTable, pl) end end
	table.sort(leaderTable, function(p1, p2) return tfm.get.room.playerList[p1].score>tfm.get.room.playerList[p2].score end)
	for key, pl in pairs(leaderTable) do
		txt = txt..("  <n>%0d. <v>%s<n><j>%d</j></n></v></n>\n"):format(key, pl..(" "):rep(20 -#pl), tfm.get.room.playerList[pl].score)
	end
	ui.addBox(idLeaderboard, txt, name, 200, 70, 400, 300)
	ui.addTextArea(idLeaderboard*100+6, "<b>"..string.char(77, 111, 100, 117, 108, 101, 32, 99, 114, 195, 169, 101, 32, 112, 97, 114, 32, 65, 116, 104, 101, 115, 100, 114, 97, 107, 101), name, 207, 350, nil, nil, 0x0, 0x0, 0, true)
	ui.addTextArea(idLeaderboard*100+7, "<b>V"..version, name, 530, 350, nil, nil, 0x0, 0x0, 0, true)
end

function profile(pr2show, name)
	addExp(name, 5)
	local txt, stats = ("\n"):rep(4)..format("<p align='center'><b>Lvl <j>%d</j></b></p>", players[pr2show].lvl)..("\n"):rep(2), players[pr2show].stats -- TODO ↓
	for k,v in pairs({{pr="meeps", st=stats.totalMeep}, {pr="podium", st=stats.podium}, {pr="mapPlayed", st=stats.mapPlayed}, {pr="wins", st=stats.wins}, {pr="loses", st=stats.loses}, {pr="ratio", st=(stats.wins/stats.mapPlayed)*100}}) do
		txt = txt..format(translate("profile", name)[v.pr], v.st).."\n"
	end
	ui.addBox(idProfile, txt, name, 300, 75, 200, 250)
	ui.addBox(idProfileName, format("<p align='center'><font size='20'><v>%s", pr2show), name, 275, 75, 250, 50)
	ui.addTextArea(idExpBgBorder, "", name, 325, 155, 150, 10, nil, nil, 1, true)
	ui.addTextArea(idExpBg, "", name, 326, 156, 148, 8, 0x324650, 0x324650, 1, true)
	if players[pr2show].xp~=0 then ui.addTextArea(idExpFg, "", name, 326, 156, (players[pr2show].xp/getExpLvl(players[pr2show].xp, players[pr2show].lvl))*148, 8, 0x07CECE, 0x07CECE, 1, true) end
	ui.addTextArea(idExpTxt, format("<p align='center'><font color='#0'>%d/%d", players[pr2show].xp, getExpLvl(players[pr2show].xp, players[pr2show].lvl)), name, 325, 151, 150, 0, 0x0, 0x0, 0, true)
	ui.addButton(idProfile, format("<p align='center'><a href='event:$call$eventKeyboard$n$N80'>%s", translate("close", name)), name, 315, 300, 170)
end

ui.addBox = function(id, txt, name, x, y, width, height) -- A beautiful TextArea
	local txt    = txt    or "" 
	local x      = x      or 100
	local y      = y      or 100
	local height = height or 200
	local width  = width  or 200
	ui.addTextArea(id*100+0 ," ", name, x+0, y+0, width     , height   , 0x2D211A, 0x2D211A, 0.8, true)
	ui.addTextArea(id*100+1 ," ", name, x+1, y+1, width-2   , height-2 , 0x986742, 0x986742, 1  , true)
	ui.addTextArea(id*100+2 ," ", name, x+4, y+4, width-8   , height-8 , 0x171311, 0x171311, 1  , true)
	ui.addTextArea(id*100+3 ," ", name, x+5, y+5, width-10  , height-10, 0x0C191C, 0x0C191C, 1  , true)
	ui.addTextArea(id*100+4 ," ", name, x+6, y+6, width-12  , height-12, 0x24474D, 0x24474D, 1  , true)
	ui.addTextArea(id*100+5 ," ", name, x+7, y+7, width-14  , height-14, 0x183337, 0x183337, 1  , true)
	ui.addTextArea(id       ,txt, name, x+8, y+8, width-16  , height-16, 0x122528, 0x122528, 1  , true)
end

ui.addButton = function(id, txt, name, x, y, width) -- A simple button
	local txt    = txt    or "" 
	local x      = x      or 100
	local y      = y      or 100
	local width  = width  or 200
	ui.addTextArea(id*100+6, " ", name, x-1, y-1, width-1, 11, 0x5D7D90, 0x5D7D90, 1, true)
	ui.addTextArea(id*100+7, " ", name, x+1, y+1, width  , 12, 0x11171C, 0x11171C, 1, true)
	ui.addTextArea(id*100+8, " ", name, x  , y  , width  , 12, 0x3C5064, 0x3C5064, 1, true)
	ui.addTextArea(id*100+9, txt, name, x  , y-3, width  , 20, 0x0, 0x0, 0, true)
end

ui.message = function(id, txt, name, y)
	local txt = ("<font face='Consolas'>%s</font>"):format(txt)
	local len = #txt:gsub('<[^>]+>', '')*6.28572
	ui.addTextArea(id, txt, name, 795-len, y, len, nil, nil, nil, 1, true)
end

ui.removeBox = function(id, name) -- Remove the Box + the button
	if id then
		ui.removeTextArea(id, name)
		for i=id*100, id*100+15 do
			ui.removeTextArea(i, name)
		end
	end
end

ui.removeButton = function(id, name) -- Remove the button
	if id then
		for i=id*100+6, id*100+9 do
			ui.removeTextArea(i, name)
		end
	end
end

function playerLeft()
	local alive = {}
	table.foreach(tfm.get.room.playerList, function(k,v) if not v.isDead then table.insert(alive, k) end end)
	return #alive
end

function translate(msg, name)
	return T[players[name].com][msg]
end

main()

function eventLoop(t1, t2)
	setMapName(t2)
	if t2<=0 then
		for pl, data in roomPl() do
			if players[pl].isPlaying then
				if not data.isDead then
					players[pl].stats.mapPlayed = players[pl].stats.mapPlayed +1
					players[pl].stats.nul       = players[pl].stats.nul       +1
					addExp(pl, 5)
				end
			end
		end
		newMap()
	end
	for pl, data in roomPl() do
		if not data.isDead and players[pl].isPlaying then
			ui.addTextArea(idMeep, "\n"..format(translate("currentMeep", pl), players[pl].stats.mapMeep), pl, 490, 10, 300, 30, nil, nil, 0.5, true)
			local percent = 100 - (players[pl].timestamp-os.time())/20
			percent = percent<=100 and (percent>=0 and percent or 0) or 100
			if percent<100 then ui.addTextArea(idLoadBack, "", pl, 490, 50, 300, nil, nil, nil, 0.5, true) else ui.removeTextArea(idLoadBack, pl) end
			ui.addTextArea(idLoadFore, "", pl, 490, 50, percent*3, nil, 0xff00, 0xff00, 0.5, true)
		end
	end
	if fireworks then
		local tbl = {21, 22, 23, 24}
		for i=1, (math.random()>=0.8 and 2 or 1) do
			firework(tbl[math.random(#tbl)], math.random(100, 700), math.random(50, 350))
		end
	end
	for key,data in ipairs(aft) do
		if data.t<=os.time() then
			data.f()
			table.remove(aft, key)
		end
	end
end