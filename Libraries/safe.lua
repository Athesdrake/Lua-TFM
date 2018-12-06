-- Return the value in a table that match a function
table.match = function(tbl, func)
	for i,v in ipairs(tbl) do
		if func(i,v) then
			return v
		end
	end
end

_errors = {debug=true} -- The _errors table keep track of the errors
-- debug=true: All the errors are passed to eventError
-- debug=false: The errors are passed once to eventError
function safe(func, name) -- Return a new function that wrap the given one
	-- The name parameter is used for the traceback
	if func==safe or func==eventError then
		return func -- safe and eventError must be unsafe
	end
	local regex = "^(.-)%.lua:(%d+): (.+)$" -- Match 'ScriptLoader.lua: line: error_message'

	return function(...) -- Return a wrapper
		local result = {pcall(func,...)} -- First call the function with the arguments passed in

		if not table.remove(result, 1) then -- If an error occurred
			-- Parse the error message
			local parser = function(err, sargs, args)
				if type(err)~='string' then
					return '<R>CRITICAL: An undefined error has occurred</R>'
				end

				local match = {err:match(regex)}
				if #match<3 then -- Custom errors cannot be parsed
					return string.format('<R>%s</R> Args: %s', err, sargs)
				end

				-- Traceback
				table.insert(match, name or '#Not#specified#')

				-- Arguments
				table.insert(match, sargs)

				-- Check if the error already occurred
				if (not table.match(_errors, function(k,err)
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
					return _errors[#_errors+1]
				end
			end

			-- If the eventError function exist, it will handle the errors
			local eventError = eventError or function(error)
				-- Be careful the error can be a string
				if type(error)=="string" then
					print(error)
				else
					print(string.format('<V>[%s]</V> Line %d: <R>%s</R>\nTraceback: %s Args: %s', error.loader, error.line, error.error, error.traceback, error.sargs))
				end
			end

			local last_key, args = 0, {}
			for key,v in next, {...} do
				for i=2, key-last_key do
					table.insert(args, 'nil')
				end
				last_key = key
				table.insert(args, string.format((type(v)=='string' and "'%s'" or '%s'), tostring(v)))
			end

			local err = parser(result[1], table.concat(args, ', '), {...})
			eventError(err)
		else -- Else return the result
			return table.unpack(result)
		end
	end
end

-- Make all event safe
function safeEvents()
	for k,v in next, _G do
		-- eventError need to be unsafe !!
		if k:match('^event') and k~='eventError' then
			_G[k] = safe(v, k)
		end
	end
end