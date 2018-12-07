ids = setmetatable({__id=0}, {
	__index = function(self, key)
		if rawget(self, key) then -- If the key already exists
			return rawget(self, key) -- Then return it
		end

		self.__id = self.__id +1 -- Otherwise increment the counter
		return rawset(self, key, self.__id)[key] -- Set the new id to the key and return the value
	end,
	__newindex = function() end
})

--[==[
	Exemple:

		print(ids.welcome) -- 1
		print(ids.help) -- 2
		print(ids.welcome) -- 1
--]==]