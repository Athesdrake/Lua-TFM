-- /!\ Replace all 'CLASS' by the name of your class

CLASS = {}
CLASS.__index = function(self, key)
	local property = CLASS['_'..key] -- Check if the class has a property
	if type(property)=='function' then -- Also check if the property is a function
		-- Then call the property and return the result
		return property()
	end

	-- Otherwise get the value of the object or class
	return rawget(self, key) or CLASS[key]
end