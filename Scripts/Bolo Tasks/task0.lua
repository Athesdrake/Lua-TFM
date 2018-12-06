--[[
As an inauguration task, develop an interface that has 4 colors ( Red , Yellow , Green , Blue ). The color of the player's nick will be associated with the color chosen by him.
- Optimization account point!
- In this task, the tones (lighter, darker) and color sequence will not be taken into account.
]]

function eventNewPlayer(name)
	for x, color in next, {0xff, 0xff00, 0xff0000, 0xffff00} do
		ui.addTextArea(x, ('<font size="200"><a href="event:%x">\t\t\t'):format(color), name, 200*(x-1), 20, 200, 50, color, color, 1, true)
	end
end

function eventTextAreaCallback(id, name, callback)
	tfm.exec.setNameColor(name, tonumber(callback, 16))
end

table.foreach(tfm.get.room.playerList, eventNewPlayer)