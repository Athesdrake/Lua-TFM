draw = {
	-- Draw a line from a position to another
	line = function(id, pos, link, color, line, bg)
		--[[
			id ``int``    : joint's id | 0
			pos ``table`` : points' position | {{x1, y1}, {x2,y2}}
			link ``table``: grounds' id | {0, 1}
			color ``hex`` : line's color | 0xFF0000
			line ``int``  : line's thickness | 3
			bg ``bool``   : line in the background | default: true
		]]--
		local p1 = table.concat(pos[1], ",")
		local p2 = table.concat(pos[2], ",")
		local def = {type=0, point1=p1, point2=p2, line=line, color=color, alpha=1, foreground=bg and false}
		tfm.exec.addJoint(id, link[1], link[2], def)
	end,

	-- Todo: circle
	-- Todo: triangle
	-- Todo: rectangle
	-- Todo: more
}