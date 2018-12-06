--[[
Task 7 - ★★ ☆
Calendar: 10/01/2018 - 10/08/2018

Recreate the room #bolodefchoco0map
Specification of colors:
   - It has red color
   - Cheese has yellow color
   - Shaman is blue color
   - Normal mice are white
Tip:
   - Play with more than one person
Extra points for:
   - Blue and pink shaman on maps P8, 32, etc. (all with more than one shaman)
   - Take the minimap on maps vanilla
   - Efficiency and optimization
]]

function main()
	categories = {0,1,4,5,6,7,8,9,17,32}
	dot_id = -1
	scale = 1/4
	off = {
		x = 800-(800*scale),
		y = 400-(400*scale)
	}

	tfm.exec.disableAutoNewGame(true)
	cat = categories[1]
	cati = 2
	tfm.exec.newGame('#'..cat)
end

--[==[--
	#==============================[=[ XML Parser ]=]==============================#
	|                                                                              |
	| It's not the best XML Parser, it does not retrieve the content of the tags:  |
	| 	"<Tag>Hi</Tag>" the parser ignore "Hi"                                     |
	| The parser can also break if the xml is invalid or if a parameter contains   |
	| the character ">". (fixed but not tested)                                    |
	|                                                                              |
	| But Transformice XML are valid, does not contains ">" in their parameters    |
	| and does not have content.                                                   |
	|                                                                              |
	#==============================================================================#
--]==]--
Tag = {}

Tag.__index = function(self, key)
	-- Return the methods
	local result = rawget(self, key) or Tag[key]
	if result then return result end

	-- If the method does not exists, return children
	return self.children[key]
end

Tag.__tostring = function(self)
	-- Do not forget to escape the < to &lt;
	local params = {}

	for k,v in next, self.params do
		params[#params+1] = ('%s="%s"'):format(k,v)
	end

	if #params>0 then
		params = ' '..table.concat(params, ' ')
	else
		params = ''
	end

	if #self.children==0 then -- Auto-closing Tag
		return ('<%s%s />'):format(self.name, params)
	else
		local children = {}

		for i, tag in next, self.children do
			children[#children+1] = tostring(tag)
		end
		children = table.concat(children, '')

		return ('<%s%s>%s</%s>'):format(self.name, params, children, self.name)
	end
end

Tag.new = function(name, params, parent)
	-- Create the children metatable
	local children = setmetatable({}, {
		__index = function(self, key)
			-- Return the first occurence of the tag
			for i, tag in next, self do
				if tag.name==key then
					return tag
				end
			end
		end
	})

	local tag = {
		name = name,
		params = params or {},
		children = children
	}
	tag.parent = parent or tag -- Keep track of the parent

	return setmetatable(tag, Tag)
end

function Tag:append(tag)
	-- Append the tag to the end of the children
	self.children[#self.children+1] = tag
end

function Tag:find_all(name, params)
	-- Find all tags that match the given parameters
	local params = params or {}
	local result = {}

	for i, tag in next, self.children do
		if tag.name==name or name==nil then
			local match = true

			for p, v in next, params do
				if not tag.params[p]==tostring(v) then
					match = false
					break
				end
			end

			if match then
				result[#result+1] = tag
			end
		end
	end

	return result
end

setmetatable(Tag, {__call=function(_, ...) return Tag.new(...) end})
-- Tag(...) = Tag.new(...)

function parseTag(t, parent)
	-- Parse the tag to get its parameters
	local name, str_params = t:match('^<([%a%d_]+)%s*([^>]*)>')
	local params = {}

	if (not str_params) or str_params=='' then -- No parameters
		return Tag(name, params, parent)
	end
	for p, v in str_params:gmatch('([%a%d_]+)=["\']([^"\']*)') do
		params[p] = v
	end
	return Tag(name, params, parent)
end

function parseXML(xml)
	-- Parse the given xml
	local XML = Tag('XML') -- The root tag
	local current = XML
	for t in xml:gmatch('<[^>]+>') do -- Match each tag
		if t:match('/%s*>$') then -- Auto-closing tag
			current:append(parseTag(t, current))
		elseif not t:match('^<%s*/') then -- Opening tag
			local tag = parseTag(t, current)
			current:append(tag)
			current = tag
		else -- Closing tag
			current = current.parent
		end
	end
	if not current==XML then
		error("Invalid XML")
	end
	return XML
end

function eventNewGame()
	for i=0, dot_id, -1 do
		ui.removeTextArea(i)
	end
	for n, data in next, tfm.get.room.playerList do
		ui.removeTextArea(data.id)
	end
	dot_id = -1

	local mapInfo = tfm.get.room.xmlMapInfo
	if mapInfo then
		displayMiniMap(parseXML(mapInfo.xml))
	end
end

function displayMiniMap(xml)
	local gids = -100
	local scaleGround = function(x, y, type, width, height, angle, color)
		local x = tonumber(x)*scale
		local y = tonumber(y)*scale

		local def = {
			type = tonumber(type) or 1,
			width = tonumber(width)*scale,
			height = tonumber(height)*scale,
			angle = tonumber(angle),
			foreground = true,
			miceCollision = false,
			groundCollision = false
		}
		if color then
			def.color = tonumber(color, 16)
		end

		tfm.exec.addPhysicObject(gids, off.x+x, off.y+y, def)

		gids = gids -1
	end
	scaleGround(400, 200, 12, 800, 400, 0, '6A7495')

	if xml.C.Z and xml.C.Z.S then
		local grounds = xml.C.Z.S:find_all('S')
		for _, ground in next, grounds do
			local p = ground.params
			scaleGround(p.X, p.Y, p.T, p.L, p.H, string.split(p.P,',')[5], p.o)
		end
	end

	if xml.C.Z and xml.C.Z.D then
		local D = xml.C.Z.D
		for i, t in next, D:find_all('T') do
			ui.addTextArea(dot_id, '', nil, off.x+scale*tonumber(t.params.X), off.y+scale*tonumber(t.params.Y), 0, 0, 0x4A3122, 0x4A3122, .5)
			dot_id = dot_id -1
		end
		for i, c in next, D:find_all('F') do
			ui.addTextArea(dot_id, '', nil, off.x+scale*tonumber(c.params.X), off.y+scale*tonumber(c.params.Y), 0, 0, 0xFED69A, 0xFED69A, .5)
			dot_id = dot_id -1
		end
	end
end

string.split = function(str, sep)
	if type(sep)~='string' then
		error('string.split excepted string type for the separator, got '..type(sep), 2)
	end
	local splitted = {}
	for s in str:gmatch(string.format('[^%s]+', sep)) do
		table.insert(splitted, s)
	end
	return splitted
end

function eventLoop(t1, t2)
	if t2<=.1 then
		cat = categories[cati]
		cati = cati +1
		tfm.exec.newGame('#'..cat)
	end
	local sham
	for n, data in next, tfm.get.room.playerList do
		local color = 0xffffff
		local x, y = off.x+(data.x*scale), off.y+(data.y*scale)

		if not data.isDead then
			if data.isShaman then
				if sham then
					ui.addTextArea(sham.id, '', nil, sham.x, sham.y, 0, 0, 0xFEB1FC, 0xFEB1FC, .5)
				else
					sham = {id=data.id, x=x, y=y}
				end
				color = 0x98E2EB
			end
			ui.addTextArea(data.id, '', nil, x, y, 0, 0, color, color, .5)
		end
	end
end

function eventPlayerDied(name)
	ui.removeTextArea(tfm.get.room.playerList[name].id)
	local alive = 0
	for n, data in next, tfm.get.room.playerList do
		if not data.isDead then
			alive = alive +1
		end
	end
	if alive==0 then
		--[[ Prevent: "You can't call this function 
			[tfm.exec.newGame] more than once per 3 seconds."
		]]
		tfm.exec.setGameTime(3)
		cat = categories[cati]
		cati = cati +1
		tfm.exec.newGame('#'..cat)
	elseif alive==1 then
		tfm.exec.setGameTime(20)
	end
end
eventPlayerWon = eventPlayerDied
eventPlayerLeft = eventPlayerDied

main()