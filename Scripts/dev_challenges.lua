-- Devs Challenges come from the public Discord server of Bolodefchoco.
-- Invite link: https://discord.gg/quch83R

table.foreach = function(tbl, f) for k,v in next, tbl do f(k,v) end end

dev_challenges = {}

dev_challenges[1] = function(input) --[[
	An user inputs a number [1:10] and you need to show the mul table of the number 1 until the number the user did input.

	- You are allowed to use only one loop of any type
	- You can use variables and ifs
	- You can't use 10 prints
	]]
	for i=0, input*10 - 1 do
		local a = i%10+1
		local b = (i - a + 1)/10+1
		print(string.format('%d*%d = %d', b, c, b * c))
	end
end

dev_challenges[2] = function(system) --[[
	Solve any given system of Linear Equations 3x3
	ax + by + cz = d

	Example
	x  + 4y + 7z = 10
	2x  + 5y + 8z = 11
	3x  + 6y + 9z = 12
	=
	x = -2
	y = 3
	z = 0
	]]
	local parse = function(equation)
		local regex = '([+-]?%d*)x([+-]?%d*)y([+-]?%d*)z=([+-]?%d*)'
		-- `[+-]?%d*` for each variable

		local  x, y, z, d = equation:gsub(' ', ''):match(regex)
		return {
			tonumber(x) or 1,
			tonumber(y) or 1,
			tonumber(z) or 1,
			tonumber(d)
		}
	end

	local A = {}

	for k, eq in next, system do
		A[#A+1] = parse(eq)
	end

	if A[1][1]==0 and A[2][1]~=0 then
		A[2], A[1] = A[1], A[2] -- swap
	end
	if A[1][1]==0 then
		A[3], A[1] = A[1], A[3] -- swap
	end
	if A[1][1]~=0 then
		local coef = A[1][1]
		for j=1,4 do
			A[1][j] = A[1][j] / coef
		end
	end

	local coef = -A[2][1]
	for j=1,4 do
		A[2][j] = A[2][j] + (A[1][j] * coef)
	end

	local coef = -A[3][1]
	for j=1,4 do
		A[3][j] = A[3][j] + (A[1][j] * coef)
	end

	if A[2][2]==0 then
		for j=2, 4 do -- swap
			A[3][j], A[2][j] = A[2][j], A[3][j]
		end
	end

	if A[2][2]~=0 then
		local coef = A[2][2]
		for j=2,4 do
			A[2][j] = A[2][j] / coef
		end

		for i=3,1,-2 do
			local coef = -A[i][2]
			for j=2,4 do
				A[i][j] = A[i][j] + A[2][j] * coef
			end
		end
	end

	if A[3][3]~=0 then
		A[3][4] = A[3][4] / A[3][3] -- Z
	end

	A[2][4] = A[2][4] + A[3][4] * (-A[2][3]) -- Y
	A[1][4] = A[1][4] + A[3][4] * (-A[1][3]) -- X

	return {x=A[1][4], y=A[2][4], z=A[3][4]}
end

dev_challenges[3] = function() --[[
	Create your own challenge :genius:
	]]
	return nil
end

dev_challenges[4] = function(sudoku_game) --[[
	Make a Sudoku Checker:
	Given any Sudoku game, check if it's complete or even a valid one.

	Example Sudoku game:
	{
	    5, 3, 4,        6, 7, 8,        9, 1, 2,
	    6, 7, 2,        1, 9, 5,        3, 4, 8,
	    1, 9, 8,        3, 4, 2,        5, 6, 7,

	    8, 5, 9,        7, 6, 1,        4, 2, 3,
	    4, 2, 6,        8, 5, 3,        7, 9, 1,
	    7, 1, 3,        9, 2, 4,        8, 5, 6,

	    9, 6, 1,        5, 3, 7,        2, 8, 4,
	    2, 8, 7,        4, 1, 9,        6, 3, 5,
	    3, 4, 5,        2, 8, 6,        1, 7, 9
	}
	]]
	local grid, complete = {}, true
	if #sudoku_game~=9*9 then
		error("This is not a Sudoku game")
	end

	for i=1,9 do
		grid[i] = {}
		for j=1,9 do
			grid[i][j] = sudoku_game[(i-1)*9+j]
		end
	end

	--[==[ Horizontal Check ]==]--
	for i=1,9 do
		local check = {}
		for j=1,9 do
			local value = grid[i][j]
			if value>9 or (check[value] and value~=0) then return false, false, {i,j} end
			check[value] = true
		end
		if complete and check[0] then
			complete = false
		end
	end

	--[==[ Vertical Check ]==]--
	for j=1,9 do
		local check = {}
		for i=1,9 do
			local value = grid[i][j]
			if value>9 or (check[value] and value~=0) then return false, false, {i,j} end
			check[value] = true
		end
		if complete and check[0] then
			complete = false
		end
	end

	--[==[ Block Check ]==]--
	for block=0,8 do
		local check = {}
		local block = block-block%3
		for i=0,8 do
			local i, j = block+(i-i%3)/3+1, i%3+1
			local value = grid[i][j]
			if value>9 or (check[value] and value~=0) then return false, false, {i,j} end
			check[value] = true
		end
		if complete and check[0] then
			complete = false
		end
	end

	return true, complete
end

dev_challenges[5] = function(input) --[[
	An user inputs an integer N between 1 and 100 000, then N pairs of integers which are intervals.
	You must output the size of the union of all intervals. You may use any function available in the standard library of your language.
	The endpoints of the intervals are integers between 1 and 10^18.
	Efficiency constraints : your program must solve any testcase in less than 2000ms on a modern computer.

	Here is an input example (where N = 6) :
	6
	1 3
	7 15
	20 22
	2 5
	9 11
	12 18


	Visual representation : https://i.imgur.com/8pzlVtP.png
	The size of the union of all these intervals is 17 (your program must output 17 on this testcase).
	]]
	local input = input:match('^%d+\n(.+)$') -- ignore data len
	local timeline, i = {}, 1
	for a, b in input:gmatch('(%d+) (%d+)\n?') do
		local a, b = tonumber(a), tonumber(b)
		timeline[i]   = {t = a, v =  1}
		timeline[i+1] = {t = b, v = -1}
		i = i +2
	end
	table.sort(timeline, function(a,b) return a.t<b.t end)

	t1 = os.clock()
	local opened = 0
	local len = 0
	for k, data in next, timeline do
		if opened==0 and data.v==1 then
			len = len - data.t
		end
		opened = opened + data.v
		if opened==0 and data.v==-1 then
			len = len + data.t
		end
	end
	print(('Length Took %d ms'):format(math.ceil((os.clock()-t1)*1000)))

	return len
end

dev_challenges[6] = function()
	return nil
end

dev_challenges[7] = function(string) --[[
	Write a program which, given a string S, will check if it's a correctly parenthesized expression.
	There are three types of parentheses : (), [], {}. For convenience, S will only contain theses parentheses and some digits.
	An empty string is a correct string. If a, b and c are correct strings then a(b)c, a[b]c and a{b}c are correct strings.
	Using this rule we can recursively deduce the set of valid strings (which is infinite, of course).
	For example ({4}22) is a correct string. ((8{[193]}39){[44](82)}7)2 is also correct. But ({)} is incorrect. )(4() is also incorrect.
	The string S given in input contains at most 100 000 characters. Your program must terminate in less than 2000ms.
	]]
	local convert = {['{'] = '}',['('] = ')',['['] = ']'}
	local right = {[']'] = 0,[')'] = 0,['}'] = 0}
	local stack = {}

	for c in string:gmatch'[{%[%(%)%]}]' do
		if right[c] then
			if #stack==0 or convert[stack[#stack]]~=c then
				return false
			end
			stack[#stack] = nil
		else
			stack[#stack+1] = c
		end
	end
	if #stack>0 then
		return false
	end
	return true
end

--[==[ Tests ]==]--
	-- dev_challenges[1](math.random(1,10))
	-- xyz = dev_challenges[2]({
	-- 	'x  + 4y + 7z = 10',
	-- 	'2x  + 5y + 8z = 11',
	-- 	'3x  + 6y + 9z = 12'
	-- })

	-- print('x = '..xyz.x)
	-- print('y = '..xyz.y)
	-- print('z = '..xyz.z)

	-- valid, complete, index = dev_challenges[4]({
	--     5, 3, 4,        6, 7, 8,        9, 1, 2,
	--     6, 7, 2,        1, 9, 5,        3, 4, 8,
	--     1, 9, 8,        3, 4, 2,        5, 6, 7,

	--     8, 5, 9,        7, 6, 1,        4, 2, 3,
	--     4, 2, 6,        8, 5, 3,        7, 9, 1,
	--     7, 1, 3,        9, 2, 4,        8, 5, 6,

	--     9, 6, 1,        5, 3, 7,        2, 8, 4,
	--     2, 8, 7,        4, 1, 9,        6, 3, 5,
	--     3, 4, 5,        2, 8, 6,        1, 7, 9
	-- })
	-- print('Valid sudoku:\t', valid)
	-- print('Complete sudoku:', complete)
	-- if index then
	-- 	print('Invalid index:', ('row:%d, column:%d'):format(table.unpack(index)))
	-- end

	-- len = dev_challenges[5]([[6
	-- 1 3
	-- 7 15
	-- 20 22
	-- 2 5
	-- 9 11
	-- 12 18]])
	-- print(len)

print(dev_challenges[7]('((8{[193]}39){[44](82)}7)2'))
print(dev_challenges[7]('({4}22)'))
print(dev_challenges[7]('({)}'))
print(dev_challenges[7](')(4()'))

local s = {}
do
	local stack = {}
	local brackets = {'{', '[', '('}
	local convert = {['{'] = '}',['('] = ')',['['] = ']'}
	for i=1, 100000 do
		if math.random()<.5 then
			local b = brackets[math.random(#brackets)]
			s[#s+1] = b
			stack[#stack+1] = b
		else
			s[#s+1] = convert[stack[#stack]]
			stack[#stack] = nil
		end
	end
	for i=#stack, 1, -1 do
		s[#s+1] = convert[stack[i]]
	end
end
local s = table.concat(s, '')

local t1 = os.clock()
print(dev_challenges[7](s))
print((os.clock()-t1)*1000)