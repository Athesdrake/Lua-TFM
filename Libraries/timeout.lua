_timeout = {}
-- Execute a function after a certain amount of seconds with the specified arguments
function setTimeout(func, seconds, args)
	_timeout[#_timeout+1] = {
		t = os.time() + seconds * 1000,
		f = func,
		a = args
	}
end

function eventLoop(t1, t2)
	for key, data in ipairs(_timeout) do
		if data.t<=os.time() then
			data.f(table.unpack(data.args))
			table.remove(_timeout, key)
		end
	end
end