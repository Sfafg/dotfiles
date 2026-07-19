local usage_file = os.getenv("HOME") .. "/.config/quickshell/scripts/app_usage.txt"

function load_usage()
	local file = io.open(usage_file, "r")
	if not file then
		return {}
	end
	local content = file:read("*a")
	file:close()

	local usage = {}
	for line in string.gmatch(content, "([^\n]+)") do
		local parts = {}
		for part in string.gmatch(line, "([^:]+)") do
			table.insert(parts, part)
		end
		local app = parts[1]
		local use_count = tonumber(parts[2])
		usage[app] = use_count
	end
	return usage
end

function save_usage(usage)
	local file = io.open(usage_file, "w")
	for key, value in pairs(usage) do
		file:write(key .. ":" .. value .. "\n")
	end
	file:close()
end

local usage = load_usage()
if arg[1] == "get" then
	print(usage[arg[2]] or 0)
elseif arg[1] == "set" then
	usage[arg[2]] = (usage[arg[2]] or 0) + 1
	save_usage(usage)
end
