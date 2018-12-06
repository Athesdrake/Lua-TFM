Queue = {}
Queue.__index = Queue

-- Return an iterator of the queue; Do not pop elements.
function Queue.__call(self)
	-- use a coroutine to iterate in the entire queue
	if not self.__iter or coroutine.status(self.__iter)=='dead' then
		self.__iter = coroutine.create(function()
			-- From start to stop
			local i = self.start
			while i<self.stop do
				coroutine.yield(self[i])
				i = i+1
			end
		end)
	end
	return table.unpack({coroutine.resume(self.__iter)}, 2)
end

-- Create and return a new Queue
function Queue.new(tbl)
	tbl = tbl and {table.unpack(tbl)} or {} -- keep only the integer keys
	tbl.start = 1
	tbl.stop = 1

	return setmetatable(tbl, Queue)
end

-- Put an element to the end of the queue
function Queue:put(value) -- Add a value to the queue
	self[self.stop] = value
	self.stop = self.stop +1
end

-- Put an element to the start of the queue
function Queue:right_put(value)
	self[self.start-1] = value
	self.start = self.start -1
end

-- Pop the first element of the queue
function Queue:pop()
	if self.start==self.stop then return end

	local rval = self[self.start]

	self[self.start] = nil -- Free memory
	self.start = self.start +1 -- Increment the start of the queue
	return rval
end

-- Pop the last element of the queue
function Queue:right_pop()
	if self.start==self.stop then return end

	local rval = self[self.stop]

	self[self.stop] = nil -- Free memory
	self.stop = self.stop -1 -- Decrement the start of the queue
	return rval
end

-- Pop all elements of the queue
-- It does not free memory /!\
function Queue:pop_all()
	local tbl = {table.unpack(self, self.start, self.stop)}
	self.start = 1
	self.stop = 1
	self[1] = nil
	return next, tbl
end

-- Return the length of the queue
function Queue:len()
	return self.stop - self.start
end

-- Return if an element is in the queue
function Queue:is_in(value)
	for v in self do
		if v==value then
			return true
		end
	end
	return false
end

Queue.left_put = Queue.put -- Alias for Queue.put
Queue.left_pop = Queue.pop -- Alias for Queue.pop
setmetatable(Queue, {__call=function(_,...) return Queue.new(...) end})