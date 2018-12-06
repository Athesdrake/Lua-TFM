--[[
Task 6 - ★★★
Calendar: 09/15/2018 - 09/22/2018

Today you will create Windows Explorer! That's right! Description through topics:
• "New Folder" button
• Create a folder (only letters, numbers, space and _ (minimum 4 letters)) in the current directory (path)
• When clicking on the created folder we should go to the path of the folder (pathAntiga .. "/" .. filename)
• Show a phrase ("Back to" .. pathAntiga)
• "New File" button
• Create a file (only letters, numbers, space and _, NEED AN EXTENSION (eg .png) and at least 1 letter in the file name) in the current directory (path)
• Can not be clicked
• All created can be deleted (Delete button, next to)
• Path must be divided by / or \
• When a file or folder is deleted, the textarea must be updated.
- Extra point for efficiency and optimization
• There can be no duplicate names (two folders / files with the same name)

You can also opt for a console, it should have the same functionality from above, but with commands. (Textarea (output) and popup (input))
]]

function main()
	players = {}
	disk = Folder('root')
	disk.usr = Folder('usr',disk)

	table.foreach(tfm.get.room.playerList, eventNewPlayer)
end

function eventNewPlayer(name)
	local fname = name:gsub('#', '')
	local home_path = '/usr/'..fname
	local home = Folder(fname, disk.usr)
	home.Desktop = Folder('Desktop', home)
	home.Documents = Folder('Documents', home)
	disk.usr[fname] = home
	players[name] = {
		home = home,
		home_path = home_path
	}
	showDisk(name, home_path)
end

function eventTextAreaCallback(id, name, callback)
	local args = string.split(callback, '$')
	if args[1]=='navigate' then
		showDisk(name, args[2])
	elseif args[1]=='newfolder' or args[1]=='newfile' then
		local id = args[1]=='newfolder' and 1 or 2
		local txt = ({'Folder Name :','File Name :'})[id]
		players[name].cwd = args[2] -- Current Working Directory
		ui.removeTextArea(3, name)
		ui.addPopup(id, 2, txt, name, 250, 150, 300, true)
	elseif args[1]=='delete' then
		local folder = getFolder(args[2])
		local parent = folder.parent or folder.folder
		parent[folder.name] = nil
		players[name].binMode = not players[name].binMode
		showDisk(name, parent.path)
	elseif args[1]=='toggleBin' then
		players[name].binMode = not players[name].binMode
		showDisk(name, args[2])
	end
end

function eventPopupAnswer(id, name, answer)
	local cwd = players[name].cwd
	local popupError = function(type, txt, i)
		i = i or id
		ui.addPopup(i, type, txt, name, 250, 150, 300, true)
	end
	if id==1 then -- Add a new folder
		if #answer<4 then
			popupError(2, "The folder name must be at least 4 char long\n\nFolder name :")
		elseif not answer:match('^[a-zA-Z0-9_ ]+$') then
			popupError(2, "The folder name can contains only letters, numbers, spaces and _\n\nFolder name :")
		else
			local folder = getFolder(cwd)
			local fname = escapePath(answer)
			if folder[fname] then
				popupError(0, ("The folder '%s' already exists"):format(answer))
			else
				folder[fname] = Folder(answer, folder)
			end
			showDisk(name, cwd)
		end
	elseif id==2 then -- Add a new file
		if (not answer:match('%.')) or #answer:match('%.(.+)')<1 then
			popupError(2, "The file name need an extension\n\nFile name :")
		elseif #answer:match('([^.]+)')<1 then
			popupError(2, "The file name must be at least 1 char long\n\nFile name :")
		elseif not answer:match('^[a-zA-Z0-9_ ]+%.[a-zA-Z0-9_]+$') then
			popupError(2, "The file name can contains only letters, numbers, spaces and _\n\nFile name :")
		else
			local folder = getFolder(cwd)
			if folder[answer] then
				popupError(0, ("The file '%s' already exists"):format(answer))
				showDisk(name, cwd)
			else
				folder[answer] = File(answer, folder)
				players[name].cwd = folder[answer].path
				showDisk(name, players[name].cwd)
				popupError(2, "File Content :", 3)
			end
		end
	elseif id==3 then -- Add content to the current file (cwd)
		getFolder(cwd).content = answer
		showDisk(name, cwd)
	end
end

function getFolder(path)
	local current = disk
	for p in path:gmatch('[^/]+') do
		p = escapePath(p)
		if not current[p] then
			error(string.format('%s do not exists', path))
		end
		current = current[p]
	end
	return current
end

function escapePath(path)
	for _,n in next, Folder do
		if path==n then
			return '#'..path
		end
	end
	if disk then
		for n in next, disk do
			if path==n then
				return '#'..path
			end
		end
	end
	return path
end

string.split = function(str, sep)
	local tbl = {}
	for s in str:gmatch(string.format('[^%s]+', sep)) do
		tbl[#tbl+1] = s
	end
	return tbl
end

function showDisk(name, path)
	path = path or '/'
	path:gsub('~', players[name].home_path, 1)

	local current = getFolder(path)
	local binMode = not not players[name].binMode
	local text = {}
	local a_path = {}
	local template = ("<a href='event:$cmd$%s'>%s</a>"):gsub('$cmd', binMode and 'delete' or 'navigate')
	local tag1, tag2 = '', ''

	if binMode then tag1, tag2 = '<r>', '</r>' end
	local tools = ("<a href='event:newfolder$%s'>New Folder</a>  |  <a href='event:newfile$%s'>New File</a>  |  <a href='event:toggleBin$%s'>%sDelete File%s</a>"):format(current.path, current.path, current.path, tag1, tag2)
	
	if getmetatable(current)==File then
		ui.addTextArea(1, current.content, name, 100, 70, 600, 280, nil, nil, 1, true)
		tools = '<p align="center">- No tools yet -'

		a_path[1] = template:format(current.path, current.name)

		current = current.folder
	else
		if current.parent then
			text[1] = template:format(current.parent.path, '..'):gsub('delete', 'navigate')
		end

		for k, v in current() do
			local isFolder = getmetatable(v)==Folder
			local p, n = v.path, v.name
			if isFolder then
				n = '/'..n
			end
			text[#text+1] = template:format(p, n)
		end

		ui.addTextArea(1, table.concat(text, '\n'), name, 100, 70, 600, 280, nil, nil, 1, true)
	end

	while current.parent do
		table.insert(a_path, 1, template:format(current.path, current.name))
		current = current.parent
	end

	ui.addTextArea(2, "<a href='event:navigate$/'>/</a>"..table.concat(a_path, '/'), name, 90, 40, 620, 25, nil, nil, 1, true)
	ui.addTextArea(3, tools, name, 95, 335, 610, 25, nil, nil, 1, true)
end

-- [[ Classes ]] --
Folder = {}

Folder.__index = function(self, key)
	local value = rawget(self, key)
	if value then return value end
	return rawget(self, 'content')[key]
end
Folder.__newindex = function(self, key, value)
	rawget(self, 'content')[key] = value
end

Folder.__call = function(self)
	return next, rawget(self, 'content')
end

Folder.new = function(name, parent)
	local path = '/'
	if parent then
		path = ('%s/%s'):format(
			parent.path=='/' and '' or parent.path,
			name
		)
	end
	local data = {
		name = name,
		path = path,
		parent = parent,
		content = {}
	}
	return setmetatable(data, Folder)
end

setmetatable(Folder, {__call=function(_,...) return Folder.new(...) end})

File = {}
File.__index = File

File.new = function(name, folder, content)
	local data = {
		name = name,
		path = ('%s/%s'):format(folder.path=='/' and '' or folder.path, name),
		folder = folder,
		content = content or ''
	}
	return setmetatable(data, File)
end

setmetatable(File, {__call=function(_,...) return File.new(...) end})

main()