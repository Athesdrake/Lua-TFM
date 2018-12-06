--[[  SnowFight created by Sebeisseba  ]]--
--[[       Remake by Athesdrake        ]]--

local format = string.format
__version__ = 'alpha1'

function main()
	--vars:
		SHAKE      = 27
		UPKEY      = 1
		SPACE      = 32
		SHIFT      = 16
		COUNT      = 1
		SPAWNP     = 34
		DOWNKEY    = 3
		LEFTKEY    = 0
		RIGHTKEY   = 2
		PARAMETERP = 2
		STARTCONST = 6
		FACTORP    = STARTCONST

		SNOW = false
		AUTO = true

		COMROOM = tfm.get.room.community

		next_map = nil
		map = 0

		playerCount = 0
		maxPlayerCount = 0
		mapCount = 0
		commands = {"help","controls","control","control1","control2","controls1","controls2","p","profil","profile","lang","sebaiscute","sebaisugly"}

		unpack = table.unpack
		format = string.format
	--ids:
		idBtnHelp     = 1
		idBtnProfile  = 2
		idErrors      = 3
		idExpBg       = 4
		idExpBgBorder = 5
		idExpFg       = 6
		idExpTxt      = 7
		idHelp        = 8
		idLeaderboard = 9
		idLoadBack    = 10
		idLoadFore    = 11
		idNumErrors   = 12
		idNumErrorsBg = 13
		idProfile     = 14
		idProfileName = 15
		idWon         = 16
		idErrList     = 17
	--tables:
		skins = {
			fraises = {
				img = "15c02af84a1.png",
				xoff = -5,
				yoff = -6
			}
		}
		keys  = {
			P = 80,
			H = 72,
			down = DOWNKEY,
			left = LEFTKEY,
			right= RIGHTKEY,
			SHIFT= SHIFT,
			space= SPACE,
			up   = UPKEY,
		}
		maps  = {
			normal = {
				6632577,6665126,6665078,1698620,6016240,7128930,7131265,7131294,
				6026018,7142361,7142437,7142438,7142439,7146328,7146329,7149393,
				7147450,7055890,7228643,7228645,7228650,7147123,7147125,7228643,
				6779956,7228645,7228650
			},
			spec = {
				7055890
			}
		}
		admins  = {['Athesdrake#0000']=1, ['Sebaisseba#0020']=1, ['Viaxeiro#0000']=2}
		aft     = {}
		bans    = {}
		colors  = {0xFFAA00, 0xFFFF00, 0x00FF00, 0x00AAFF, 0x0000FF, 0xAA00FF, [0]=0}
		duel    = {players={}, duel=false}
		players = {}
		teams   = {green={}, yellow={}, teams=false}
		T = {
			en={
				welcome = "<ROSE>Welcome! Hold spacebar to charge up a snowball, and release spacebar to shoot! Rounds start 15 seconds into the map.\n\nNew update! Press shift to toggle between shooting snowballs or fraises.",
				start   = "<ROSE>Begin!",
				chelp   = "Controls:\nType !controls 1 to hold space to shoot\nType !controls 2 to press space to charge, then press space again to shoot",
				HELP    = {
					['Presentation'] = "In this game your goal is to kill everyone else using snowballs!\n Use the space bar to charge up and release a snowball (you must charge for at least a few seconds to get a good throw).\n\nYou can change between two different control settings with the !controls command.",
					['Tips'] = " -Snowballs charge up faster the longer the round goes!\n -When the timer drops below 30 seconds, you will begin to shoot increasingly more snowballs.\n -The longer you survive, the greater color your name will have.\nHere is the hierarchy of those colors:\n<font color='#ffaa00'>FFAA00</font>\n<font color='#ffff00'>FFFF00</font>\n<font color='#ff00'>00FF00</font>\n<font color='#aaff'>00AAFF</font>\n<font color='#ff'>0000FF</font>\n<font color='#aa00ff'>AA00FF</font>"
				},
				controls= {
					"Press and hold space to shoot!",
					"Press space twice to shoot!"
				},
				close   = "Close",
				tie     = "<ROSE>It's a tie! Start again.",
				top     = "Snowball Fight, Round ",
				help    = "In this game your goal is to kill everyone else using snowballs! Use the space bar to charge up and release a snowball (you must charge for at least a few seconds to get a good throw). You can change between two different control settings with the !controls command.\n -Snowballs charge up faster the longer the round goes!\n -When the timer drops below 30 seconds, you will begin to shoot increasingly more snowballs.",
				win1    = "<ROSE>Congratulations, $name",
				win2    = "Starting new game...",
				died    = "<ROSE>Just kidding, looks like $name was too nooby and died...",
				solo    = "Playing alone? Invite some friends!",
				snow    = "You are shooting snow!",
				error   = {
					command = "Unrecognized command. Available commands: !help, !controls",
					unknown_pl = "Unknown player."
				},
				fraises = "You are shooting fraises!",
				cuteexe = "true",
				uglyexe = ">:(",
				confirm = {
					"Press and hold space to shoot!",
					"Press space twice to shoot!"
				},
				profile = {
					snowballThrown = "Snowballs thrown: %d",
					mapPlayed = "Played maps: %d",
					loses  = "Rounds lost: %d",
					ratio  = "Ratio: %d%%",
					wins   = "Rounds won: %d",
				},
				teams = {
					yellow = 'yellow',
					green = 'green'
				},
				winteam = 'The $color team won.'
			},
			fr={
				welcome = "<ROSE>Bienvenue! Enfonce la touche espace pour charger une boule de neige, et relâche la touche pour lancer une boule de neige! Chaque partie commence après 15 secondes.\n\nNouvelle mise à jour! Appuie sur shift pour changer de projectile !",
				start   = "<ROSE>Ça commence!",
				chelp   = "Controls:\nÉcrit !controls 1 pour maintenir espace pour tirer\nÉcrit !controls 2 pour appuyer sur espace pour charger, ensuite appuies denouveau sur espace pour tirer.",
				HELP    = {
					['Présentation'] = "Dans ce mini-jeu, votre but est de tuer tout le monde en utilisant des boules de neiges!\nUtilise la barre d'espace pour charger et relâche pour lancer une boule de neige (tu dois charger pendant quelques secondes pour faire un bon lancé).\n\nTu peux changer entre deux contrôles différents avec la commande !controls .",
					['Conseil'] = " -Les boules de neiges charges plus rapidement plus la partie est avancée!\n -Lorsque le temps est inférieur à 30 secondes, vous commencez à tirer plus de boules de neiges à la fois.\n -Au plus tu survis longtemps, au plus la couleur de ton pseudo sera haut placée.\nVoici la hiérarchie de ces couleurs:\n<font color='#ffaa00'>FFAA00</font>\n<font color='#ffff00'>FFFF00</font>\n<font color='#ff00'>00FF00</font>\n<font color='#aaff'>00AAFF</font>\n<font color='#ff'>0000FF</font>\n<font color='#aa00ff'>AA00FF</font>"
				},
				controls= {
					"Appuies et maintiens espace pour tirer!",
					"Appuies deux fois sur espace pour tirer!"
				},
				close   = "Fermer cette fenêtre",
				tie     = "<ROSE>Égalité!",
				top     = "Combat de boule de neige, Tour ",
				help    = "Dans ce mini-jeu, votre but est de tuer tout le monde en utilisant des boules de neiges! Utilise la barre d'espace pour charger et relâche pour lancer une boule de neige (tu dois charger pendant quelques secondes pour faire un bon lancé). Tu peux changer entre deux contrôles différents avec la commande !controls .\n -Les boules de neiges charges plus rapidement plus la partie est avancée!\n -Lorsque le temps est inférieur à 30 secondes, vous commencez à tirer plus de boules de neiges à la fois.",
				win1    = "<ROSE>Bravo, $name",
				win2    = "Lancement d'une nouvelle partie...",
				died    = "<ROSE>Comme c'est marrant, on dirait que $name était trop noob pour gagner...",
				solo    = "Tu joues seul? Invite des amis!",
				snow    = "Tu lances maintenant des boules de neiges!",
				error   = {
					command = "Commande inconnue. Commandes valides: !help, !controls",
					unknown_pl = "Joueur inconnu."
				},
				fraises = "Tu lances maintenant des fraises!",
				cuteexe = "Pas faux",
				uglyexe = ">:(",
				confirm = {
					"Appuies et maintiens espace pour tirer!",
					"Appuies deux fois sur espace pour tirer!"
				},
				profile = {
					snowballThrown = "Snowballs thrown: %d",
					mapPlayed = "Played maps: %d",
					loses  = "Rounds lost: %d",
					ratio  = "Ratio: %d%%",
					wins   = "Rounds won: %d",
				},
				teams = {
					yellow = 'jaune',
					green = 'verte'
				},
				winteam = 'L\'équipe $color a gagnée.'
			},
			br={
				welcome = "<ROSE>Bem vindos! Segurem a barra de espaço para carregar uma bola de neve e solte a barra de espaço para atirar! A partida começará em 15 segundos, boa sorte!\n\nAtualização! Pressione shift para disparar morangos.",
				start   = "<ROSE>Começou!",
				chelp   = "Controles: \nDigite !controls 1 para segurar a barra de espaço para atirar \nDigite !controls 2 para apertar a barra de espaço para carregar, então aperte a barra de espaço de novo para atirar",
				controls= {
					"Pressione e segure espaço para atirar!",
					"Pressione o espaço duas vezes para atirar!",
				},
				tie     = "<ROSE>Empatou! Começando uma nova rodada...",
				top     = "Bolinha de Neve, Rodada ",
				help    = "Neste jogo seu objetivo é matar todos os outros usando bolas de neve! Use a barra de espaço para carregar e liberar uma bola de neve (você deve esperar pelo menos alguns segundos para conseguir um bom tiro). Você pode mudar entre dois tipos de controle diferentes com o comando !controls.\n -Bolas de neve carregam mais rápido quanto mais tempo o round têm!\n -Quando o temporizador cai abaixo de 30 segundos, você começará a atirar cada vez mais bolas de neve.",
				win1    = "<ROSE>Parabéns, $name",
				win2    = "Iniciando um novo jogo...",
				died    = "<ROSE>É brincadeira, parece que $name era muito noob e morreu...",
				snow    = "Está disparando neve!",
				solo    = "Jogando sozinho? Chame os seus amigos!",
				error   = {
					command = "Comando não reconhecido. Comandos disponíveis: !help, !controls!",
					unknown_pl = "Unknown player."
				},
				fraises = "Está disparando morangos!",
				cuteexe = "verdade",
				uglyexe = ">:(",
				confirm = {
					"Pressione e segure espaço para atirar!",
					"Pressione o espaço duas vezes para atirar!"
				},
				profile = {
					snowballThrown = "Snowballs thrown: %d",
					mapPlayed = "Played maps: %d",
					loses  = "Rounds lost: %d",
					ratio  = "Ratio: %d%%",
					wins   = "Rounds won: %d",
				}
			}
		}
		STATS = {
			loses = 0,
			lvl = 1,
			mapPlayed = 0,
			snowballThrown = 0,
			tie = 0,
			wins = 0,
			xp = 0
		}
	--metatables:
		setmetatable(players, PlayersMethods)
	--sytem:
		safeEvent()
		table.foreach({'np', 'npp', 'ban', 'unban', 'tstaff', 'controls', 'control', 'control1', 'control2', 'controls1', 'controls2', 'p', 'profil', 'lang'}, function(_,cmd)
			system.disableChatCommandDisplay(cmd, true)
		end)
		COMROOM = T[COMROOM] and COMROOM or 'en'
		table.foreach(tfm.get.room.playerList, function(k) eventNewPlayer(k) end)
		table.foreach({"AutoNewGame", "AutoShaman", "AutoTimeLeft", "AutoScore", "PhysicalConsumables"},
			function(_,v) tfm.exec["disable"..v](true) end
		) -- disable
		new_map()
end

--[[   Classes   ]]--
do
	PlayersMethods = {}
	function PlayersMethods:len()
		local i, pls = 0, self:playing()
		for _ in pairs(pls) do i = i +1 end
		return i, pls
	end
	function PlayersMethods:alives()
		local alives = {}
		for pl,data in pairs(self) do
			if not data.isDead then
				table.insert(alives, pl)
			end
		end
		return alives
	end
	function PlayersMethods:playing()
		local playing = {}
		for pl,data in pairs(self) do
			if data.isPlaying and not data.asLeft and not data.ban then
				playing[pl] = data
			end
		end
		return playing
	end

	function PlayersMethods:needHash(player)
		for _,pl in pairs(self) do
			if pl.pseudo==player.pseudo and not pl.hash==player.hash then
				return true
			end
		end
		return false
	end
	PlayersMethods.__index = PlayersMethods

	Player = {}
	-- Player.__index = Player

	function Player.__eq(p1, p2)
		if type(p2)=='string' then
			return p1:fname()==p2
		end
		if type(p1)=='string' then
			return p1==p2:fname()
		end
		return p1.pseudo==p2.pseudo and p1.hash==p2.hash
	end

	function Player.__tostring(p)
		if players:needHash(p) then
			return tostring(p.pseudo..'#'..p.str_hash)
		end
		return tostring(p.pseudo)
	end

	function Player.new(name)
		local hash = 0
		if name:match('#') then
			pseudo, str_hash = name:match('^(.+)#(%d+)$')
			if type(str_hash)=='string' then
				hash = tonumber(hash)
			end
		elseif name:match('*') then
			pseudo, str_hash, hash = name, 'guest', 801
		end
		local data = {
			color     = 0,
			com       = tfm.get.room.playerList[name].community:lower(),
			controls  = 1,
			hash      = hash or str_hash,
			isAfk     = true,
			isDead    = true,
			isPlaying = true,
			isTarget  = false,
			mustshake = false,
			pseudo    = pseudo,
			settings  = {storm=true},
			skin      = 'snow',
			stats     = table.copy(STATS), -- #TODO: Load the saved data
			str_hash  = str_hash,
			times     = {},
		}
		data.com = T[data.com] and data.com or COMROOM
		data.interfaces = {profile=false, help=false}
		return setmetatable(data, Player)
	end

	function Player:fname()
		if players:needHash(self) then
			return format('%s#%s', self.pseudo, string.align(self.hash, '>', 4, 0))
		end
		return self.pseudo
	end

	function Player:needHash()
		return players:needHash(self)
	end

	function Player:isAlive()
		return not self.isDead
	end

	setmetatable(Player, { __call = function(_, ...) return Player.new(...) end })
end
--[[ End Classes ]]--

--[[   Libs   ]]--
do
	function table.match(tbl, func)
		for i,v in ipairs(tbl) do
			if func(i,v) then
				return v
			end
		end
		return false
	end

	function table.copy(tbl)
		local temp = {}
		for k,v in next, tbl do
			temp[k] = v
		end
		return temp
	end

	function inTable(tbl, val)
		for k,v in next,tbl do
			if v==val then
				return true, k
			end
		end
		return false, -1
	end

	function table.indexOf(tbl, value)
		return ({inTable(tbl, value)})[2]
	end

	function len(tbl)
		local len = 0
		for _ in next, tbl do
			len = len +1
		end
		return len
	end

	string.split = function(str, sep) -- Split a string into a table with a separator
		local sep, buffer = sep or "$", {}
		local regex = sep:match('%%') and sep or "[^"..sep.."]+"
		for element in str:gmatch(regex) do
			table.insert(buffer, element)
		end
		return buffer
	end
	split = string.split

	string.capitalize = function(str) -- Capitalize the given string
		return str:sub(0,1):upper()..str:sub(2):lower()
	end
	capitalize = string.capitalize

	string.formatting = function(str, tbl)
		for w,match in str:gmatch('[^\\]?($([%da-zA-Z_]+)$?)') do
			local i,j = str:find(w)
			if tbl[match] then
				str = str:sub(0,i-1)..tostring(tbl[match])..str:sub(j+1)
			end
		end
		return str
	end

	string.align = function(str, dir, len, char)
		if not (dir=='<' or dir=='>' or dir=='^') then
			error(format("Unreconizable direction: excepted '<', '^' or '>', got '%s'", dir))
		end
		str = tostring(str)
		char = tostring(char or ' ')
		len = len-#str or 0

		if dir=='^' then
			local l1, l2 = math.floor(len/2), math.ceil(len/2)
			return format('%s%s%s', char:rep(l1), str, char:rep(l2))
		else
			local tbl = {str, char:rep(len)}
			if dir=='>' then
				tbl = table.reverse(tbl)
			end
			return format('%s%s', table.unpack(tbl))
		end
	end

	function math.rand_neg(...) -- Return a random negative or positive number with the given args
		return (math.random()>0.5 and 1 or -1)*math.random(table.unpack({...}))
	end

	function getTable(path)
		local tbl = _G
		for _,n in pairs(path) do
			tbl = tbl[n]
		end
		return tbl
	end

	function shuffle(tbl)
		for i=#tbl, 0, -1 do
			local r = math.random(#tbl)
			tbl[i], tbl[r] = tbl[r], tbl[i]
		end
		return tbl
	end
end
--[[ End Libs ]]--

function eventNewPlayer(name)
	if not players[name] then
		players[name] = Player(name)
	else
		players[name].asLeft = false
		players[name].isPlaying = true
	end
	for _,key in pairs(keys) do
		system.bindKeyboard(name, key, true, true)
		system.bindKeyboard(name, key, false, true)
	end
	system.bindKeyboard(name, SHIFT, false, false)
	system.bindKeyboard(name, 80, false, false)
	system.bindKeyboard(name, 72, false, false)
	tfm.exec.chatMessage(translate("welcome", name), name)
	ui.addButton(idBtnHelp, '<p align="center"><a href="event:call$help$n">Help</a></p>', name, 20, 385, 50, 30)
	ui.addButton(idBtnProfile, '<p align="center"><a href="event:call$profile$n$n">Profile</a></p>', name, 90, 385, 100, 30)
	if name=='Athesdrake#0000' then debug(name) end
end

function eventPlayerLeft(name)
	-- #TODO: Save data (players[name].stats)
	eventPlayerDied(name)
	-- players[name].isAfk  = true
	-- players[name].isDead = true
	-- players[name].asLeft = true
	-- players[name].color  = 0
	-- players[name].isPlaying = false
	players[name] = nil -- Not sure at all
end

function eventPlayerDied(name)
	if not players[name] then return end
	players[name].isDead = true
	if duel.duel then
		local p = duel.players
		if not (p[1][1]==name or p[2][1]==name) then
			return
		end
	end
	players[name].stats.mapPlayed = players[name].stats.mapPlayed +1
	players[name].stats.loses = players[name].stats.loses +1
	if players[name].color>0 then
		players[name].color = players[name].color -1
	end
	if #players:alives()==1 then
		eventWin(players:alives()[1])
	elseif #players:alives()==0 then
		reject_after('start')
		tfm.exec.setGameTime(3)
		for pl in pairs(players) do
			tfm.exec.chatMessage(translate('tie', pl), pl)
		end
		SNOW = false
		STORM = true
	end
	if teams.teams then
		for _, data in pairs(players:alives()) do
			teams[data.team].alives = teams[data.team].alives +1
		end
		local green, yellow = teams.green.alives, teams.yellow.alives
		if green==0 and yellow==0 then
			sendMessage("It's a tie !")
		elseif green==0 then
			sendMessage("The Yellow Team won")
		elseif yellow==0 then
			sendMessage("The Green Team won")
		end
		if green==0 or yellow==0 then
			reject_after('start')
			SNOW = false
			STORM = true
		end
	end
end

function eventNewGame()
	SNOW  = false
	STORM  = false
	COUNT = 1
	FACTORP  = STARTCONST
	mapCount = mapCount +1
	ui.setMapName(T[COMROOM]['top']..tostring(mapCount))
	for pl,data in pairs(players) do
		if data.ban and not data.asLeft then
			data.ban.rounds = data.ban.rounds -1
			if data.ban.rounds==1 then data.ban = nil end
			tfm.exec.killPlayer(pl)
		elseif not data.asLeft then
			data.times  = {nil,nil}
			data.isDead = false
			data.isAfk  = true
			data.mustshake = false
			data.isTarget  = false
			data.wantstoshoot = false
			if data.controls==2 then
				data.spawnCount = 0
				data.releaseCount = 0
			end
			tfm.exec.setNameColor(pl, colors[data.color] or 0x6A7495)
			if admins[pl] then
				-- tfm.exec.setNameColor(pl, 0xFF0000) # Admin color
			end
		end
	end
	tfm.exec.setGameTime(180, true)
	after(15, function() SNOW = true;sendMessage("start") end, nil, "start")
	if players:len()==1 then sendMessage("solo") end
end

function eventLoop(_, t2)
	for k,v in ipairs(aft) do
		if v.t<=os.time() then
			v.f(unpack(v.args or {}))
			table.remove(aft, k)
		end
	end
	if STORM then snowstorm() end
	if SNOW then
		FACTORP = FACTORP +0.05
		for pl, data in pairs(players) do
			if data.mustshake then
				tfm.exec.playEmote(pl, SHAKE)
			end
		end
	end
	if t2<.01 then
		local alives, t = #players:alives(), {team_game()}
		if alives>1 then
			sendMessage("tie")
		end
		for _, pl in pairs(players:alives()) do
			local data = players[pl]
			local tieorwin = 'tie'
			if t[1] then
				tieorwin = t[2]
			else
				tieorwin = alives>1 and 'win' or 'tie'
			end
			data.stats[tieorwin] = data.stats[tieorwin] +1 -- #TODO: Add only if there is +four(?) players in the room
			data.stats.mapPlayed = data.stats.mapPlayed +1
			addExp(pl, tieorwin=='win' and 20 or 3)
		end
		if next_map then
			tfm.exec.newGame(next_map)
			next_map = nil
		else
			new_map()
		end
	end
	if t2<30250*2 then COUNT = 2 end
	if t2<10250*3 then COUNT = 3 end
	if t2<5250*2  then COUNT = 5 end
	PARAMETERP = 2+2*math.random()
end

function eventChatCommand(name, cmd)
	if cmd=='a' then crash() end
	local args = split(cmd, '%S+')
	if admins[name] then
		local continue = false
		if args[1]=="tstaff" and args[2] then
			local msg = string.formatting('<ch>[SnowFight] [$name] $msg</ch>', {name=name, msg=args[2]})
			for adm in pairs(admins) do
				tfm.exec.chatMessage(msg, adm)
			end
		elseif args[1]=="ban" and args[2] then
			local player = find_one_player(args[2])
			if player then
				bans[player] = true
				players[player].ban = {
					rounds = args[3] and tonumber(args[3]) or 10,
					reason = args[4] or 'No reason specified',
					author = name
				}
				tfm.exec.killPlayer(player)
			end
		elseif args[1]=="unban" and args[2] then
			local player = find_one_player(args[2])
			if player then
				bans[player] = nil
				players[player].ban = nil
			end
		elseif args[1]=="np" and args[2] and args[2]:match("@?%d+") then
			tfm.exec.newGame('@'..tostring(args[2]:match("@?(%d+)")))
			tfm.exec.chatMessage(format('Map %s.', '@'..tostring(args[2]:match("@?(%d+)"))), name)
		elseif args[1]=="npp" and args[2] and args[2]:match("@?%d+") then
			next_map = '@'..tostring(args[2]:match("@?(%d+)"))
			tfm.exec.chatMessage(format('Next map %s.', next_map), name)
		else
			continue = true
		end
		if not continue then return end
	end
	if args[1]:match('help') then
		help(name)
	elseif args[1]:match('^controls?%d?') then
		local id = tonumber(args[2] or args[1]:match('controls?(%d?)'))
		if not id then
			id = players[name].controls==1 and 2 or 1
		end
		if not inTable({1,2}, id) then
			return tfm.exec.chatMessage(translate('chelp', name), name)
		end
		players[name].controls = id
		tfm.exec.chatMessage(T[players[name].com].confirm[id], name)
		local settings = {
			{wantstoshoot=false,spawnCount=nil,releaseCount=nil},
			{wantstoshoot=nil,spawnCount=0,releaseCount=0},
		}
		for k,v in pairs(settings[id]) do
			players[name][k] = v
		end
	elseif args[1]:match('^profile?') or args[1]=='p' then
		local player = find_one_player(args[2], name) or name
		profile(player, name)
	elseif args[1]:match('^lang$') and args[2] then
		if T[args[2]:lower()] then
			players[name].com = args[2]:lower()
			tfm.exec.chatMessage('Language set.', name)
		else
			tfm.exec.chatMessage('Not supported yet.', name)
		end
	else
		tfm.exec.chatMessage(translate('error.command', name), name)
	end
end

function eventKeyboard(name, key, down, x, y)
	if not players[name] then return end
	if x and y then
		tfm.get.room.playerList[name].x, tfm.get.room.playerList[name].y = x, y
	end
	if duel.duel and (key==LEFTKEY or key==RIGHTKEY) then
		tfm.exec.killPlayer(name)
	end
	local player = players[name]
	if player.isAfk then player.isAfk = false end
	if key==SHIFT and down then
		local _skins = {'snow', 'fraises'}
		player.skin = _skins[table.indexOf(_skins, player.skin)%#_skins+1]
		tfm.exec.chatMessage(translate(player.skin, name), name)
	end
	if key==80 then
		if player.interfaces.profile then
			ui.removeBox(idProfile, name)
			ui.removeBox(idProfileName, name)
			for i=idExpBg,idExpTxt do
				ui.removeTextArea(i, name)
			end
			player.interfaces.profile = false
		else
			profile(name, name)
		end
	elseif key==72 then
		if player.interfaces.help then
			ui.removeTabArea(idHelp, name)
			player.interfaces.help = false
		else
			help(name)
		end
	elseif not player.isDead then
		if inTable({RIGHTKEY, LEFTKEY}, key) then
			player.looksRight = RIGHTKEY==key
		end
		if player.mustshake then
			tfm.exec.playEmote(name, SHAKE)
		end
		if player.controls==1 then
			if key==SPACE and SNOW then
				if down then
					player.times[1] = os.time()
					player.times[2] = 0
					player.mustshake = true
					tfm.exec.playEmote(name, SHAKE)
					return
				end
				local times = player.times
				if times[2]==-1 then return end
				times[2] = os.time()
				if times[1]==nil then
					times[1] = times[2]
				end
				player.speed = FACTORP*os.difftime(times[2], times[1])/1000
				player.speed = player.speed>25 and 25 or player.speed
				player.dir = (player.looksRight and 1 or -1)
				player.off = player.dir*25
				if player.speed > PARAMETERP then
					if COUNT==5 then
						tfm.exec.addShamanObject(1003, x+player.off, y-5, 0, player.dir*player.speed, 0, false)
					else
						for _=1,COUNT do
							local id = tfm.exec.addShamanObject(SPAWNP, x+player.off, y-5, 0, player.dir*player.speed, 0, false)
							if player.skin~='snow' then
								tfm.exec.addImage(skins[player.skin], "#"..tostring(id), skins[player.skin].xoff, skins[player.skin].yoff)
							end
						end
					end
					times[2] = -1
				end
				player.mustshake = false
			end
		elseif player.controls==2 and SNOW then
			if key==SPACE then
				local times = player.times
				if down then
					if not player.spawnCount then player.spawnCount = -1 end
					player.spawnCount = player.spawnCount +1
					if not player.wantstoshoot and player.spawnCount==1 then
						player.wantstoshoot = true
						player.spawnCount = -1
						player.mustshake = true
						times[1] = os.time()
						times[2] = 0
						tfm.exec.playEmote(name, SHAKE)
					end
					return
				end
				player.releaseCount = player.releaseCount +1
				if player.wantstoshoot and player.releaseCount==2 then
					if times[2]==-1 then return end
					times[2] = os.time()
					if times[1]==nil then
						times[1] = times[2]
					end
					player.speed = FACTORP*os.difftime(times[2],times[1])/1000
					player.speed = player.speed>25 and 25 or player.speed
					player.dir = (player.looksRight and 1 or -1)
					player.off = player.dir*25
					if player.speed > PARAMETERP then
						for _=1,COUNT do
							local id = tfm.exec.addShamanObject(SPAWNP, x+player.off, y-5, 0, player.dir*player.speed, 0, false)
							if player.skin~='snow' then
								tfm.exec.addImage(skins[player.skin], "#"..tostring(id), skins[player.skin].xoff, skins[player.skin].yoff)
							end
						end
						times[2] = -1
					end
					player.mustshake = false
					player.releaseCount = 0
					player.wantstoshoot = false
				end
			end
		end
	end
end

function eventTextAreaCallback(_, name, callback)
	if callback:sub(0,5)=="debug" then
		local args = {}
		for a in callback:sub(7):gmatch("%S+") do
			table.insert(args, a)
		end
		if args[1]=="print" then
			debug:print((args[2] and args[2]~="") and tonumber(args[2]) or 1)
		elseif args[1]=="explorer" then
			local page = 1
			local path = "_G"
			local tbl = _G
			if args[2] and args[2]:match("%d+") then
				page = tonumber(args[2])
			end
			if #args>2 and args[3]~="" then
				path = table.concat(args, " ", 3)
			end
			for t in path:gmatch("%S+") do
				tbl = tbl[t:match("^NUMBER:%d+$") and tonumber(t:match("%d+")) or t]
			end
			debug:explorer(tbl, path, page)
		end
		return
	end
	local args = split(callback, '$')
	if args[1]=='call' then
		local sub = {}
		local func = args[2]:find('.') and getTable(string.split(args[2], '.')) or _G[args[2]]
		if not func then error('The function "'..args[2]..'" do not exists.') end
		for i=3, #args do
			if args[i]=="n" then
				table.insert(sub, name)
			elseif args[i]:sub(0,1)=="N" and args[i]:sub(2):match('%d+') then
				table.insert(sub, tonumber(args[i]:sub(2)))
			else
				table.insert(sub, args[i])
			end
		end
		func(table.unpack(sub))
	elseif args[1]=='safe' then
		if args[2]=='errors' then
			local txt = {'<font face="Lucida Console"><p align="center"><font color="#FF1212" size="16">Please take a screen of this list and send it to Athesdrake#0000.</font></p>'}
			for _, err in ipairs(_errors) do
				table.insert(txt, format('<v>[•] Line</v> <g>%d</g><v>:</v> <r>%s</r>\n\t<v>Traceback:</v> <j>%s</j>\n\t<v>Args:</v> <g>%s</g>', err.line, err.error, err.traceback, err.sargs))
			end
			ui.addBox(idErrList, table.concat(txt, '\n'), name, 100, 50, 600, 300)
			ui.addButton(idErrList, format('<p align="center"><a href="event:call$ui.removeBox$N%d$n">Close</a></p>', idErrList), name, 125, 325, 550)
		end
	end
end

function eventWin(name)
	for pl in pairs(players) do
		tfm.exec.chatMessage(string.formatting(translate('win1', pl), {name=name}), pl)
	end
	players[name].color = players[name].color +1
	-- players[name].stats.wins = players[name].stats.wins +1 -- Not here, bc the pl do not win if he die
	SNOW = false
	STORM = true
	tfm.exec.setGameTime(5)
	reject_after('start')
end

function team_game()
	local win = 'tie'
	if teams.teams then
		if #teams.green.playerList==0 or #teams.yellow.playerList==0 then
			win = 'win'
		end
	end
	return teams.teams, win
end

function help(name, tab)
	if not tab then tab = 1 end
	local h, tabs, keys = translate('HELP', name), {}, {}
	players[name].interfaces.help = true
	for tabName in pairs(h) do
		table.insert(tabs, string.format('<a href="event:call$help$n$N%d">%s</a>', #tabs+1, tabName))
		table.insert(keys, tabName)
	end
	ui.addTabArea(idHelp, h[keys[tab]], name, 200, 100, 400, 200, tabs, tab, format("<p align='center'><a href='event:call$eventKeyboard$n$N72'>%s", translate("close", name)))
end

function profile(pr2show, name)
	players[name].interfaces.profile = true
	-- addExp(name, 5) -- #NOT-TODO: Remove this easy way to get exp. Ehe it's done
	local txt, stats = ("\n"):rep(4)..format("<p align='center'><b>Lvl <j>%d</j></b></p>", players[pr2show].stats.lvl)..("\n"):rep(2), players[pr2show].stats -- TODO ↓
	for _,v in pairs({"snowballThrown", "mapPlayed", "wins", "loses", {pr="ratio", st=(stats.wins/stats.mapPlayed)*100}}) do
		if type(v)=='string' then
			txt = txt..format(translate('profile', name)[v], stats[v]).."\n"
		else
			txt = txt..format(translate('profile', name)[v.pr], v.st).."\n"
		end
	end
	ui.addBox(idProfile, txt, name, 300, 75, 200, 250)
	ui.addBox(idProfileName, format("<p align='center'><font size='20'><v>%s", pr2show), name, 275, 75, 250, 50)
	ui.addTextArea(idExpBgBorder, "", name, 325, 155, 150, 10, nil, nil, 1, true)
	ui.addTextArea(idExpBg, "", name, 326, 156, 148, 8, 0x324650, 0x324650, 1, true)
	if players[pr2show].stats.xp~=0 then ui.addTextArea(idExpFg, "", name, 326, 156, (players[pr2show].stats.xp/getExpLvl(players[pr2show].stats.lvl))*148, 8, 0x07CECE, 0x07CECE, 1, true) end
	ui.addTextArea(idExpTxt, format("<p align='center'><font color='#0'>%d/%d", players[pr2show].stats.xp, getExpLvl(players[pr2show].stats.lvl)), name, 325, 151, 150, 0, 0x0, 0x0, 0, true)
	ui.addButton(idProfile, format("<p align='center'><a href='event:call$eventKeyboard$n$N80'>%s", translate("close", name)), name, 315, 300, 170)
end

function new_map()
	local temp_map
	math.randomseed(os.time())
	repeat
		temp_map = maps.normal[math.random(#maps.normal)]
	until temp_map~=map
	map = temp_map
	if math.random()<=.15 and players:len()>=4 then -- 20% --#TODO
		print('Team')
		teams.teams = true
		local yellow = teams.yellow
		local i = 0
		local t = shuffle({green, yellow})
		green.alives = 0
		green.color = 0x00ff00
		green.playerList = {}
		yellow.alives = 0
		yellow.color = 0xffff00
		yellow.playerList = {}

		for pl in pairs(players:playing()) do
			i = i +1
			local team = t[i%2+1]
			table.insert(team.playerList, pl)
		end
	elseif mapCount~=0 and mapCount%10==0 and players:len()>=2 and false then
		duel.duel = true
		print("C'est l'heure dududududu DUEEEL !")
		local bests, getPl = {{'dummyplayer', -1},{'dummyplayer', -1}}, tfm.get.room.playerList
		for pl in pairs(players:playing()) do
			local score = getPl[pl].score
			if score>bests[1][2] then
				bests[1], bests[2] = {pl, score}, bests[1]
			elseif score>=bests[2][2] then
				bests[2] = {pl, score}
			end
		end
		duel.players = bests
		temp_map = format([[<C><P F="%d" /><Z><S><S L="800" X="400" H="50" N="" Y="375" T="6" P="0,0,0.3,0.2,0,0,0,0" /></S><D><P X="161" Y="350" T="1" P="0,0" /><P X="186" Y="350" T="0" P="0,0" /><P X="140" Y="350" T="3" P="0,1" /><P X="594" Y="391" T="87" P="0,0" /><P X="599" Y="351" T="0" P="0,0" /><P X="554" Y="350" T="3" P="0,0" /><P X="340" Y="351" T="4" P="0,0" /><P P="1,1" Y="351" T="0" X="329" /></D><O /></Z></C>]],math.random(5))
	else
		teams.teams = false
		duel.duel = false
		table.foreach(players:playing(), function(_,d) d.team = nil end)
	end
	tfm.exec.newGame(temp_map)
end

function snowstorm()
	local xs = math.rand_neg(0.1,5)
	for _=1,math.random(50,100) do
		local x = math.random(800)
		local y = math.random(300)
		local xs = xs + math.rand_neg()
		local ys = math.random(2,7)
		local xa = math.rand_neg(0.1,0.5)
		local ya = math.rand_neg(0.1,0.5)
		for pl, data in pairs(players) do
			if data.settings.storm then
				tfm.exec.displayParticle(0, x, y, xs, ys, xa, ya, pl)
			end
		end
	end
end

function find_player(name)
	local pseudo, hash = name:match('([a-zA-Z_0-9]+)#?(%d*)')
	pseudo = capitalize(pseudo)
	if type(hash)=='string' then
		hash = tonumber(hash)
	end
	local suggestions = {}
	for n, pl in pairs(players) do
		if pl.pseudo==pseudo then
			if pl.hash==hash then
				return {n}
			end
			table.insert(suggestions, n)
		end
	end
	return suggestions
end

function find_one_player(player)
	local suggestions = find_player(player)
	if #suggestions==0 then
		tfm.exec.chatMessage(format("The player '%s' was not found.", player), name)
	elseif #suggestions==1 then
		return suggestions[1]
	elseif #suggestions>1 then
		tfm.exec.chatMessage(format("More than one player found, please choose between: %s", table.concat(suggestions, ', ')), name)
	end
	return false
end

function translate(msg, name)
	local pos = T[T[name] and name or players[name].com]
	for _,k in pairs(split(msg, '.')) do
		pos = pos[k]
		if not pos then
			translate(msg, 'en')
		end
	end
	return pos
end

function addExp(name, amount)
	players[name].stats.xp = players[name].stats.xp + amount
	local lvl, xp    = players[name].stats.lvl, players[name].stats.xp
	if getExpLvl(lvl)<=xp then
		players[name].stats.xp  = xp  -getExpLvl(lvl)
		players[name].stats.lvl = lvl +1
		addExp(name, 0)
	end
end

function getExpLvl(lvl)
	if not lvl then
		return
	end
	local factors = {{4.5,-162.5,2220},{2.5,-40.5,360},{1,6,0}}
	local slice = factors[lvl<17 and 3 or (lvl<32 and 2 or 1)]
	return math.ceil((slice[1] * lvl^2 +slice[2] * lvl + slice[3] )/10)*10
end

function after(temps, func, args, info) -- Exec a function after the given time
	table.insert(aft, {t=os.time()+temps*1000, f=func, args=args, info=info})
end

function reject_after(info)
	for i,t in ipairs(aft) do
		if t.info==info then
			table.remove(aft, i)
			break
		end
	end
end

--[[ DEBUG SYSTEM ]]--
do
	_print = print
	function print(...)
		if not print_debug then print_debug = {} end
		local txt = ""
		for _,v in next, {...} do
			txt = txt.." "..tostring(v)
		end
		table.insert(print_debug, {time=os.time(), txt=txt})
		_print(txt)
	end

	debug     = {}
	d         = {}
	d.__index = d

	function d.__call()
		local txt      = "<a href='event:debug print 1'>Debug Print</a>\n\n<a href='event:debug explorer 1'>Lua Explorer</a>"--\n\n<a href='event:debug saveFile'>Update a saved file</a>"
		d.id_debug  = -1
		d.id_prev   = -3
		d.id_next   = -4
		d.id_return = -5
		d.id_path   = -6
		d.id_select = -7
		ui.addTextArea(d.id_debug, txt, "Athesdrake#0000", -254, 0, 250, 400, nil, 0x1, 0.25, true)
	end

	function d:print(page)
		local pages    = {}
		local current  = 0
		local counter  = 3000
		ui.removeTextArea(-3);ui.removeTextArea(-4)

		for _,v in pairs(print_debug) do
			local temp = os.date("[%H:%M] ", v.time)..v.txt.."\n"
			if counter+#temp>2000 then
				counter = 0
				current = current +1
				pages[current] = ""
			end
			pages[current] = pages[current]..temp
		end
		ui.addTextArea(self.id_debug, pages[page or 1], "Athesdrake#0000", -254, 0, 250, 400, nil, 0x1, 0.25, true)
		if page>1 then
			ui.addTextArea(self.id_prev, format("<a href='event:debug print %d'>&lt;</a>", page-1), "Athesdrake#0000", -254, 405, 30, 20, 0x1, nil, 0.25, true)
		end
		if #pages>page then
			ui.addTextArea(self.id_next, format("<a href='event:debug print %d'>&gt;</a>", page-1), "Athesdrake#0000", -34 , 405, 20, 20, 0x1, nil, 0.25, true)
		end
	end

	function d:explorer(tbl, path, page)
		local char = string.char
		local pages       = {}
		local current     = 0
		local counter     = 3000
		local path_linked = ""
		local path_       = ""

		ui.removeTextArea(-3)
		ui.removeTextArea(-4)

		for k,v in pairs(tbl) do
			local value = tostring(v):gsub("<", "&lt;")
			for i=0, 10 do
				value   = value:gsub(char(i), format("\\%d", i))
			end
			if type(v)=="table" then
				value   = format("<a href='event:debug explorer %d %s %s'><fc>%s</fc></a>", 1, path, type(k)=="string" and k or format("NUMBER:%d", k), value)
			end
			local temp  = tostring(k):gsub("<", "&lt;").." = "..(#value>=2000 and value:sub(0,50).." <r>ERROR SIZE !</r>" or value).."\n"
			if counter+#temp>=2000 then
				current        = current +1
				counter        = 0
				pages[current] = ""
			end
			pages[current] = pages[current]..temp
			counter = #pages[current]
		end

		for t in path:gmatch("%S+") do
			path_       = path_.." "..t
			path_linked = path_linked..format("<a href='event:debug explorer 1 %s'>%s</a>.", path_, t)
		end
		path_linked = path_linked:sub(0,-2)

		ui.addTextArea(self.id_debug, pages[page or 1], "Athesdrake#0000", -254, 0  , 250, 400, nil, 0x1, 0.25, true)
		ui.addTextArea(self.id_path , path_linked     , "Athesdrake#0000", -254, -28, 250, 20 , nil, 0x1, 0.25, true)
		if page>1 then
			ui.addTextArea(self.id_prev, format("<a href='event:debug explorer %d %s'>&lt;</a>", page-1, path), "Athesdrake#0000", -254, 408, 20, 20, 0x1, nil, 0.25, true)
		end
		if #pages>page then
			ui.addTextArea(self.id_next, format("<a href='event:debug explorer %d %s'>&gt;</a>", page+1, path), "Athesdrake#0000", -24 , 408, 20, 20, 0x1, nil, 0.25, true)
		end
	end

	setmetatable(debug, d)
end
--[[  End Debug   ]]--

--[[ JSON PARSER ]]--
do
	json = {}

	function json.kind_of(obj)
		if type(obj) ~= 'table' then return type(obj) end
		local i = 1
		for _ in pairs(obj) do
			if obj[i] ~= nil then i = i + 1 else return 'table' end
		end
		if i == 1 then return 'table' else return 'array' end
	end

	function json.escape_str(s)
		local in_char  = {'\\', '"', '/', '\b', '\f', '\n', '\r', '\t'}
		local out_char = {'\\', '"', '/',  'b',  'f',  'n',  'r',  't'}
		for i, c in ipairs(in_char) do
			s = s:gsub(c, '\\' .. out_char[i])
		end
		return s
	end

	function json.skip_delim(str, pos, delim, err_if_missing)
		pos = pos + #str:match('^%s*', pos)
		if str:sub(pos, pos) ~= delim then
			if err_if_missing then
				error('Expected ' .. delim .. ' near position ' .. pos)
			end
			return pos, false
		end
		return pos + 1, true
	end

	function json.parse_str_val(str, pos, val)
		val = val or ''
		local early_end_error = 'End of input found while parsing string.'
		if pos > #str then error(early_end_error) end
		local c = str:sub(pos, pos)
		if c == '"'  then return val, pos + 1 end
		if c ~= '\\' then return json.parse_str_val(str, pos + 1, val .. c) end
		local esc_map = {b = '\b', f = '\f', n = '\n', r = '\r', t = '\t'}
		local nextc = str:sub(pos + 1, pos + 1)
		if not nextc then error(early_end_error) end
		return json.parse_str_val(str, pos + 2, val .. (esc_map[nextc] or nextc))
	end

	function json.parse_num_val(str, pos)
		local num_str = str:match('^-?%d+%.?%d*[eE]?[+-]?%d*', pos)
		local val = tonumber(num_str)
		if not val then error('Error parsing number at position ' .. pos .. '.') end
		return val, pos + #num_str
	end

	function json.stringify(obj, as_key)
		local s = {}
		local kind = json.kind_of(obj)
		if kind == 'array' then
			if as_key then error('Can\'t encode array as key.') end
			s[#s + 1] = '['
			for i, val in ipairs(obj) do
				if i > 1 then s[#s + 1] = ', ' end
				s[#s + 1] = json.stringify(val)
			end
			s[#s + 1] = ']'
		elseif kind == 'table' then
			if as_key then error('Can\'t encode table as key.') end
			s[#s + 1] = '{'
			for k, v in pairs(obj) do
				if #s > 1 then s[#s + 1] = ', ' end
				s[#s + 1] = json.stringify(k, true)
				s[#s + 1] = ':'
				s[#s + 1] = json.stringify(v)
			end
			s[#s + 1] = '}'
		elseif kind == 'string' then
			return '"' .. json.escape_str(obj) .. '"'
		elseif kind == 'number' then
			if as_key then return '"' .. tostring(obj) .. '"' end
			return tostring(obj)
		elseif kind == 'boolean' then
			return tostring(obj)
		elseif kind == 'nil' then
			return 'null'
		else
			error('Unjsonifiable type: ' .. kind .. '.')
		end
		return table.concat(s)
	end

	json.null = {}

	function json.parse(str, pos, end_delim)
		pos = pos or 1
		if pos > #str then error('Reached unexpected end of input.') end
		pos = pos + #str:match('^%s*', pos)
		local first = str:sub(pos, pos)
		if first == '{' then
			local obj, key, delim_found = {}, true, true
			pos = pos + 1
			while true do
				key, pos = json.parse(str, pos, '}')
				if key == nil then return obj, pos end
				if not delim_found then error('Comma missing between object items.') end
				pos = json.skip_delim(str, pos, ':', true)
				obj[key], pos = json.parse(str, pos)
				pos, delim_found = json.skip_delim(str, pos, ',')
			end
		elseif first == '[' then
			local arr, val, delim_found = {}, true, true
			pos = pos + 1
			while true do
				val, pos = json.parse(str, pos, ']')
				if val == nil then return arr, pos end
				if not delim_found then error('Comma missing between array items.') end
				arr[#arr + 1] = val
				pos, delim_found = json.skip_delim(str, pos, ',')
			end
		elseif first == '"' then
			return json.parse_str_val(str, pos + 1)
		elseif first == '-' or first:match('%d') then
			return json.parse_num_val(str, pos)
		elseif first == end_delim then
			return nil, pos + 1
		else
			local literals = {['true'] = true, ['false'] = false, ['null'] = json.null}
			for lit_str, lit_val in pairs(literals) do
				local lit_end = pos + #lit_str - 1
				if str:sub(pos, lit_end) == lit_str then return lit_val, lit_end + 1 end
			end
			local pos_info_str = 'position ' .. pos .. ': ' .. str:sub(pos, pos + 10)
			error('Invalid json syntax starting at ' .. pos_info_str)
		end
	end
end
--[[     End     ]]--

ui.addTabArea = function(id, txt, name, x, y, width, height, tabs, active, closeBtn) -- Pops up a tabbed textArea
	if (not tabs) or #tabs==0 then print('No tabs provided');return end
	if not tabs[active] then print('Incorrect active tab');return end
	local tab_w, tab_h = width/#tabs, 30

	tab_w = tab_w - tab_w%5
	for k,v in pairs(tabs) do
		ui.addFillTextBox(id*1000+k, v, name, x+(k-1)*(tab_w-2), y, tab_w-8, tab_h, false)
	end
	ui.addFillTextBox(id*1000+active, '', name, x+(active-1)*(tab_w-2), y, tab_w-8, tab_h, false)

	ui.addBox(id*1000, '', name, x, y+tab_h, width, height, false)
	ui.addTextArea(id*1000+1, '', name, x+(active-1)*(tab_w-2)+4, y+21, tab_w-16, 5, 0x183337, 0x0C191C, 1, true)
	ui.addTextArea(id*1000+2, '', name, x+(active-1)*(tab_w-2)+6, y+18, tab_w-20, 10, 0x183337, 0x24474D, 1, true)
	ui.addTextArea(id*1000+3, '', name, x+(active-1)*(tab_w-2)+7, y+8, tab_w-22, height+15, 0x122528, 0x122528, 1, true)
	ui.addTextArea(id*1000+4, tabs[active], name, x+(active-1)*(tab_w-2)+8, y+8, tab_w-8, tab_h, 0x0, 0x0, 0, true)

	ui.addTextArea(id, txt, name, x+5, y+tab_h+2, width-10, height-4, 0x0, 0x0, 0, true)
	ui.addButton(id, closeBtn or format("<p align='center'><a href='event:call$ui.removeTabArea$N%d$n'>%s</a></p>", id, translate('close', name)), name, x+25, y+height+tab_h-30, width-50)
end

ui.addOldStyleTabArea = function(id, txt, name, x, y, width, height, tabs, active)
	if (not tabs) or #tabs==0 then print('No tabs provided');return end
	if not tabs[active] then print('Incorrect active tab');return end
	local tab_w, tab_h = width/#tabs, 30
	local ACTIVE   = 0x324650
	local UNACTIVE = 0x2B373D
	tab_w = tab_w - tab_w%5
	for k,v in pairs(tabs) do
		ui.addTextArea(id*1000+k, v, name, x+(k-1)*tab_w, y, tab_w-8, tab_h, UNACTIVE, nil, 1, true)
	end
	ui.addTextArea(id*1000+#tabs+1, '', name, x, y+tab_h, width, height, ACTIVE, nil, 1, true)
	ui.addTextArea(id*1000+active, tabs[active], name, x+(active-1)*tab_w, y, tab_w-8, tab_h, ACTIVE, nil, 1, true)
	ui.addTextArea(id*1000, '', name, x+2, y+tab_h+2, width-4, nil, ACTIVE, ACTIVE, 1, true)
	ui.addTextArea(id, txt, name, x, y+tab_h, width, height, 0x0, 0x0, 0, true)
	ui.addButton(id, format("<p align='center'><a href='event:call$ui.removeTabArea$N%d$n'>%s</a></p>", id, translate('close', name)), name, x+25, y+height+tab_h-20, width-50)
end

ui.addBox = function(id, txt, name, x, y, width, height, border) -- A beautiful TextArea
	txt    = txt    or ""
	x      = x      or 100
	y      = y      or 100
	height = height or 200
	width  = width  or 200
	border = border==nil or border

	local n = 0
	local display = function(w, clr, opacity)
		ui.addTextArea(id*100+n," ", name, x+w, y+w, width-2*w, height-2*w, clr, clr, opacity or 1, true)
		n = n +1
	end
	if border then
		display(0, 0x2D211A, 0.8)
	end
	display(1, 0x986742)
	display(4, 0x171311)
	display(5, 0x0C191C)
	display(6, 0x24474D)
	display(7, 0x183337)
	ui.addTextArea(id, txt, name, x+8, y+8, width-16, height-16, 0x122528, 0x122528, 1, true)
end

ui.addFillTextBox = function(id, txt, name, x, y, width, height, border) -- A ui.addBox that take all space available for the text
	ui.addBox(id, '', name, x, y, width, height, border)
	ui.addTextArea(id*100+6, txt, name, x+6, y+6, width-12, height-12, 0x0, 0x0, 0, true)
end

ui.addButton = function(id, txt, name, x, y, width) -- A simple button
	txt    = txt    or ""
	x      = x      or 100
	y      = y      or 100
	width  = width  or 200
	ui.addTextArea(id*100+8 , " ", name, x-1, y-1, width-1, 11, 0x5D7D90, 0x5D7D90, 1, true)
	ui.addTextArea(id*100+9 , " ", name, x+1, y+1, width  , 12, 0x11171C, 0x11171C, 1, true)
	ui.addTextArea(id*100+10, " ", name, x  , y  , width  , 12, 0x3C5064, 0x3C5064, 1, true)
	ui.addTextArea(id*100+11, txt, name, x  , y-3, width  , 20, 0x0, 0x0, 0, true)
end

ui.removeTabArea = function(id, name)
	ui.removeTextArea(id, name)
	for i=0,20 do
		ui.removeBox(id*1000+i, name)
	end
	ui.removeButton(id, name)
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
		for i=id*100+8, id*100+11 do
			ui.removeTextArea(i, name)
		end
	end
end

function sendMessage(msg)
	for pl,data in pairs(players) do
		if type(msg)=='string' then
			tfm.exec.chatMessage(translate(msg, pl), pl)
		elseif type(msg)=='function' then
			tfm.exec.chatMessage(msg(T[data.com]), pl)
		end
	end
end

--[[  Safe  ]]-- #TODO: Set debug to false after debugging !
_errors = {debug=false} -- The_errors tablekeep track of the errors
-- debug=true: All the errors are passed to the eventError
-- debug=false: The errors are passed once to the eventError
function safe(func, name) -- Return a new function that wrap the given one
	-- The name parameter is used for the traceback
	if func==safe or func==eventError then
		return func -- safe and eventError must be unsafe
	end
	local regex = "^(.-)%.lua:(%d+): (.+)$" -- Match 'ScriptLoader.lua: line: error_message'
	return function(...)
		local result = {pcall(func,...)}
		if not table.remove(result, 1) then -- If an error occurred
			-- First parse the error message
			local parser = function(err, sargs, args) -- The default Parser
				if type(err)~='string' then
					return '<R>CRITICAL: An undefined error has occurred</R>'
				end
				local match = {err:match(regex)}
				if #match<3 then -- If it is an error made by the function error(...)
					return string.format('<R>%s</R> Args: %s', err, sargs)
				end
				if name then
					table.insert(match, name)
				else
					table.insert(match, '#Not#specified#')
				end
				table.insert(match, sargs)
				if (not table.match(_errors, function(_,err)
					return err.line==match[2]
				end)) or _errors.debug then
					table.insert(_errors, {
						args      = args,
						sargs     = sargs,
						loader    = match[1],
						line      = match[2],
						error     = match[3],
						traceback = match[4],
					})
					return _errors[#_errors]
				end
			end
			-- If the eventError function exist, it will handle the errors
			local eventError = eventError or function(error)
				-- Be careful the error can be a string
				if type(error)=="string" then
					print(error)
				elseif error then
					print(string.format('<V>[%s]</V> Line %d: <R>%s</R>\nTraceback: %s Args: %s', error.loader, error.line, error.error, error.traceback, error.sargs))

					ui.addButton(idErrors, '<a href="event:safe$errors">Errors</a>', nil, 700, 385, 75)
					ui.addTextArea(idNumErrorsBg, '', nil, 765, 389, 0, 0, 0xff0000, 0xff0000, 1, true)
					ui.addTextArea(idNumErrors, #_errors, nil, 762, 382, 0, 0, 0x0, 0x0, 0, true)
				end
			end
			local lastK, args = 0, {}
			for k,v in pairs({...}) do
				for _=2, k-lastK do
					table.insert(args, 'nil')
				end
				lastK = k
				table.insert(args, string.format((type(v)=='string' and "'%s'" or '%s'), tostring(v)))
			end
			local error = parser(result[1], table.concat(args, ', '), {...})
			eventError(error)
		else -- Else return the result
			return table.unpack(result)
		end
	end
end

function safeEvent() -- Make them all safe
	for k,v in pairs(_G) do
		if k:match('^event') and k~='eventError' then -- eventError need to be unsafe !!
			_G[k] = safe(v, k)
		end
	end
end
--[[  Safe  ]]--

if tfm.get.room.name:match'^*\3' then
	tfm.exec.chatMessage = function( ... )
		args = {...}
		ui.addTextArea(-5, args[1] or '', args[2], 0, 375, nil, nil, nil, nil, 1, true)
		print('tfm.exec.chatMessage: ', unpack(args))
		after(args[1] and (#args[1]/(#split(args[1], ' ')*4)) or 1, function() ui.removeTextArea(-5, args[2]) end)
	end
end

main()