local clonefunction_c = clonefunction(clonefunction)
local checkcaller_c = clonefunction(checkcaller)
local game_getservice = clonefunction_c(game.GetService)
local insertservice_LoadLocalAsset = clonefunction_c(game_getservice(game, "InsertService").LoadLocalAsset)
local string_match = clonefunction_c(string.match)
local string_lower = clonefunction_c(string.lower)
local getgenv_c = clonefunction_c(getgenv)
local getIdentity_c = clonefunction_c(getidentity)
local setIdentity_c = clonefunction_c(setidentity)
local rRequire = clonefunction_c(require)
local hookfunction_c = clonefunction_c(hookfunction)
local newcclosure_c = clonefunction_c(newcclosure)
local getrawmetatable_c = clonefunction_c(getrawmetatable)
local error_c = clonefunction_c(error)
local getnamecallmethod_c = clonefunction_c(getnamecallmethod)
local HttpPost_c = clonefunction_c(HttpPost)
local HttpGet_c = clonefunction_c(HttpGet)
local select_c = clonefunction_c(select)
local pairs_c = clonefunction_c(pairs)
local typeof_c = clonefunction_c(typeof)
local is_environment_instrumented_c = clonefunction_c(is_environment_instrumented)
local consoleprint_c = clonefunction_c(consoleprint)
local consolewarn_c = clonefunction_c(consolewarn)
local consoleerror_c = clonefunction_c(consoleerror)
local compile_to_bytecode_c = clonefunction_c(compile_to_bytecode)

print("setting genv")
local function reconstruct_table(t_)
	local function tL(t)
		if type(t) ~= "table" then
			return 0
		end
		local a = 0
		for _, _ in pairs(t) do
			a = a + 1
		end
		return a
	end

	local function tL_nested(t)
		if type(t) ~= "table" then
			return 0
		end
		local a = 0
		for _, v in pairs(t) do
			if type(v) == "table" then
				a = a + tL_nested(v)
			end
			a = a + 1 -- Even if it was a table, we still count the table index itself as a value, not just its subvalues!
		end
		return a
	end

	if type(t_) ~= "table" then
		return string.format("-- Given object is not a table, rather a %s. Cannot reconstruct.", type(t_))
	end

	local function inner__reconstruct_table(t, isChildTable, childDepth)
		local tableConstruct = ""
		if not isChildTable then
			tableConstruct = "local t = {\n"
		end

		if childDepth > 30 then
			tableConstruct = string.format("%s\n--Cannot Reconstruct, Too much nesting!\n", tableConstruct)
			return tableConstruct
		end

		for idx, val in pairs(t) do
			local idxType = type(val)
			if type(idx) == "number" then
				idx = idx
			else
				idx = string.format('"%s"', string.gsub(string.gsub(tostring(idx), "'", "'"), '"', '\\"'))
			end

			if idxType == "boolean" then
				tableConstruct = string.format(
					"%s%s[%s] = %s",
					tableConstruct,
					string.rep("\t", childDepth),
					tostring(idx),
					val and "true" or "false"
				)
			elseif idxType == "function" or idxType == "number" or idxType == "string" then
				local v = tostring(val)

				if idxType == "number" then
					if string.match(tostring(v), "nan") then
						v = "0 / 0"
					elseif string.match(tostring(v), "inf") then
						v = "math.huge"
					elseif tostring(v) == tostring(math.pi) then
						v = "math.pi"
					end
				end

				if idxType == "string" then
					v = string.format('"%s"', string.gsub(string.gsub(v, "'", "'"), '"', '\\"'))
				end

				tableConstruct =
					string.format("%s%s[%s] = %s", tableConstruct, string.rep("\t", childDepth), tostring(idx), v)
			elseif idxType == "table" then
				local r = inner__reconstruct_table(val, true, childDepth + 1)
				tableConstruct =
					string.format("%s%s[%s] = {\n%s", tableConstruct, string.rep("\t", childDepth), tostring(idx), r)
			elseif idxType == "nil" then
				tableConstruct =
					string.format("%s%s[%s] = nil", tableConstruct, string.rep("\t", childDepth), tostring(idx))
			elseif idxType == "userdata" then
				tableConstruct = string.format(
					'%s%s[%s] = "UserData. Cannot represent."',
					string.rep("\t", childDepth),
					tableConstruct,
					tostring(idx)
				)
			end
			tableConstruct = string.format("%s,\n", tableConstruct)
		end
		if isChildTable then
			return string.format("%s%s}", tableConstruct, string.rep("\t", childDepth - 1))
		else
			return string.format("%s}\n", tableConstruct)
		end
	end
	local welcomeMessage = [[
-- Table reconstructed using table_reconstructor by usrDottik (Originally made by MakeSureDudeDies)
-- Reconstruction   began   @ %s - GMT 00:00
-- Reconstruction completed @ %s - GMT 00:00
-- Indexes Found inside of the Table (W/o  Nested Tables): %d
--                                   (With Nested Tables): %d
]]
	local begin = tostring(os.date("!%Y-%m-%d %H:%M:%S"))
	local reconstruction = inner__reconstruct_table(t_, false, 1)
	local finish = tostring(os.date("!%Y-%m-%d %H:%M:%S"))
	welcomeMessage = string.format(welcomeMessage, begin, finish, tL(t_), tL_nested(t_))

	return string.format("%s%s", welcomeMessage, reconstruction)
end

local __instanceList = nil


local function get_instance_list()
    local tmp = Instance.new("Part")
    for idx, val in pairs(getreg()) do
        if typeof_c(val) == "table" and rawget(val, "__mode") == "kvs" then
            for idx_, inst in pairs(val) do
                if inst == tmp then
                    tmp:Destroy()
                    return val  -- Instance list
                end
            end
        end
    end
    tmp:Destroy()
    consolewarn("[get_instance_list] Call failed. Cannot find instance list!")
    return {}
end

task.delay(1, function()
    __instanceList = get_instance_list()
end)

getgenv_c().getscripthash = newcclosure_c(function(instance)
    if typeof_c(instance) ~= "Instance" then
        return error_c("Expected Instance as argument #1, got " .. typeof_c(instance) .. " instead!")
    end

    if not instance:IsA("LocalScript") and not instance:IsA("ModuleScript") then
        return error_c("Expected ModuleScript or LocalScript as argument #1, got " .. instance.ClassName .. " instead!")
    end

    return instance:GetHash() -- https://robloxapi.github.io/ref/class/Script.html#member-GetHash
end)

getgenv_c().lcloneref = newcclosure_c(function(instance)
    if typeof_c(instance) ~= "Instance" then
        return error_c("Expected Instance as argument #1, got " .. typeof_c(instance) .. " instead!")
    end

    for idx, inInstanceList in pairs(__instanceList) do
        if instance == inInstanceList then
            __instanceList[idx] = nil
            return instance
        end
    end

    consolewarn("[clonereference] Call failed. Instance not found on instance list!")
    return instance
end)

getgenv_c().GetObjects = newcclosure_c(function(assetId)
	local oldId = getIdentity_c()
	setIdentity_c(8)
	local obj = insertservice_LoadLocalAsset(game_getservice(game, "InsertService"), assetId)
	setIdentity_c(oldId)
	return obj
end)
local GetObjects_c = clonefunction_c(getgenv_c().GetObjects)

getgenv_c().hookmetamethod = newcclosure_c(function(t, metamethod, fun)
	local mt = getrawmetatable_c(t)
	if not mt[metamethod] then
		error_c("hookmetamethod: No metamethod found with name " .. metamethod .. " in metatable.")
	end
	return hookfunction_c(mt[metamethod], fun)
end)
local hookmetamethod_c = clonefunction_c(getgenv_c().hookmetamethod)

getgenv_c().require = newcclosure_c(function(moduleScript)
	local old = getIdentity_c()
	setIdentity_c(2)
	local r = rRequire(moduleScript)
	setIdentity_c(old)
	return r
end)

getgenv_c().getnilinstances = newcclosure_c(function()
	local Instances = {}

	for _, Object in pairs(__instanceList) do
		if typeof_c(Object) == "Instance" and Object.Parent == nil then
			table.insert(Instances, Object)
		end
	end

	return Instances
end)

getgenv_c().getinstances = newcclosure_c(function()
	local Instances = {}

	for _, obj in pairs(__instanceList) do
		if typeof_c(obj) == "Instance" then
			table.insert(Instances, obj)
		end
	end

	return Instances
end)

getgenv_c().getscripts = newcclosure_c(function()
    local scripts = {}
    for _, obj in pairs(__instanceList) do
        if typeof_c(obj) == "Instance" and (obj:IsA("ModuleScript") or obj:IsA("LocalScript")) then table.insert(scripts, obj) end
    end
    return scripts
end)

getgenv_c().getloadedmodules = newcclosure_c(function()
    local moduleScripts = {}
    for _, obj in pairs(__instanceList) do
        if typeof_c(obj) == "Instance" and obj:IsA("ModuleScript") then table.insert(moduleScripts, obj) end
    end
    return moduleScripts
end)

getgenv_c().getscriptbytecode = newcclosure_c(function(scr)
    if typeof(scr) ~= "Instance" or not (scr:IsA("ModuleScript") or scr:IsA("LocalScript")) then
        error("Expected script. Got ", typeof_c(script), " Instead.")
    end

	local old = getIdentity_c()
	setIdentity_c(7)
    local b = compile_to_bytecode_c(scr.Source)
	setIdentity_c(old)

    return b
end)

getgenv_c().decompile = newcclosure_c(function(scr)
    if typeof(scr) ~= "Instance" or not (scr:IsA("ModuleScript") or scr:IsA("LocalScript")) then
        error("Expected script. Got ", typeof_c(script), " Instead.")
    end

	local old = getIdentity_c()
	setIdentity_c(7)
    local b = scr.Source:gsub("[^%c%s%g]", "")
	setIdentity_c(old)

    return b
end)

getgenv_c().getscriptclosure = newcclosure_c(function(scr)
    if typeof(scr) ~= "Instance" then
        error("Expected script. Got ", typeof_c(script), " Instead.")
    end

    local candidates = {}

	for _, obj in pairs(getgc(false)) do
		if obj and typeof_c(obj) == "function" then
            local env = getfenv(obj)
            if env.script == scr then
                table.insert(candidates, obj)
            end
		end
	end

    local mostProbableScriptClosure = candidates[1]

    for i, v in candidates do
        if #getfenv(v) < #getfenv(mostProbableScriptClosure) then
            mostProbableScriptClosure = v
        end
    end

	return mostProbableScriptClosure
end)

getgenv_c().getsenv = newcclosure_c(function(scr)
    if typeof(scr) ~= "Instance" then
        error("Expected script. Got ", typeof_c(script), " Instead.")
    end

	for _, obj in pairs(getgc(false)) do
		if obj and typeof_c(obj) == "function" then
            local env = getfenv(obj)
            if env.script == scr then
                return getfenv(obj)
            end
		end
	end

	return {}
end)

getgenv_c().getrunningscripts = newcclosure_c(function()
    local scripts = {}

	for _, obj in pairs(__instanceList) do
		if obj and typeof_c(obj) == "Instance" and obj:IsA("LocalScript") then
            table.insert(scripts, obj)
		end
	end

	return scripts
end)

getgenv_c().vsc_websocket = (function()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	while task.wait(1) do
		local success, client = pcall(WebSocket.connect, "ws://localhost:33882/")
		if success then
			client.OnMessage:Connect(function(payload)
				local callback, exception = loadstring(payload)
				if exception then
					error(exception, 2)
				end

				task.spawn(callback)
			end)

			client.OnClose:Wait()
		end
	end
end)

local illegal = {
	"OpenVideosFolder",
	"OpenScreenshotsFolder",
	"GetRobuxBalance",
	"PerformPurchase",  -- Solves PerformPurchaseV2
	"PromptBundlePurchase",
	"PromptNativePurchase",
	"PromptProductPurchase",
	"PromptPurchase",
    "PromptGamePassPurchase",
    "PromptRobloxPurchase",
	"PromptThirdPartyPurchase",
	"Publish",
	"GetMessageId",
	"OpenBrowserWindow",
    "OpenNativeOverlay",
	"RequestInternal",
	"ExecuteJavaScript",
    "EmitHybridEvent",
    "AddCoreScriptLocal",
    "HttpRequestAsync",
    "ReportAbuse"   -- Avoid bans. | Handles ReportAbuseV3
}

local bannedServices = {
    "BrowserService",
    "HttpRbxApiService",
    "OpenCloudService",
    "MessageBusService",
    "OmniRecommendationsService"
}

local oldNamecall
oldNamecall = hookmetamethod_c(
	game,
	"__namecall",
	newcclosure(function(...)
		if typeof_c(select_c(1, ...)) ~= "Instance" or not checkcaller_c() then
			return oldNamecall(...)
		end

		local namecallName = (getnamecallmethod_c())

        if is_environment_instrumented_c() then
            -- The environment is being instrumented. Print ALL function arguments to replicate the call the exploit environment is making.
            consoleprint_c("---------------------------------------")
            consoleprint_c("--- __NAMECALL INSTRUMENTATION CALL ---")
            consoleprint_c("---------------------------------------")
            local args = { ... }
            consoleprint_c("NAMECALL METHOD NAME: " .. tostring(namecallName))
            consoleprint_c("WITH ARGUMENTS: ")
            consoleprint_c("ARGC: " .. tostring(#args))
            consoleprint_c("SELF (typeof): " .. tostring(typeof_c(select_c(1, ...))))
            consoleprint_c("ARGUMENTS (RECONSTRUCTED TO TABLE): ")
            args[1] = nil
            if #args >= 15 then
                consolewarn_c("Table too big to reconstruct safely!")
            end
            consoleprint_c(reconstruct_table(args))

            consoleprint_c("----------------------------------------")
            consoleprint_c("--- END __INDEX INSTRUMENTATION CALL ---")
            consoleprint_c("----------------------------------------")
        end

		-- If we did a simple table find, as simple as a \0 at the end of the string would bypass our security.
		-- Unacceptable.
		for _, str in pairs_c(illegal) do
			if string_match(string_lower(namecallName), string_lower(str)) then
				return error_c("This function has been disabled for security reasons.")
			end
		end


        for _, str in pairs_c(bannedServices) do
             if string_match(tostring(select(1, ...)), string_lower(str)) then
                return error_c("This service has been removed for safety reasons.")
             end
        end

       if string_match(string_lower(namecallName), string_lower("GetService")) then
            -- GetService, check for banned services
            for _, str in pairs_c(bannedServices) do
			    if string_match(string_lower(select_c(2, ...)), string_lower(str)) then
				    return error_c("This service has been removed for safety reasons.")
			    end
		    end
        end


		if namecallName == "HttpGetAsync" or namecallName == "HttpGet" then
			return HttpGet_c(select_c(2, ...)) -- 1 self, 2 arg (url)
		end

		if namecallName == "HttpPostAsync" or namecallName == "HttpPost" then
			return HttpPost_c(select_c(2, ...)) -- 1 self, 2 arg (url)
		end

		if namecallName == "GetObjects" then
			local a = select_c(2, ...)
			if typeof_c(a) ~= "table" and typeof_c(a) ~= "string" then
				return {}
			end
			return GetObjects_c(a) -- 1 self, 2 arg (table/string)
		end

		return oldNamecall(...)
	end)
)

local oldIndex
oldIndex = hookmetamethod_c(
	game,
	"__index",
	newcclosure(function(...)
		if not checkcaller_c() then
			return oldIndex(...)
		end

        if is_environment_instrumented_c() then
            -- The environment is being instrumented. Print ALL function arguments to replicate the call the exploit environment is making.
            consoleprint_c("------------------------------------")
            consoleprint_c("--- __INDEX INSTRUMENTATION CALL ---")
            consoleprint_c("------------------------------------")

            consoleprint_c("ATTEMPTED TO INDEX: " .. tostring(select_c(1, ...)))
            consoleprint_c("WITH           KEY: " .. tostring(select_c(2, ...)))

            consoleprint_c("----------------------------------------")
            consoleprint_c("--- END __INDEX INSTRUMENTATION CALL ---")
            consoleprint_c("----------------------------------------")
        end

		if typeof_c(select_c(1, ...)) ~= "Instance" or typeof_c(select_c(2, ...)) ~= "string" then
			return oldIndex(...)
		end

		local self = select_c(1, ...)
		local idx = select_c(2, ...)

		-- If we did a simple table find, as simple as a \0 at the end of the string would bypass our security.
		-- Unacceptable.
		for _, str in pairs(illegal) do
			if string_match(idx, str) then
				return error_c("This function has been disabled for security reasons.")
			end
		end

        if string_match(string_lower(idx), string_lower("GetService")) then
            -- Hook GetService, this can be bypassed, but probably no one will bother to, and if they do... too bad.
            return newcclosure(function(s, svc)
                return s:GetService(svc)
            end)
        end

		if idx == "HttpGetAsync" or idx == "HttpGet" then
			return clonefunction_c(HttpGet_c)
		end

		if idx == "HttpPostAsync" or idx == "HttpPost" then
			return clonefunction_c(HttpPost_c)
		end

		if idx == "GetObjects" then
			return clonefunction_c(GetObjects_c)
		end

		return oldIndex(...)
	end)
)
