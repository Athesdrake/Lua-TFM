function isclass(object) -- Check whether or not the object is a class
	if type(object)=='string' then
		return _G[object] and _G[object].__name__==object
	end
	if type(object)~='table' then
		return false
	end
	return object.__name__ and _G[object.__name__]
end


--[[Create a new global class.
	It returns a callable. You can call it to set the bases (optional).
	It returns, again, a callable. Call it with a single table where the
	methods and class attributes are set.

	The method __init__ is called when creating a new instance of the
	class if exists. Otherwise it call the __init__ method of the
	first base which have one.
	In the __init__ method, self.super is a reference to the __init__
	method of the base.

	By default, the __tostring metamethod return a Python-like object
	representation.

	The classes have two special attributes:
	 - __bases__ is a table reference of the class' bases.
	 - __name__ is the name of the class.

	Examples:
	--------
	class "Foo" {
		bar = 1
	}
	class "Bar"(Foo) {
		foo = 2
	}
]]
function class(name)
	local bases = {}
	local methods = {
		__newindex = function(self, k, v)
			if k=='__class__' then return end
			rawset(self, k, v)
		end
	}
	local attributes = {}

	local function index(self, key)
		-- Returns methods first, then attributes and lastly the methods/attributes of the bases.
		if methods[key] then
			return methods[key]
		elseif type(attributes[key])~='nil' then
			return attributes[key]
		else
			for _, base in next, bases do
				if base[key] then
					return base[key]
				end
			end
		end
	end
	methods.__index = index

	local meta
	meta = setmetatable({}, {
		__call = function(self, ...)
			local args = {...}

			if #args==0 then return nil end
			if #args>1 or isclass(args[1]) then -- bases
				for k,c in next, args do
					if isclass(args[1]) then
						bases[#bases+1] = c
					end
				end
				return meta
			end

			for k,v in next, args[1] do -- attributes
				if type(v)=='function' then
					methods[k] = v
				else
					attributes[k] = v
				end
			end

			local class = {
				__name__ = name,
				__bases__ = bases
			}
			_G[name] = setmetatable(class, {
				__index = index,
				__newindex = function(self, key, value)
					-- Read-only
					if key=='__name__' or '__bases__' then return end

					if type(value)=='function' then
						methods[key] = value
					else
						attributes[key] = value
					end
				end,
				__tostring = function(self)
					return ("<class '%s'>"):format(name)
				end,
				__call = function(_, ...)
					local super
					for _, base in next, bases do
						if base.__init__ then
							super = base.__init__
							break
						end
					end

					local instance = {
						super = super,
						__class__ = class
					}
					local repr = ('<%s object at 0x%s>'):format(name, tostring(instance):sub(8))
					local meta = {}
					for k,v in next, methods do meta[k] = v end
					meta.__tostring = meta.__tostring or function(self)
						return repr
					end

					setmetatable(instance, meta)
					if methods.__init__ then
						methods.__init__(instance, ...)
					elseif super then
						super(instance, ...)
					end
					rawset(instance, 'super', nil)

					return instance
				end
			})
		end
	})
	return meta
end

class "Foo" {
	x = 1,
	__init__ = function(self, n)
		self.n = n
	end
}

class "Bar"(Foo) {
	x = 2,
	__init__ = function(self, n)
		self:super(n+1)
	end,
	show = function(self)
		print(self.n)
	end
}

foo = Foo(10)
bar = Bar(15)
print(foo.n) -- 10
bar:show()   -- 16

print(Foo.x) -- 1
print(foo.x) -- 1
print(Bar.x) -- 2
print(bar.x) -- 2
Foo.x = 3
print(Foo.x) -- 3
print(foo.x) -- 3
foo.x = 4
print(Foo.x) -- 3
print(foo.x) -- 4

print(bar)
print(Bar)