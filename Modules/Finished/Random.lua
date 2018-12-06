function main()
	--vars:
		version = "1.0"
		format = string.format
	--tables:
		players   = {}
		countries = {"AF", "ZA", "AX", "AL", "DZ", "DE", "DD", "AD", "AO", "AI", "AQ", "AG", "AN", "SA", "AR", "AM", "AW", "AU", "AT", "AZ", "BS", "BH", "BD", "BB", "BY", "BE", "BZ", "BJ", "BM", "BT", "BO", "BQ", "BA", "BW", "BV", "BR", "BN", "BG", "BF", "BI", "CV", "KY", "KH", "CM", "CA", "CL", "CN", "CX", "CY", "CC", "CO", "KM", "CG", "CD", "CK", "KR", "KP", "CR", "CI", "HR", "CU", "CW", "DK", "DJ", "DO", "DM", "EG", "SV", "AE", "EC", "ER", "ES", "EE", "US", "ET", "FK", "FO", "FJ", "FI", "FR", "GA", "GM", "GE", "GS", "GH", "GI", "GR", "GD", "GL", "GP", "GU", "GT", "GG", "GN", "GW", "GQ", "GY", "GF", "HT", "HM", "HN", "HK", "HU", "IM", "UM", "VG", "VI", "IN", "IO", "ID", "IR", "IQ", "IE", "IS", "IL", "IT", "JM", "JP", "JE", "JO", "KZ", "KE", "KG", "KI", "KW", "LA", "LS", "LV", "LB", "LR", "LY", "LI", "LT", "LU", "MO", "MK", "MG", "MY", "MW", "MV", "ML", "MT", "MP", "MA", "MH", "MQ", "MU", "MR", "YT", "MX", "FM", "MD", "MC", "MN", "ME", "MS", "MZ", "MM", "NA", "NR", "NP", "NI", "NE", "NG", "NU", "NF", "NO", "NC", "NZ", "OM", "UG", "UZ", "PK", "PW", "PS", "PA", "PG", "PY", "NL", "XX", "ZZ", "PE", "PH", "PN", "PL", "PF", "PR", "PT", "QA", "SY", "CF", "RE", "RO", "GB", "RU", "RW", "EH", "BL", "KN", "SM", "MF", "SX", "PM", "VA", "VC", "SH", "LC", "SB", "WS", "AS", "ST", "SN", "RS", "SC", "SL", "SG", "SK", "SI", "SO", "SD", "SS", "LK", "SE", "CH", "SR", "SJ", "SZ", "TJ", "TW", "TZ", "TD", "CS", "CZ", "TF", "TH", "TL", "TG", "TK", "TO", "TT", "TN", "TM", "TC", "TR", "TV", "UA", "SU", "UY", "VU", "VE", "VN", "VD", "WF", "YE", "YU", "ZR", "ZM", "ZW"}
		aft = {}
	--sytème:
		table.foreach({"AutoNewGame", "AutoShaman", "AutoTimeLeft", "MortCommand", "DebugCommand"}, function(_,v) tfm.exec["disable"..v](true) end) -- disable
		table.foreach(tfm.get.room.playerList, function(pl) eventNewPlayer(pl) end)
		newMap()
end

function eventNewPlayer(name)
	players[name] = {afk=true}
	table.foreach({0,1,2,3}, function(_,key) system.bindKeyboard(name, key, true, true) end)
	ui.setMapName(format("Random V%s <g>|</g> <n>Module créé par</n> <b><v>Athesdrake#0000</v></b>", version))
end

function eventPlayerDied(name)
	players[name].afk = true
	if playerLeft()==0 then
		tfm.exec.setGameTime(1)
	elseif playerLeft()==1 then
		tfm.exec.setGameTime(10)
	elseif playerLeft()==2 then
		tfm.exec.setGameTime(20)
	end
end

eventPlayerWon = eventPlayerDied

function eventNewGame()
	for pl, data in pairs(players) do
		data.afk = true
		after(3, function() tfm.exec.playEmote(pl, 6) end)
	end
end

function newMap()
	local canvas = '<C><P G="0,0" /><Z><S><S L="10" o="324650" H="400" X="-5" Y="200" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S P="0,0,0.3,0.2,0,0,0,0" L="10" o="324650" X="805" Y="200" T="12" H="400" /><S L="820" o="324650" X="400" H="10" Y="-5" T="12" P="0,0,0.3,0.2,0,0,0,0" /><S P="0,0,0.3,0.2,0,0,0,0" L="820" o="324650" H="10" Y="405" T="12" X="400" /></S><D><T Y="%d" X="%d" /><F Y="%d" X="%d" /><DS Y="%d" X="%d" /></D><O /></Z></C>'
	tfm.exec.newGame(canvas:format(math.random(50,350), math.random(50,750), math.random(50,350), math.random(50,750), math.random(50,350), math.random(50,750)))
end

function playerLeft()
	local alive = {}
	table.foreach(tfm.get.room.playerList, function(k,v) if not v.isDead then table.insert(alive, k) end end)
	return #alive
end

function after(temps, func) -- Exec a function after the given time
	table.insert(aft, {t=os.time()+temps*1000, f=func})
end

function math.rand_negative(...) -- Return a random negative or positive number with the given args
	return (math.random()>0.5 and 1 or -1)*math.random(table.unpack({...}))
end

function eventKeyboard(name, key, down, x, y)
	players[name].afk = false
end

function eventLoop(t1, t2)
	if t2<=0 then
		newMap()
	end
	for key,data in ipairs(aft) do
		if data.t<=os.time() then
			data.f()
			table.remove(aft, key)
		end
	end
	for pl, data in pairs(tfm.get.room.playerList) do
		if not players[pl].afk and not (t2<=500) then
			tfm.exec.movePlayer(pl, 0, 0, true, math.rand_negative(50, 100), math.rand_negative(50, 100), false)
			tfm.exec.playEmote(pl, math.random(35), countries[math.random(#countries)])
			tfm.exec.setNameColor(pl, math.random(0xffffff))
		end
	end
end

main()