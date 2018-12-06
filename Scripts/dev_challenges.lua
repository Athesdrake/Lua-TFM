-- Devs Challenges come from the public Discord server of Bolodefchoco.

table.foreach = function(tbl, f) for k,v in next, tbl do f(k,v) end end

bolo_challenges = {}

bolo_challenges[1] = function(input) --[[
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

bolo_challenges[2] = function(system) --[[
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

-- bolo_challenges[1](math.random(1,10))
xyz = bolo_challenges[2]({
	'x  + 4y + 7z = 10',
	'2x  + 5y + 8z = 11',
	'3x  + 6y + 9z = 12'
})

print('x = '..xyz.x)
print('y = '..xyz.y)
print('z = '..xyz.z)