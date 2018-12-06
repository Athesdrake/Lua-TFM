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

--[==[--
	===[=[ XML Parser ]=]===
	It's not the best XML Parser; it does not retrieve the content of the tags:
		"<Tag>Hi</Tag>" the parser ignore "Hi"
	The parser can also break if the xml is invalid or if a parameter contains
	the character ">"

	But Transformice XML are valid, does not contains ">" in their parameters
	and does not have content.
--]==]--

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
	local mapInfo = tfm.get.room.xmlMapInfo
end