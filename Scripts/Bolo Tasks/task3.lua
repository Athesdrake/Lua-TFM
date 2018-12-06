--[[
Create a small module that aims to replicate the powers of the game's staff positions.

   • Moderator - !ban Player to appear a black textarea on your screen and also kill it on all maps. !unban Player to undo the ban (effects of the !ban command)
   • Mapcrew - !np @map to place a map. Extra point for anyone making a !Npp @map (the current map will not be skipped) e !Ch Player (assign shaman in the next round)
   • Funcorp - !color Player to change the color of the player's nickname. 


- If a player has an X position, if he types !position_x Player , that player will have the position as well. Example: if a moderator type !Moderator Bolodefchoco#0000 , the player will be moderator. !mapcrew Player , !funcorp Player
- Extra point if you make a system so that souris can not be staff // ??
- Extra point for efficiency and optimization
]]

function main()
	local scriptloader = ({pcall(0)})[2]:match('^([^.]+)')
	moderator = {
		[scriptloader] = 1,
		['Bolodefchoco#0000'] = 1
	}
	mapcrew = {
		[scriptloader] = 1,
		['Bolodefchoco#0000'] = 1
	}
	funcorp = {
		[scriptloader] = 1,
		['Bolodefchoco#0000'] = 1
	}

	players = {}

	table.foreach(tfm.get.room.playerList, eventNewPlayer)

	tfm.exec.disableAutoNewGame(true)
	tfm.exec.newGame('#1')
end

function eventNewPlayer(name)
	players[name] = {ban=false}
end

function eventPlayerDied()
	local alives = 0
	for n, data in next, tfm.get.room.playerList do
		if not data.isDead then
			alives = alives +1
		end
	end
	if alives==1 then
		tfm.exec.setGameTime(10)
	elseif alives==0 then
		tfm.exec.setGameTime(1)
	end
end
eventPlayerWon = eventPlayerDied

function eventNewGame()
	if next_sham then
		tfm.exec.setShaman(next_sham)
		next_sham = nil
		tfm.exec.disableAutoShaman(false)
	end
	for name, pl in next, players do
		if pl.ban then
			tfm.exec.killPlayer(name)
			ui.addTextArea(-1, '', name, -10^3, -10^3, 10^6, 10^6, 0x1, 0x1, 1, true)
		end
	end
end

function eventLoop(t1, t2)
	if t2<0.1 then
		tfm.exec.newGame(next_map or '#1')
		next_map = nil
	end
end

function eventChatCommand(name, command)
	local args = {}
	for a in command:gmatch('%S+') do
		args[#args+1] = a
	end
	if moderator[name] then
		if args[1]=='ban' and args[2] and players[args[2]] then
			tfm.exec.killPlayer(args[2])
			ui.addTextArea(-1, '', args[2], -10^3, -10^3, 10^6, 10^6, 0x1, 0x1, 1, true)
			players[args[2]].ban = true
		elseif args[1]=='unban' and args[2] and players[args[2]] then
			ui.removeTextArea(-1)
			players[args[2]].ban = false
		elseif args[1]=='moderator' and moderator[name]==1 and args[2] and players[args[2]] then
			moderator[args[2]] = 2
		end
	end
	if mapcrew[name] then
		if args[1]=='np' and args[2] and args[2]:match('@%d+') then
			tfm.exec.newGame(args[2])
		elseif args[1]=='npp' and args[2] and args[2]:match('@%d+') then
			next_map = args[2]
		elseif args[1]=='ch' and args[2] and players[args[2]] then
			next_sham = args[2]
			tfm.exec.disableAutoShaman(true)
		elseif args[1]=='mapcrew' and mapcrew[name]==1 and args[2] and players[args[2]] then
			mapcrew[args[2]] = 2
		end
	end
	if funcorp[name] then
		if args[1]=='color' and args[2] and players[args[2]] then
			if not (args[3] and args[3]:match('%x+')) then
				args[3] = 'FF0000'
			end
			tfm.exec.setNameColor(args[2], tonumber(args[3], 16))
		elseif args[1]=='funcorp' and funcorp[name]==1 and args[2] and players[args[2]] then
			funcorp[args[2]] = 2
		end
	end
end

main()