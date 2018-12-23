-- Draw with joints on the map of your choice.
-- You can afterwards export your art with the current map's XML

function main()
	--vars:
		dessinateur = "Athesdrake#0000" -- A changer par votre pseudo ou par "all" pour tout le monde

		if not tfm.get.room.playerList[dessinateur or ''] then
			dessinateur = ({pcall(0)})[2]:match('^(.-).lua')
		end

		joints    = 0
		active    = true
		follow    = false
		code      = ""
		empty_map = '<C><P/><Z><S /><D /><O /><L>%s</L></Z></C>'
		canvas    = '<JD P1="%d,%d"P2="%d,%d"c="%x,%d,1,0"/>' -- x1, y1, x2, y2, color, line
		format    = string.format
		version   = "1.3"
	--tables:
		players    = {}
		joints_tbl = {}
	--sytème:
		tfm.exec.addPhysicObject(0, 0, 800, { miceCollision=false, groundCollision=false })
		tfm.exec.addJoint(-1, 0, 0, {type=0, point1="0,0", point2="1,0", line=1, color=0x1, alpha=0.1, foreground=false})
		table.foreach(tfm.get.room.playerList, function(pl) eventNewPlayer(pl) end)
		table.foreach({"AutoNewGame", "AutoShaman", "AutoTimeLeft", "AfkDeath", "DebugCommand"}, function(_,v) tfm.exec["disable"..v](true) end) -- disable
		if dessinateur=="all" then table.foreach(tfm.get.room.playerList, function(pl) system.bindMouse(pl, true) end); eventNewPlayer("all") end
		system.bindMouse(dessinateur, true)
end

function eventMouse(name, x, y)
	if players[name].last then
		draw(players[name].last, {x, y}, players[name].color, players[name].line)
		players[name].last = follow and {x,y} or nil
	else
		players[name].last = {x, y}
	end
	tools()
end

function eventNewGame()
	tfm.exec.addPhysicObject(0, 0, 800, { miceCollision=false, groundCollision=false })
	tfm.exec.addJoint(-1, 0, 0, {type=0, point1="0,0", point2="1,0", line=1, color=0x1, alpha=0.1, foreground=false})
end

eventPlayerDied = tfm.exec.respawnPlayer
eventPlayerWin  = tfm.exec.respawnPlayer

function eventNewPlayer(name)
	tfm.exec.respawnPlayer(name)
	players[name] = {color=math.random(0xffffff), line=3}
	tools()
	ui.setMapName(format("Draw V%s <g>|</g> <n>Module créé par</n> <b><v>Athesdrake#0000</v></b>", version))
end

function tools()
	local txt  = format("<a href='event:undo'>Undo</a> | <a href='event:clear'>Clear</a> | <a href='event:palette'>Palette</a> | <a href='event:thickness'>Changer l'épaisseur</a> | <a href='event:follow'>%s le suivi</a> | <a href='event:active'>%s</a> | <a href='event:gen_xml'>Générer l'XML</a>", follow and "Désactiver" or "Activer", active and "Désactiver" or "Activer")
	local txt2 = format("<%s>•", (players[dessinateur] and players[dessinateur].last) and "r" or "n")
	local txt3 = format("%d <a href='event:thick+'> + </a>|<a href='event:thick-'> - </a>", players[dessinateur] and players[dessinateur].line or 0)
	local name = dessinateur~="all" and dessinateur or nil
	ui.addTextArea(1, txt , name, 23, 30, nil, nil, nil, nil, 0.5, true)
	ui.addTextArea(2, txt2, name, 5 , 30, nil, nil, nil, nil, 0.5, true)
	ui.addTextArea(3, txt3, name, 5 , 55, nil, nil, nil, nil, 0.5, true)
end

function eventTextAreaCallback(id, name, call)
	if call=="undo" then
		tfm.exec.removeJoint(joints)
		for k,v in ipairs(joints_tbl) do
			if v.id==joints then
				table.remove(joints_tbl, k)
				break
			end
		end
		joints = joints-1<0 and 0 or joints-1
	end
	if call=="palette" then
		ui.showColorPicker(1, name, players[name].color, "Choisis une couleur")
	end
	if call=="active" then
		active = not active
		system.bindMouse(name, active)
	end
	if call=="clear" then
		for k,v in pairs(joints_tbl) do tfm.exec.removeJoint(v.id) end
		joints_tbl = {}
		joints = 0
	end
	if call=="thickness" then
		ui.addPopup(1, 2, "Saisis la taille du trait.", name, 200, 75, nil, true)
	end
	if call=="thick+" then
		players[name].line = players[name].line +5
	end
	if call=="thick-" then
		players[name].line = players[name].line -5
		if players[name].line<0 then
			players[name].line = 0
		end
	end
	if call=="follow" then
		follow = not follow
	end
	if call=="gen_xml" then
		generateXml()
	end
	tools()
end

function eventChatCommand(name, cmd)
	if cmd:match("np @?%d+") then
		tfm.exec.newGame("@"..cmd:match("%d+"))
	end
end

function eventPopupAnswer(id, name, ans)
	if ans:match("%d+") then
		players[name].line = tonumber(ans:match("%d+"))
		if players[name].line<0 then
			players[name].line = 0
		end
		tools()
	end
end

function eventColorPicked(id, name, color)
	if color==-1 then return end
	players[name].color = color
end

function draw(pos1, pos2, color, line)
	local def = {type=0, point1=table.concat(pos1, ","), point2=table.concat(pos2, ","), line=line, color=color, alpha=1, foreground=false}
	tfm.exec.addJoint(joints+1, 0, 0, def)
	table.insert(joints_tbl, {id=joints+1, p1=pos1, p2=pos2, line=line, color=color})
	joints = joints+1
end

function generateXml()
	local xml_info   = tfm.get.room.xmlMapInfo and tfm.get.room.currentMap==format("@%s", tostring(tfm.get.room.xmlMapInfo.mapCode))
	local xml        = (xml_info and tfm.get.room.xmlMapInfo.xml) or ""
	local joints_map = {}
	local current    = 0
	for k,data in ipairs(joints_tbl) do
		table.insert(joints_map, format(canvas, data.p1[1], data.p1[2], data.p2[1], data.p2[2], data.color, data.line))
	end
	if xml=="" then
		xml = empty_map:format(table.concat(joints_map, ""))
	else
		local index = xml:find("</L>")
		local xml_1 = xml:sub(0,index-1)
		local xml_2 = xml:sub(index)
		xml = xml_1..table.concat(joints_map, "")..xml_2
	end
	xml = xml:gsub("<", "\0")
	while #xml>current do current=current+3001
		print("<R>"..xml:sub(current-3000,current):gsub("\0", "&lt;"))
	end
	if #xml>2000 then
		print(format("\n<r><b>N'oubliez pas d'enlever tous les \"</b><ch>• [%s]</ch> <j>#</j> <v>[%s]</v> <b>\" !!</b></r>", os.date("%H:%M", os.time()), tfm.get.room.name))
	end
	if #xml>20000 then
		print("\n<r><b>Attention, le code xml généré dépasse la limite de caractères pour une map.\nVous ne pourrez donc ni charger ce code dans l'éditeur de map ni valider la map. La seule façon de charger ce code xml est d'utiliser en Lua: tfm.exec.newGame('ICI LE CODE XML')</b></r>")
	end
end

main()