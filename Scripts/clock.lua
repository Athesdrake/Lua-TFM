-- Create 2 clocks with the time of UTC+1 and the time of UTC-5
-- Do not support BST

function main()
	--vars:
		clocks = { -- d → diameter | shift → time difference
			{x=800, y=550, d=50, shift=1,  label='UTC+1', bst=true},
			{x=920, y=550, d=50, shift=-5, label='UTC-5', bst=true},
		}
		clock_pos = {x=800, y=550, d=50}
	--ids:
		grounds_ids = 0
		linker_1 = 4545
		linker_2 = 5656
		needles = {
			secs = 4545,
			mins = 5656,
			hours = 7878
		}
	--sytème:
		unpack = table.unpack
		format = string.format
		pi = math.pi
		cos = math.cos
		sin = math.sin
		for k,c in pairs(clocks) do
			clock(k,c)
		end
end

function add_circle(pos, d, color)
	local def = {
		type = 13,
		width = d,
		miceCollision = false,
		groundCollision = false,
		color = color
	}
	tfm.exec.addPhysicObject(grounds_ids, pos.x, pos.y, def)
	grounds_ids = grounds_ids +1
end

function add_rect(pos, w, h, color)
	local def = {
		type = 12,
		width = w,
		height = h,
		miceCollision = false,
		groundCollision = false,
		color = color
	}
	tfm.exec.addPhysicObject(grounds_ids, pos.x, pos.y, def)
	grounds_ids = grounds_ids +1
end

function torad(deg) -- Convert ° to rad.
	return deg*math.pi/180
end

function clock(id, pos, theme)
	if not theme then theme=1 end
	id = id +1
	local x,y = pos.x, pos.y
	tfm.exec.addPhysicObject(linker_1, 10, 5, {type=14, miceCollision=false, groundCollision=false})
	tfm.exec.addPhysicObject(linker_2, 10, 5, {type=14, miceCollision=false, groundCollision=false})
	if theme==1 then
		add_circle(pos, pos.d+5, 0x0)
		add_circle(pos, pos.d, 0xFFFFFF)
		for ang=0, 2*pi, pi/2 do
			draw(id*23232+ang/(pi/2), {{x+42*cos(ang),y+42*sin(ang)}, {x+47*cos(ang),y+47*sin(ang)}}, 0x1, 3)
		end
		for ang=0, 2*pi, pi/6 do
			if (ang%(pi/2))~=0 then draw(id*23243+ang/(pi/6), {{x+44*cos(ang),y+44*sin(ang)}, {x+47*cos(ang),y+47*sin(ang)}}, 0x1, 2) end
		end
	elseif theme==2 then -- Not Implemented
		add_rect(pos, pos.d+5, pos.d+5, 0x0)
		add_rect(pos, pos.d, pos.d, 0xFFFFFF)
		for ang=0, 2*pi, pi/2 do
			local inter, x_, y_ = intersect()
			draw(id*23232+ang/(pi/2), {{x+42*cos(ang),y+42*sin(ang)}, {x+47*cos(ang),y+47*sin(ang)}}, 0x1, 3)
		end
		for ang=0, 2*pi, pi/6 do
			if (ang%(pi/2))~=0 then draw(id*23243+ang/(pi/6), {{x+44*cos(ang),y+44*sin(ang)}, {x+47*cos(ang),y+47*sin(ang)}}, 0x1, 2) end
		end
	else
		error(format('Le thème %d n\'a pas encore été implémenté.', theme))
	end
end

function eventNewGame()
	tfm.exec.addPhysicObject(linker_1, 10, 5, {})
	tfm.exec.addPhysicObject(linker_2, 10, 5, {})
end

function draw(id, pos, color, line, bg)
	local def = {type=0, point1=format("%d,%d", unpack(pos[1])), point2=format("%d,%d", unpack(pos[2])), line=line, color=color, alpha=1, foreground=not bg}
	tfm.exec.addJoint(id, linker_1, linker_2, def)
end

function intersect(line1, line2)
	local EPSILON = 0.00001
	local x1, y1, x2, y2 = unpack(line1[1]), unpack(line1[2])
	local dx1, dy1 = x2 - x1, y2 - y1
	local x3, y3, x4, y4 = unpack(line2[1]), unpack(line2[2])
	local dx2, dy2 = x4 - x3, y4 - y3
	local det = (-dx1) * dy2 + dy1 * dx2
	if math.abs(det) < EPSILON then
		return false,0,0
	end
	deti = 1/det
	local r = deti * ((-dy2)*(x2-x1)+dx2*(y2-y1))
	local s = deti * ((-dy1)*(x1-x2)+dx1*(y1-y2))
	local x = (x1+r*dx1+x2+s*dx2)/2
	local y = (y1+r*dy1+y2+s*dy2)/2
	return true, x, y
end

function eventLoop()
	for k,clock in pairs(clocks) do
		local time  = math.ceil(os.time()/1000)
		local secs  = time%60
		local mins  = math.ceil((time/60)%60)
		local hours = (time/3600)%24 +clock.shift
		if hours<0   then hours = hours+24 end
		if hours>=24 then hours = hours-24 end
		local x,y,d = clock.x, clock.y, clock.d -5
		local calcPos = function(a,b,c)
			return {
				{x,y},
				{
					x + c * cos(a * pi/b - pi/2),
					y + c * sin(a * pi/b - pi/2)
				}
			}
		end
		draw(k*needles.secs, calcPos(secs, 30, d-10), 0xFF0000, 2)
		draw(k*needles.mins, calcPos(mins, 30, d-10), 0x1, 4)
		draw(k*needles.hours, calcPos(hours,6, d-20), 0x1, 4)
		ui.addTextArea(k, string.format("<p align='center'>%dh %dm %ds", hours, mins, secs), nil, x-clock.d, y+clock.d+15, clock.d*2)
	end
end

main()