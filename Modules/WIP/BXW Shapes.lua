function main()
	--vars:
		player = "PLAYERNAME" -- CHANGE THIS INTO YOUR PSEUDO
		map_code = [[<C><P /><Z><S><S c="4" L="800" o="ffffff" H="400" X="400" Y="200" T="12" P="0,0,0.3,0.2,0,0,0,0" /></S><D /><O /></Z></C>]]
	--ids:

	--tables:
		game = {} -- Main table
	--sytème:
		table.foreach(--disable
			{
				"AutoNewGame",
				"AutoShaman",
				"AutoTimeLeft",
				"AfkDeath",
				"MortCommand",
				"DebugCommand",
				"PhysicalConsumables"
			},
			function(_,v)
				tfm.exec["disable"..v](true)
			end
			)
		format = string.format
		tfm.exec.newGame(map_code)
end

function eventNewGame()
	if tfm.get.room.currentMap=="@0" then
		table.foreach(tfm.get.room.playerList, function(pl) tfm.exec.killPlayer(pl) end)
		game.shapes = {{type="square", x=0, y=0, dim={100,100}, show=false, color=0x1}, {type="square", x=0, y=0, dim={100,100}, show=false, color=0x1}, {type="square", x=0, y=0, dim={200,200}, show=false, color=0x1}}
		click("square", 1, 100, 100)
	end
end

function eventTextAreaCallback(id, name, callback)
	local arg = split(callback)
	if arg[1]=="shape" then
		if arg[2]=="square" then
			local id, x, y, side = map(tonumber, arg[3], arg[4], arg[5], arg[6], arg[7])
			local next_id = #game.shapes==id and 1 or id+1
			game.shapes[id].show = true
			game.shapes[id].x, game.shapes[id].y = x-side/2, y-side/2
			click(game.shapes[next_id].type, next_id, game.shapes[next_id].dim[1], game.shapes[next_id].dim[2])
			display()
		end
	elseif arg[1]=="call" then -- call a function with all the arguments given (ex: 'afunfunction$test$n$N35' → afunfunction('test', name, 35))
		local sub = {}
		for i=3, #arg do
			if arg[i]=="n" then -- convert the string into the player who clicked
				table.insert(sub, name)
			elseif arg[i]:sub(0,1)=="N" then -- convert the string into number
				sub[k] = tonumber(arg[i]:sub(2))
			end
			table.insert(sub, arg[i])
		end
		_G[arg[2]](table.unpack(sub))
	end
end

function display()
	for id, data in pairs(game.shapes) do
		if data.show then
			tfm.exec.addPhysicObject(id, data.x+data.dim[1]/2, data.y+data.dim[2]/2, {width = data.dim[1], height = data.dim[2], color=0x1, type=12})
		end
	end
	-- if not game.inter then
	-- 	game.inter = {}
	-- end
	local inter = {}
	for id1, data1 in pairs(game.shapes) do
		if data1.show then
			for id2, data2 in pairs(game.shapes) do
				if data2.show and data1.color==data2.color and id1~=id2 and collide(data1, data2) then
					local minX, maxX, minY, maxY = max(data1.x, data2.x), min(data1.x+data1.dim[1], data2.x+data2.dim[1]), max(data1.y, data2.y), min(data1.y+data1.dim[2], data2.y+data2.dim[2])
					table.insert(inter, {x=minX, y=minY, w=maxX-minX, h=maxY-minY, color=xor(data1.color, data2.color) and 0x1 or 0xffffff})
				end
			end
		end
	end
	for k,v in pairs(inter) do
		tfm.exec.addPhysicObject(100*k, v.x+v.w/2, v.y+v.h/2, {width = v.w, height = v.h, color = v.color, type = 12})
	end
end

function get_sides(data)
	local x, y, w, h = data.x, data.y, data.dim[1], data.dim[2]
	local sides = {
		{{x = x  , y = y  }, {x = x+w, y = y  }},
		{{x = x+w, y = y  }, {x = x+w, y = y+h}},
		{{x = x+w, y = y+h}, {x = x  , y = y+h}},
		{{x = x  , y = y+h}, {x = x  , y = y  }},
	}
	return sides
end

function click(shape, id, width, height)
	for x=50,525,25 do
		for y=50,350,25 do
			ui.addTextArea(100*x+y, format("<a href='event:shape$%s$%d$%d$%d$%d$%d'>•", shape, id, x, y, width, height), _, x-5, y-8, _, _, 0x0, 0x0)
		end
	end
end

function xor(a, b) -- XOR operation. (Same as bit32.bxor)
	return (a or b) and not (a and b)
end

function max(a,b)
	return a>b and a or b
end

function min(a,b)
	return a<b and a or b
end

function collide(a, b)
	-- print(format("%d, %d, %d, %d", a.x, a.x+a.dim[1], a.y, a.y+a.dim[2]))
	-- print(format("%d, %d, %d, %d", b.x, b.x+b.dim[1], b.y, b.y+b.dim[2]))
	return max(a.x, b.x)<min(a.x+a.dim[1], b.x+b.dim[1]) and max(a.y, b.y)<min(a.y+a.dim[2], b.y+b.dim[2])
end

function map(func, ...)
	local buffer = {}
	for k,v in ipairs({...}) do
		buffer[k] = func(v)
	end
	return table.unpack(buffer)
end

function string:split(sep) -- Split a string with a separator (default: '$'). (ex: 'test$1' → {'test', '1'})
	local sep, buffer = sep or "$", {}
	for element in self:gmatch("[^"..sep.."]+") do
		table.insert(buffer, element)
	end
	return buffer
end; split = string.split

main()