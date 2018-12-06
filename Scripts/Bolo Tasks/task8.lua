--[[Task 8 - ★★ ☆
Calendar: 10/9/2018 - 10/16/2018

Morse code is used when we can only communicate using 2 states, such as turning on and off a lamp or even lowering and raising a mouse in Transformice.
Imagine that a player received a mute and lowering and lifting was his only contact?
If he does this in a normal room, it would depend on someone who understands what he is talking about, but if it is in the cafophone we can create something that translates into our alphabet.

So that's the task: create a Morse code interpreter.
The signals will be sent by the act of lowering and raising of the mice and, when they perform the animation of "dropping confetti", what has been detected must be translated and displayed.
The morse alphabet is defined with dots and dashes, see below how the pattern works

http://img.atelier801.com/e5a4f210.jpg

- The points are called dit and are the reference for the duration of the other symbols
- The strokes are called dah and have a duration of 3 dits (3 times the time of a dit)
- Space between dits and dah (spaces and points) has a duration of 1 dit
- Space between letters has a duration of 1 dah (3 dits)
- Space between words has a duration of 7 dits

It is in your discretion to define what will be the time of a dit, but the other symbols should use the time of dit as reference.

Example:

=,===,=,=,,,=,,,=,=,=,===,,,=,,,=,=,,,,,,,===,===,,,=,=,===,,,===,,,=

* equals sign (=) is turned on, comma (,) is turned off

Translating turns:

.-.. . ...- . .. / -- ..- - .

L E V E I (espaço) M U T E

For this task you will mainly deal with:

- system.bindKeyboard and eventKeyboard
- eventEmotePlayed
- ui.addTextArea
- os.time

Care:

- Do not mix the players' signals. Several players must be able to send signals at the same time
- If an invalid pattern is detected, you must warn the error and display the written message until then
]]

function main()
	dit = 100

	players = {}
	table.foreach(tfm.get.room.playerList, eventNewPlayer)
end

function eventNewPlayer(name)
	system.bindKeyboard(0, name, true, true)
	system.bindKeyboard(0, name, false, true)

	players[name] = {
		recording = false,
		record = {},
		last_time = 0
	}
end

function eventEmotePlayed(name, id)
	if id==5 then
		local recording = players[name].recording
		players[name].recording = not recording
		if recording then
			local data = tfm.get.room.playerList[name]
			local txt = table.contact(players[name].record, '')

			ui.addTextArea(data.id, txt, nil, data.x-10, data.y-30)
		end
	end
end

function eventKeyboard(name, key, down)
	if not players[name].recording then return end
	local record = players[name].record
	local time = os.time() - players[name].last_time

	if down then
		record[#record+1] = time<=2*dit and '.' or '-'
	elseif time>=2*dit then
		record[#record+1] = time<=4*dit and ' ' or '/'
	end
end