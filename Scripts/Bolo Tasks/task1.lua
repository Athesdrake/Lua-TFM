--[[
Create a script that generates an XML with 6 random floors and uploads it correctly. There should be a decoration on each floor (listed below), being specific to each floor, not random. The path should not necessarily be something that you can complete.
It is not necessary to have all floors on the same map, as long as it is randomly generated and then loaded.
- Score points optimization!
- Alignment of decorations counts stitches!
- Alignment of floors will help if the above tips are not met.

Floors:
- Other (0)
- Chocolate (4)
- Grass (5)
- Earth (6)
- Sand (7)
- Stone (10)
- Snow (11)

Decorations: // Thanks to  Google Translate the numbers aren't correct.
- Wooden House (1)
- Chocolate ~> Cheese Bottle (31)
- Grass (5)
- Earth ~> Graminha 2 (12)
- Sand -> Sand Castle (8)
- Stone (9)
- Snow> Snowman (50)
]]

xml = '<C><P /><Z><S>%s</S><D>%s<DS Y="130" X="30" /><F Y="135" X="30" /><T Y="320" X="750" /></D><O /></Z></C>'
floor = '<S L="%d" H="%d" X="%d" Y="%d" T="%d" P="0,0,0.3,0.2,0,0,0,0" />'
mice_obj = '<P P="0,0" X="%d" Y="%d" T="%d" />'

tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoNewGame(true)

function createRandomMap(seed) -- get a random seed: math.random(10^12, 10^13)
	local seed = seed or math.random(10^12, 10^13)
	mapseed = seed
	local seeds = {}
	for i=1, 6 do
		local j = 10^(i*2)
		seeds[#seeds+1] = math.floor((seed%j)/j*100)
	end

	local grounds = {}
	local deco = {}

	local gtype = {0,4,5,6,7,10,11}
	local dtype = {13,31,5,12,8,103,50}

	local lastx, lasty

	for i, s in next, seeds do
		local ground = randomGround(s, lastx, lasty)
		lastx, lasty = ground.x+ground.width, ground.y
		grounds[#grounds+1] = floor:format(ground.width, ground.height, ground.x, ground.y, gtype[ground.type])
		deco[#deco+1] = mice_obj:format(ground.x+3, ground.y-ground.height/2, dtype[ground.type])
	end
	return table.concat(grounds, ''), table.concat(deco, '')
end

function randomGround(seed, lastx, lasty)
	math.randomseed(seed)
	lastx, lasty = lastx or 0, lasty or math.random(200, 300)
	local width = math.random(20,100)
	local height = math.random(20,50)
	local dx = math.random(10, 100)
	local dy = math.random(75)*(math.random()<.5 and -1 or 1)
	return {
		x = lastx + dx,
		y = math.min(math.max(lasty + dy, 0), 400),
		width = width,
		height = height,
		type = math.random(1,7),
		deco_off = math.random(width-19)*(math.random(100)<50 and -1 or 1)
	}
end

function eventLoop(t1, t2)
	if t2<.1 then
		math.randomseed(os.time())
		tfm.exec.newGame(xml:format(createRandomMap(math.ceil(math.random()*10^12))))
	end
end

function eventNewGame()
	ui.setMapName('Seed: '..mapseed)
end

function eventPlayerDied()
	local alives = 0
	for n, data in next, tfm.get.room.playerList do
		if not data.isDead then
			alives = alives +1
		end
	end
	if alives==1 then
		tfm.exec.setGameTime(10)
	elseif alives==0 then
		tfm.exec.setGameTime(1)
	end
end
eventPlayerWon = eventPlayerDied

tfm.exec.newGame(xml:format(createRandomMap()))