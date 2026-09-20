local function parse_monitors(filename)
	local file = assert(io.open(filename, "r"))
	local source = file:read("*a")
	file:close()

	local monitors = {}

	for block in source:gmatch("hl%.monitor%s*%(%s*(%b{})%s*%)") do
		local monitor = {}

		for key, value in block:gmatch("([%w_]+)%s*=%s*([^,%s]+)") do
			if value:sub(1, 1) == '"' then
				monitor[key] = value:sub(2, -2)
			elseif value == "true" then
				monitor[key] = true
			elseif value == "false" then
				monitor[key] = false
			else
				monitor[key] = tonumber(value)
			end
		end

		table.insert(monitors, monitor)
	end

	return monitors
end

local function write_monitors(filename, monitors)
	local file = assert(io.open(filename, "w"))

	for _, monitor in ipairs(monitors) do
		file:write("hl.monitor({\n")
		local keys = {}

		for key in pairs(monitor) do
			table.insert(keys, key)
		end

		table.sort(keys)
		for _, key in pairs(keys) do
			local value = monitor[key]
			if type(value) == "string" then
				file:write(string.format(' %s = "%s",\n', key, value))
			elseif type(value) == "number" then
				file:write(string.format(" %s = %s,\n", key, value))
			elseif type(value) == "boolean" then
				file:write(string.format(" %s = %s,\n", key, tostring(value)))
			end
		end
		file:write("})\n\n")
	end
	file:close()
end

local monitors = parse_monitors("/home/slawek/dev/dotfiles/hypr/monitors.lua")
if #arg == 0 then
	for _, monitor in ipairs(monitors) do
		local text = ""
		for key, value in pairs(monitor) do
			text = text .. key .. " " .. tostring(value) .. ","
		end
		print(text)
	end
	return
end

local monitorIndex = 0
for i, argument in ipairs(arg) do
	if i == 1 then
		local name = argument
		if type(name) ~= "string" then
			error("invalid value")
		end

		for j, monitor in pairs(monitors) do
			if monitor.output == name then
				monitorIndex = j
				break
			end
		end
		if monitorIndex == 0 then
			error("invalid name")
		end
	else
		local key, value = argument:match("^([^=]+)=(.*)$")
		if not key or key == "output" then
			error("invalid key")
		end

		if type(monitors[monitorIndex][key]) == "number" then
			value = tonumber(value)
		elseif value == "true" then
			value = true
		elseif value == "false" then
			value = false
		end

		print(key, value)
		monitors[monitorIndex][key] = value
	end
end

write_monitors("/home/slawek/dev/dotfiles/hypr/monitors.lua", monitors)
