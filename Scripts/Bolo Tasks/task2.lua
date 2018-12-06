function eventPlayerWon(name)
	-- tfm.exec.giveCheese(name) -- useless
	tfm.exec.chatMessage(name.." won")
end

function eventLoop()
	for name, data in next, tfm.get.room.playerList do
		ui.addTextArea(data.id, '<font color="#ffffff">'..name, nil, data.x, data.y, nil, nil, 0x1, 0x1, 1, true)
	end
end

function eventNewGame()
	if tfm.get.room.xmlMapInfo and tfm.get.room.xmlMapInfo.author == "Tigrounette#0001" then
		tfm.exec.chatMessage("Tigrounette map")
	end
end

--[==[

- A black textarea should appear in the coordinates of the players. The textarea should contain the player's nickname. 
- When a map is made by Tigrounette#0001, a chat message should appear to everyone saying the map is Tigrounette 
- When a player enters the hole, a message in the chat should appear with his name saying that he has won. 

]==]