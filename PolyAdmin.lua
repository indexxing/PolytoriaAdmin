-- PolyAdmin v1.3.2
-- Model made by Index with the help of several people

-- Join the Discord for mentions when the model gets updated, to follow the development, or share feedback such as a suggestion or a bug report here: https://discord.gg/XV6rDrjVkV

local players = game["Players"]
local environment = game["Environment"]
local hidden = game["Hidden"]

local playerDefaults = game["PlayerDefaults"]
local polyAdminModel = script.Parent

local modelNumber = 1.32
local isDevBuild = false

local debug = false
-- ^ Allows for easy debugging

local developerMode = false
-- ^ Do not change this variable in any way as it may break the model

local polyadminResources = Instance.New("Part")
polyadminResources.Size = Vector3.New(0, 0, 0)
polyadminResources.Color = Color.New(polyadminResources.Color.r, polyadminResources.Color.g, polyadminResources.Color.b, 0)
polyadminResources.Anchored = true
polyadminResources.CanCollide = false
polyadminResources.Parent = hidden
polyadminResources.Name = "PolyAdminResources"

local musicFolder = Instance.New("Part")
musicFolder.Size = Vector3.New(0, 0, 0)
musicFolder.Color = Color.New(musicFolder.Color.r, musicFolder.Color.g, musicFolder.Color.b, 0)
musicFolder.Anchored = true
musicFolder.CanCollide = false
musicFolder.Parent = polyAdminModel
musicFolder.Name = "MusicFolder"

for i, v in pairs(polyAdminModel:GetChildren()) do
    if v:IsA("Model") or v:IsA("Tool") then
        if v.Name == "Jail" then
            for i, v in pairs(v:GetChildren()) do
                if v.Name != "Walls" then
                    v.Color = Color.New(v.Color.r, v.Color.g, v.Color.b, 255)
                end
            end
        end
        v.Parent = polyadminResources
    end
end

local permissions = {}
-- To make a user an administrator, get their USER ID & paste it in this table (separate each user ID by a comma)

local protectedusers = {}
-- Users that are protected from severe commands such as kick & ban commands.

local userinfo = {}
-- Stores model-specific information for all players in your game (eg. are they banned? do they have any waypoints, and if so what/where are they?)

local modelSettings = {
    ["Prefix"] = ":",
    -- The prefix cannot be "/" otherwise you won't be able to use commands because Polytoria will use their built-in commands if the message starts with a "/"
    
    ["FreeAdmin"] = false,
    -- Makes every player that joins your game an admin

    ["AdminChatColor"] = Color.FromHex('#1f1f1f'),
    -- Chat color for administrator(s) that join your game that separates them from non-admins in chat

    ["ProtectGameCreator"] = true,
    -- Blocks any severe commands such as kick & ban if the target is the game's creator

    ["ProtectAdmins"] = true,
    -- Blocks any severe commands such as kick & ban if the target is an administrator & the executioner of the command is not the game's creator

    ["ServerlockEnabled"] = false,
    -- Stores if the serverlock is enabled or disabled

    ["ServerlockReason"] = "no reason given",
    -- Stores the reason if serverlock is enabled

    ["DiscoEnabled"] = false,
    -- Stores if the disco is enabled or disabled (do not edit)

    ["HTTPEnabled"] = true,
    -- Toggles HTTP requests of any kind from happening. Some commands will return an error when used if this is set to false

    ["HTTPCapEnabled"] = true,
    -- Enable the HTTP cap

    ["HTTPCap"] = 5,
    -- The limit of HTTP requests the model can make per minute, will be disabled if the "HTTPCapEnabled" setting is set to false

    ["GameCreatorExemptFromHTTPCap"] = true,
    -- Does not increase the HTTP cap when the game creator executes a command, nor does the HTTP cap stop a command if the executer is the game creator

    ["AdminsExemptFromHTTPCap"] = false,
    -- Does not increase the HTTP cap when the administrator executes a command, nor does the HTTP cap stop a command if the executer is the administrator

    ["UpdateNotifierEnabled"] = true
    -- It is recommended you keep this setting on, this uses a HTTP get request to check and notify if your game is out-of-date.
}

local permissions = {}
-- To make a user an admin, get their USER ID & paste it in this table (separate each USER ID by a comma)

local protectedusers = {}
-- Users that are protected from severe commands such as kick & ban commands.

local whitelist = {}
-- Players that are whitelisted from your game if "whitelistEnabled" variable equals true (**COMING SOON**)

local banlist = {}
-- Players that are banned from your game (separate each by a comma)
--[[
BAN FORMAT:

["Ban"] = {
    ["UserID"] = UserIDGoesHere,
    ["Username"] = "UsernameGoesHere",
    ["Time"] = os.date("%A, %B %d, %Y (%X)"),
    ["Length"] = "unban",
    ["Reason"] = "ReasonGoesHere",
    ["Executioner"] = ""
},
--]]

local modelLogs = {}
-- Stores a log of every PolyAdmin action done by a player

local jailcells = {}
-- Stores all jail instances in the game

local commandList = {
    ["utility"] = {
        modelSettings["Prefix"] .. "cmds [utility / moderation / fun]",
        modelSettings["Prefix"] .. "about",
        modelSettings["Prefix"] .. "logs",
        modelSettings["Prefix"] .. "version",
        modelSettings["Prefix"] .. "m [message]",
        modelSettings["Prefix"] .. "tp [plr 1] [plr 2]",
        modelSettings["Prefix"] .. "respawn [plr]",
        modelSettings["Prefix"] .. "damage [plr]",
        modelSettings["Prefix"] .. "kill [plr]",
        modelSettings["Prefix"] .. "jail [plr]",
        modelSettings["Prefix"] .. "unjail [plr]",
        modelSettings["Prefix"] .. "sword [plr]",
        modelSettings["Prefix"] .. "health [plr] [health]",
        modelSettings["Prefix"] .. "heal [plr]",
        modelSettings["Prefix"] .. "forcefield (OR) ff [plr]",
        modelSettings["Prefix"] .. "unforcefield (OR) unff [plr]",
        modelSettings["Prefix"] .. "reset (OR) re [plr]",
        modelSettings["Prefix"] .. "walkspeed (OR) speed [plr] [speed]",
        modelSettings["Prefix"] .. "jumppower (OR) jp [plr] [power]",
        modelSettings["Prefix"] .. "maxhealth [plr] [health]",
        modelSettings["Prefix"] .. "view [plr]",
        modelSettings["Prefix"] .. "unview [plr]",
        modelSettings["Prefix"] .. "freecam [plr]",
        modelSettings["Prefix"] .. "waypoint add [name]",
        modelSettings["Prefix"] .. "waypoint remove [name]",
        modelSettings["Prefix"] .. "waypoint [plr] [name]",
        modelSettings["Prefix"] .. "waypoints [plr]",
        modelSettings["Prefix"] .. "resetcamera (OR) resetcam [plr]",
        modelSettings["Prefix"] .. "notepad"
    },

    ["moderation"] = {
        modelSettings["Prefix"] .. "logs",
        modelSettings["Prefix"] .. "warn [plr] [reason]",
        modelSettings["Prefix"] .. "kick [plr] [reason]",
        modelSettings["Prefix"] .. "ban [plr] [reason]",
        modelSettings["Prefix"] .. "unban [plr]",
        modelSettings["Prefix"] .. "serverlock [LOCKED? true/false] [reason (optional)]",
        modelSettings["Prefix"] .. "userinfo [user ID]",
        modelSettings["Prefix"] .. "userid (OR) uid [plr]",
        modelSettings["Prefix"] .. "admin [plr]",
        modelSettings["Prefix"] .. "unadmin [plr]",
        modelSettings["Prefix"] .. "announce [text]",
    },

    ["fun"] = {
        modelSettings["Prefix"] .. "music play [sound ID] [LOOP? true/false]",
        modelSettings["Prefix"] .. "music stop",
        modelSettings["Prefix"] .. "volume [new volume]",
        modelSettings["Prefix"] .. "pitch [new pitch]",
        modelSettings["Prefix"] .. "explode [plr]",
        modelSettings["Prefix"] .. "blind [plr]",
        modelSettings["Prefix"] .. "unblind [plr]",
        modelSettings["Prefix"] .. "fling [plr]",
        modelSettings["Prefix"] .. "banish [plr]"
    },
}
-- This table is used for the ":help" command to list all commands.

local modelProperties = {
    ["CommandExecutions"] = 0,

    ["PollInfo"] = {
        ["Name"] = "",
        ["Executioner"] = "",
        ["Option1"] = "",
        ["Option2"] = "",
        ["Vote1"] = 0,
        ["Vote2"] = 0
    }
}
-- This table should not be edited ^

-- !!! If you find any command in the code that is not shown in this table, that means the command is not ready to be used & it's highly recommended you not use the command !!!

players.PlayerRemoved:Connect(function (plr)
    local plrInfo = GetModelUserInfo(plr)
    plrInfo = nil
end)

players.PlayerAdded:Connect(function (plr)
    wait(0.5)
    -- Delay the script so that the player can fully load in

    local isBanned = IsBanned(plr)
    if isBanned != false and IsCreator(plr) == true then
        Kick(plr, "banned at " .. isBanned.Time .. " until " .. isBanned.Length .. " for: " .. isBanned.Reason, isBanned.Executioner)
    end

    if IsWhitelisted(plr) == true and IsCreator(plr) == false then
        Kick(plr, "not white-listed", "server")
    end

    if modelSettings["ServerlockEnabled"] == true and IsCreator(plr) == false then
        Kick(plr, "server-lock is enabled: " .. modelSettings["ServerlockReason"], "server")
    end

    if IsModelAdmin(plr) then
        Chat:UnicastMessage("<color=#000>You are an administrator in this game, </color><color=#f50000>" .. plr.Name .. "</color><color=#000>. Do </color><color=#f50000>" .. modelSettings["Prefix"] .. "cmds</color><color=#000> for a list of commands.</color>", plr)
        -- Notify the player that they are an administrator in this game

        plr.ChatColor = modelSettings["AdminChatColor"]
        -- Change the player's chat color to an administrator color

        if IsCreator(plr) == true and modelSettings["UpdateNotifierEnabled"] then
            local ModelUpToDate
            local ModelLink
            Http:Get('https://polyadmin-resources.index01.repl.co/version.json?noCache=' .. math.random(1, 99999), function (data, err, errmsg)
                if not err then
                    local jsonTable = json.parse(data)

                    if debug == true then
                        print("Data Version: " .. jsonTable["version"] .. " (" .. type(jsonTable["version"]) .. ")")
                        print("Model Version Locally: " .. modelNumber .. " (" .. type(modelNumber) .. ")")

                        if modelNumber < jsonTable["version"] then
                            -- Out-of-date
                            Error("debug")
                        else
                            -- Up-to-date
                        end
                    end
                    
                    if modelNumber < jsonTable["version"] then
                        -- Out-of-date
                        ModelUpToDate = false
                    else
                        -- Up-to-date
                        ModelUpToDate = true
                    end

                    -- If model is not up-to-date:
                    if ModelUpToDate == false then
                        Error("PolyAdmin", "The PolyAdmin model used in your game is out-of-date. You can get the up-to-date model here: " .. jsonTable["modelLink"], plr)
                    end
                else
                    print(errmsg)
                end
            end,{})
        end

        if debug == true then
            Success("!console", "PolyAdmin Debug -> " .. plr.Name .. " is an administrator", plr)
        end
    end

    if IsCreator(plr) == true then
        if modelSettings["Prefix"] == "/" then
            Error("PolyAdmin", 'The prefix cannot be "/" as Polytoria will break the script due to their built-in command auto-completion overriding any message that starts with a "/"', plr)
        end

        if isDevBuild == true then
            Error("PolyAdmin", "This is a dev build model. Things in this model may be changed in the final release and you may experience bugs. Please report any bugs or suggestions to the Discord server here: https://discord.gg/XV6rDrjVkV", plr)
        end
    end

    local newUserInfo = {
        ["Info"] = {
            ["Username"] = plr.Name,
            ["Jailed"] = false,
            ["JailModel"] = "",
            ["NotepadContents"] = "",
            ["Waypoints"] = {}
        }
    }

    table.insert(userinfo, #userinfo + 1, newUserInfo.Info)

    local plrInfo = GetModelUserInfo(plr)

    --[[
    local newKeepItemsFolder = Instance.New("Part")
    newKeepItemsFolder.Size = Vector3.New(0.1, 0.1, 0.1)
    newKeepItemsFolder.Anchored = true
    newKeepItemsFolder.CanCollide = false
    newKeepItemsFolder.Parent = playerItems
    newKeepItemsFolder.Name = plr.Name

    plr["Backpack"].ChildAdded:Connect(function(new)
        local getKeepItemsFolder = playerItems:FindChild(plr.Name)
        local clone = new:Clone()
        clone.Parent = getKeepItemsFolder
    end)

    plr["Backpack"].ChildRemoved:Connect(function(removed)
        local getKeepItemsFolder = playerItems:FindChild(plr.Name)
        local getItem = getKeepItemsFolder:FindChild(removed.Name)
        getItem:Destroy()
        -- comment here plz
        wait(0)
        if not tonumber(plr.Health) < 1 then
            local getKeepItemsFolder = playerItems:FindChild(plr.Name)
            local getItem = getKeepItemsFolder:FindChild(removed.Name)
            getItem:Destroy()
        end
    end)

    plr.Respawned:Connect(function ()
        if keepItems == true then
            local getKeepItemsFolder = playerItems:FindChild(plr.Name)

            for i, v in pairs(getKeepItemsFolder:GetChildren()) do
                if v:IsA('Tool') then
                    v.Parent = plr["Backpack"]
                end
            end
        end
    end)
    --]]

    plr.Chatted:Connect(function(msg)
        wait(0)
        -- Delay so the command happens after the message shows in chat

        if debug == true then
            if IsModelAdmin(plr) == true then
                Success("!console", "PolyAdmin Debug -> " .. plr.Name .. " sent a chat message (ADMIN? <color=#37c200>true</color>)", plr)
            else
                Success("!console", "PolyAdmin Debug -> " .. plr.Name .. " sent a chat message (ADMIN? <color=#c20000>false</color>)", plr)
            end
        end
        
        local msg = msg:gsub("<noparse>", " "):gsub("</noparse>", " ")
        -- Remove the <noparse></noparse> to make the msg able to be used in an "if" statement

        if string.find(msg, modelSettings["Prefix"]) then
            local attributes = SplitString(msg)
            attributes[1] = attributes[1]:lower()
            -- Split the msg string by each space

            local MsgIsCommand = false
            
            for i, v in pairs(commandList.utility) do
                if string.find(v, attributes[1]) then
                    MsgIsCommand = true
                    break
                end
            end
            for i, v in pairs(commandList.moderation) do
                if string.find(v, attributes[1]) then
                    MsgIsCommand = true
                    break
                end
            end
            for i, v in pairs(commandList.fun) do
                if string.find(v, attributes[1]) then
                    MsgIsCommand = true
                    break
                end
            end

            if MsgIsCommand == true then
                modelProperties["CommandExecutions"] = modelProperties["CommandExecutions"] + 1

                local newTableInsert = {
                    ["Command"] = {
                        ["User"] = plr,
                        ["Msg"] = msg,
                        ["Time"] = os.date("%A, %B %d, %Y (%X)")
                    },
                }

                table.insert(modelLogs, 1, newTableInsert.Command)

                if debug == true then
                    if MsgIsCommand == true then
                        Success("!console", "PolyAdmin Debug -> Is command registered? Yes (" .. msg .. ")", plr)
                    else
                        Error("!console", "PolyAdmin Debug -> Is command registered? No (" .. msg .. ")", plr)
                    end
                end
            end

            if debug == true then
                Success("!console", "PolyAdmin Debug -> " .. plr.Name .. " executed a command", plr)
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "cmds" and attributes[2] != "utility" and attributes[2] != "moderation" and attributes[2] != "fun" then
                if IsModelAdmin(plr) then
                    Success("cmds", 'What commands would you like to view? ("' .. modelSettings["Prefix"] .. 'cmds [utility/moderation/fun]")', plr)
                end
            end

            if attributes[1] == modelSettings["Prefix"] .. "cmds" and attributes[2] == "utility" then
                if IsModelAdmin(plr) then
                    local cmdsText = ""
        
                    for cmdsTextCheck = 1, #commandList.utility, 1 do
                        if commandList.utility[cmdsTextCheck] then
                            if cmdsTextCheck != 1 then
                                cmdsText = cmdsText .. "<br>" .. commandList.utility[cmdsTextCheck]
                            else
                                cmdsText = cmdsText .. commandList.utility[cmdsTextCheck]
                            end
                        end
                    end
        
                    local newNetworkMessage = NetMessage.New()
                    newNetworkMessage.AddString("gui", "Cmds_Utility")
                    newNetworkMessage.AddString("type", "new")
                    newNetworkMessage.AddString("text", cmdsText)
                    script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, plr)
                end
            end

            if attributes[1] == modelSettings["Prefix"] .. "cmds" and attributes[2] == "moderation" then
                if IsModelAdmin(plr) then
                    local cmdsText = ""
        
                    for cmdsTextCheck = 1, #commandList.moderation, 1 do
                        if commandList.moderation[cmdsTextCheck] then
                            if cmdsTextCheck != 1 then
                                cmdsText = cmdsText .. "<br>" .. commandList.moderation[cmdsTextCheck]
                            else
                                cmdsText = cmdsText .. commandList.moderation[cmdsTextCheck]
                            end
                        end
                    end
        
                    local newNetworkMessage = NetMessage.New()
                    newNetworkMessage.AddString("gui", "Cmds_Moderation")
                    newNetworkMessage.AddString("type", "new")
                    newNetworkMessage.AddString("text", cmdsText)
                    script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, plr)
                end
            end

            if attributes[1] == modelSettings["Prefix"] .. "cmds" and attributes[2] == "fun" then
                if IsModelAdmin(plr) then
                    local cmdsText = ""
        
                    for cmdsTextCheck = 1, #commandList.fun, 1 do
                        if commandList.fun[cmdsTextCheck] then
                            if cmdsTextCheck != 1 then
                                cmdsText = cmdsText .. "<br>" .. commandList.fun[cmdsTextCheck]
                            else
                                cmdsText = cmdsText .. commandList.fun[cmdsTextCheck]
                            end
                        end
                    end
        
                    local newNetworkMessage = NetMessage.New()
                    newNetworkMessage.AddString("gui", "Cmds_Fun")
                    newNetworkMessage.AddString("type", "new")
                    newNetworkMessage.AddString("text", cmdsText)
                    script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, plr)
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "devhelp" then
                if IsModelAdmin(plr) then
                    local devCommandList = {
                        modelSettings["Prefix"] .. "whitelist",
                        modelSettings["Prefix"] .. "whitelist enable",
                        modelSettings["Prefix"] .. "whitelist disable",
                        modelSettings["Prefix"] .. "whitelist add",
                        modelSettings["Prefix"] .. "whitelist remove",
                        modelSettings["Prefix"] .. "whitelist check",
                        modelSettings["Prefix"] .. "clickteleport",
                        modelSettings["Prefix"] .. "chatcolor",
                        modelSettings["Prefix"] .. "godmode"
                    }
        
                    Chat:UnicastMessage('<color=#000><b>List of In-Development Commands</b> (' .. #devCommandList .. ' commands available)<b>:</b></color>', plr)
                    for i, v in pairs(devCommandList) do
                        Chat:UnicastMessage(v, plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "serverinfo" then
                if IsModelAdmin(plr) then
                    Chat:UnicastMessage('<color=#000><b>Server Information:</b></color=#000>', plr)
                    Chat:UnicastMessage('<b>Server Length:</b> ' .. polyAdminModel["Runtime_Hour"].Value .. ' hour(s), ' .. polyAdminModel["Runtime_Minute"].Value .. ' minute(s), & ' .. polyAdminModel["Runtime_Second"].Value .. ' second(s)', plr)
                    Chat:UnicastMessage('<b>Server Player Count:</b> ' .. game.PlayersConnected .. ' player(s)', plr)
                    Chat:UnicastMessage('<b>Command Executions:</b> ' .. modelProperties["CommandExecutions"] .. '', plr)
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "about" then
                local newNetworkMessage = NetMessage.New()
                newNetworkMessage.AddString("gui", "About")
                newNetworkMessage.AddString("type", "new")
                --newNetworkMessage.AddNumber("version", modelNumber)
                script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, plr)
        
                --[[
                Chat:UnicastMessage('<color=#000>About PolyAdmin (v' .. modelNumber .. '):</color>', plr)
                Chat:UnicastMessage('PolyAdmin is a model available on Polytoria that allows for moderation, utility, & fun commands made by Index.', plr)
                Chat:UnicastMessage('Thank you to Vibin <color=#007bff>(https://polytoria.com/user/20547)</color> for updated jail command!', plr)
                Chat:UnicastMessage('Thank you to Iaceon <color=#007bff>(https://polytoria.com/user/15952)</color> for many suggestions!', plr)
                --]]
            end

            if attributes[1] == modelSettings["Prefix"] .. "changelog" then
                local newNetworkMessage = NetMessage.New()
                newNetworkMessage.AddString("gui", "Changelog")
                newNetworkMessage.AddString("type", "new")
                script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, plr)
            end

            if attributes[1] == modelSettings["Prefix"] .. "logs" then
                if IsModelAdmin(plr) then
                    if #modelLogs > 0 then
                        Chat:UnicastMessage('<color=#000><b>Command Log(s):</b></color=#000>', plr)
                        for i, v in pairs(modelLogs) do
                            Chat:UnicastMessage('<color=#262626><b>' .. v.User.Name .. '</b> (' .. v.Time .. '):</color>', plr)
                            Chat:UnicastMessage(v.Msg, plr)
                        end
                    else
                        Error("logs", "There are no logs available to show", plr)
                    end
                end
            end

            if attributes[1] == modelSettings["Prefix"] .. "notepad" then
                --Error("notepad", "This command is disable due to security reasons", plr)

                local getUserInfo = GetModelUserInfo(plr)

                local newNetworkMessage = NetMessage.New()
                newNetworkMessage.AddString("gui", "Notepad")
                newNetworkMessage.AddString("type", "new")
                newNetworkMessage.AddString("NotepadContents", plrInfo["NotepadContents"])
                script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, plr)
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "kick" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player != plr then
                            local reason = ""
        
                            for reasonCheck = 3, #attributes, 1 do
                                if attributes[reasonCheck] then
                                    if reasonCheck != 3 then
                                        reason = reason .. " " .. attributes[reasonCheck]
                                    else
                                        reason = reason .. attributes[reasonCheck]
                                    end
                                end
                            end
            
                            if reason == "" then
                                reason = "no reason given"
                            end
            
                            if player then
                                Kick(player, reason, plr)
                            else
                                Error("kick", "That player does not exist", plr)
                            end
                        else
                            Error("kick", "You cannot kick yourself", plr)
                        end
                    else
                        Error("kick", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "ban" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
                        
                        if player != plr then
                            local reason = ""
        
                            for reasonCheck = 3, #attributes, 1 do
                                if attributes[reasonCheck] then
                                    if reasonCheck != 2 then
                                        reason = reason .. " " .. attributes[reasonCheck]
                                    else
                                        reason = reason .. attributes[reasonCheck]
                                    end
                                end
                            end
            
                            if reason == "" then
                                reason = "no reason given"
                            end
        
                            if player then
                                Ban(player, reason, plr)
                            else
                                Error("ban", "That player does not exist", plr)
                            end
                        else
                            Error("ban", "You cannot ban yourself", plr)
                        end
                    else
                        Error("ban", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "shutdown" then
                if IsModelAdmin(plr) then
                    local reason = ""
        
                    for reasonCheck = 2, #attributes, 1 do
                        if attributes[reasonCheck] then
                            if reasonCheck != 2 then
                                reason = reason .. " " .. attributes[reasonCheck]
                            else
                                reason = reason .. attributes[reasonCheck]
                            end
                        end
                    end
        
                    if reason == "" then
                        reason = "no reason given"
                    end
        
                    Shutdown(plr, reason)
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "unban" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        Unban(attributes[2])
                    end
                end
            end

            if attributes[1] == modelSettings["Prefix"] .. "poll" and attributes[2] == modelSettings["Prefix"] .. "create" then
                if IsModelAdmin(plr) then
                    if attributes[3] and attributes[4] and attributes[5] then
                        local player = GetPlayer(attributes[3])

                        if player then
                            modelProperties.PollInfo.Name = attributes[3]
                            modelProperties.PollInfo.Executioner = plr
                            modelProperties.PollInfo.Option1 = attributes[4]
                            modelProperties.PollInfo.Option2 = attributes[5]
                            modelProperties.PollInfo.Vote1 = 0
                            modelProperties.PollInfo.Vote2 = 0

                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    Chat:UnicastMessage(attributes[3] .. ' (poll started by ' .. plr .. ')', v)
                                    Chat:UnicastMessage('Option #1: ' .. attributes[4], v)
                                    Chat:UnicastMessage('Option #2: ' .. attributes[5], v)
                                    Chat:UnicastMessage('To vote, chat "' .. modelSettings["Prefix"] .. 'vote [1 or 2]"' .. attributes[5], v)
                                end
                            else
                                Chat:UnicastMessage(attributes[3] .. ' (poll started by ' .. plr .. ')', player)
                                Chat:UnicastMessage('Option #1: ' .. attributes[4], player)
                                Chat:UnicastMessage('Option #2: ' .. attributes[5], player)
                                Chat:UnicastMessage('To vote, chat "' .. modelSettings["Prefix"] .. 'vote [1 or 2]"' .. attributes[5], player)
                            end
                        else
                            Error("poll create", "That player does not exist", plr)
                        end
                    else
                        Error("poll create", "Missing Attributes", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "whitelist" then
                if IsModelAdmin(plr) then
                    local whitelistToPrint = 0
                    for i, v in pairs(whitelist) do
                        if v then
                            whitelistToPrint = whitelistToPrint .. ", " .. v
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "whitelist" and attributes[2] == "enable" then
                if IsModelAdmin(plr) then
                    modelSettings["whitelistEnabled"] = true
                    Success("whitelist enable", "White-list has been enabled", plr)
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "whitelist" and attributes[2] == "disable" then
                if IsModelAdmin(plr) then
                    modelSettings["whitelistEnabled"] = false
                    Success("whitelist disable", "White-list has been disabled", plr)
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "whitelist" and attributes[2] == "add" then
                if IsModelAdmin(plr) then
                    if attributes[3] then
                        local player = GetPlayer(attributes[3])
        
                        if player then
                            AddToWhitelist(player)
                        else
                            Error("whitelist add", "That player does not exist", plr)
                        end
                    else
                        Error("whitelist add", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "whitelist" and attributes[2] == "remove" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[3])
        
                        if player then
                            RemoveFromWhitelist(player)
                        else
                            Error("whitelist remove", "That player does not exist", plr)
                        end
                    else
                        Error("whitelist remove", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "whitelist" and attributes[2] == "check" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[3])
        
                        if player then
                            Success("[" .. attributes[1] .. " " .. attributes[2] .. "] " .. IsWhitelisted(player))
                        else
                            Error("whitelist check", "That player does not exist", plr)
                        end
                    else
                        Error("whitelist check", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "isadmin" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if modelSettings["FreeAdmin"] == false then
                                if IsModelAdmin(player) == true then
                                    Chat:UnicastMessage('<color=#37c200>' .. player.Name .. ' is an admin.</color>', plr)
                                else
                                    Chat:UnicastMessage('<color=#fa0000>' .. player.Name .. ' is NOT an admin.</color>', plr)
                                end
                            else
                                Chat:UnicastMessage('<color=#37c200>' .. player.Name .. ' is an admin [Free admin is enabled].</color>', plr)
                            end
                        else
                            Error("isadmin", "That player does not exist", plr)
                        end
                    else
                        Error("isadmin", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "announce" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local reason = ""
        
                        for reasonCheck = 2, #attributes, 1 do
                            if attributes[reasonCheck] then
                                if reasonCheck != 2 then
                                    reason = reason .. " " .. attributes[reasonCheck]
                                else
                                    reason = reason .. attributes[reasonCheck]
                                end
                            end
                        end
        
                        if reason == "" then
                            reason = "no reason given"
                        end
        
                        Chat:BroadcastMessage("<color=#000>[Announcement by " .. plr.Name .. "]:</color> <color=#f50000>" .. reason .. "</color>")
                    else
                        Error("announce", "Requires a valid announcement (string) argument.")
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "tp" then
                if IsModelAdmin(plr) then
                    if attributes[2] and attributes[3] then
                        local player1 = GetPlayer(attributes[2], plr)
                        local player2 = GetPlayer(attributes[3], plr)
        
                        TP(player1, player2, plr)
                    else
                        Error("tp", "Requires 2 valid player arguments", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "bring" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player2 = GetPlayer(attributes[2], plr)
        
                        TP(player2, plr, plr)
                    else
                        Error("bring", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "to" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player2 = GetPlayer(attributes[2], plr)
        
                        TP(plr, player2, plr)
                    else
                        Error("to", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "explode" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
                            
                        Explode(player)
                    else
                        Error("explode", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "clickteleport" then
                if IsModelAdmin(plr) then
                    local newToolClone = polyadminResources:FindChild('ClickTeleport'):Clone()
                    newToolClone.Parent = plr["Backpack"]
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "respawn" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if type(player) == "table" then
                            for i, v in pairs(player) do
                                if v:IsA('Player') then
                                    v:Respawn()
                                end
                            end
                        else
                            player:Respawn()
                        end
                    else
                        Error("respawn", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "jail" then
                if IsModelAdmin(plr) then
                    local player = GetPlayer(attributes[2], plr)
        
                    Jail(player)
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "unjail" then
                if IsModelAdmin(plr) then
                    local player = GetPlayer(attributes[2], plr)
        
                    Unjail(player)
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "sword" then
                if IsModelAdmin(plr) then
                    local player = GetPlayer(attributes[2], plr)
                        
                    if type(player) == "table" then
                        for i, v in pairs(player) do
                            local newToolClone = polyadminResources:FindChild('Sword'):Clone()
                            newToolClone.Parent = v["Backpack"]
                        end
                    else
                        local newToolClone = polyadminResources:FindChild('Sword'):Clone()
                        newToolClone.Parent = player["Backpack"]
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "music" and attributes[2] == "play" then
                if IsModelAdmin(plr) then
                    if attributes[1] and attributes[2] and attributes[3] then
                        if type(tonumber(attributes[3])) == "number" then
                            for i, v in pairs(musicFolder:GetChildren()) do
                                if v:IsA('Sound') then
                                    v:Stop()
                                end
                            end
        
                            local cachedSoundCheck = SoundIsCached(tonumber(attributes[3]))
        
                            if cachedSoundCheck == false then
                                local newMusic = Instance.New('Sound')
                                newMusic.SoundID = tonumber(attributes[3])
        
                                newMusic.Volume = 5
                                newMusic.Pitch = 1
        
                                if attributes[4] == "true" then
                                    newMusic.Loop = true
                                else
                                    newMusic.Loop = false
                                end
        
                                newMusic.Parent = musicFolder
                                newMusic:Play()
        
                                wait(0)
                                Chat:BroadcastMessage("<color=#37c200>Now playing: " .. newMusic.SoundID .. " started by " .. plr.Name .. ".</color>")
                            else
                                if attributes[4] == "true" then
                                    cachedSoundCheck.Loop = true
                                else
                                    cachedSoundCheck.Loop = false
                                end
        
                                cachedSoundCheck.Volume = 5
                                cachedSoundCheck.Pitch = 1
                                
                                cachedSoundCheck:Play()
        
                                wait(0)
                                Chat:BroadcastMessage("<color=#37c200>Now playing: " .. cachedSoundCheck.SoundID .. " started by " .. plr.Name .. ".</color>")
                            end
                        else
                            Error("music play", "Sound ID must be a number", plr)
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "music" and attributes[2] == "stop" then
                if IsModelAdmin(plr) then
                    if attributes[1] and attributes[2] then
                        for i, v in pairs(musicFolder:GetChildren()) do
                            if v:IsA('Sound') then
                                v:Stop()
                            end
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "volume" then
                if IsModelAdmin(plr) then
                    if attributes[1] and attributes[2] then
                        for i, v in pairs(musicFolder:GetChildren()) do
                            if v:IsA('Sound') then
                                if v.Playing == true then
                                    local oldVolume = v.Volume
                                    v.Volume = tonumber(attributes[2])
        
                                    if v.Volume == tonumber(attributes[2]) then
                                        Chat:BroadcastMessage("<color=#37c200>Updated Volume: " .. oldVolume .. " to " .. v.Volume .. " by " .. plr.Name .. ".</color>")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "pitch" then
                if IsModelAdmin(plr) then
                    if attributes[1] and attributes[2] then
                        for i, v in pairs(musicFolder:GetChildren()) do
                            if v:IsA('Sound') then
                                if v.Playing == true then
                                    local oldPitch = v.Pitch
                                    v.Pitch = tonumber(attributes[2])
        
                                    if v.Pitch == tonumber(attributes[2]) then
                                        Chat:BroadcastMessage("<color=#37c200>Updated Pitch: " .. oldPitch .. " to " .. v.Pitch .. " by " .. plr.Name .. ".</color>")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "health" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if attributes[3] then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        v.Health = tonumber(attributes[3])
                                    end
                                end
                            else
                                player.Health = tonumber(attributes[3])
                            end
                        else
                            Error("health", "Health attribute must be a number", plr)
                        end
                    else
                        Error("health", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "heal" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        v.Health = v.MaxHealth
                                    end
                                end
                            else
                                player.Health = player.MaxHealth
                            end
                        else
                            Error("heal", "That player does not exist", plr)
                        end
                    else
                        Error("heal", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "damage" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if attributes[3] then
                                if type(player) == "table" then
                                    for i, v in pairs(player) do
                                        if v:IsA('Player') then
                                            v.Health = v.Health - attributes[3]
                                        end
                                    end
                                else
                                    player.Health = player.Health - attributes[3]
                                end
                            else
                                Error("damage", "Damage attribute must be a number", plr)
                            end
                        else
                            Error("damage", "That player does not exist", plr)
                        end
                    else
                        Error("damage", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "kill" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        v.Health = 0
                                    end
                                end
                            else
                                player.Health = 0
                            end
                        else
                            Error("kill", "That player does not exist", plr)
                        end
                    else
                        Error("kill", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "walkspeed" or attributes[1] == modelSettings["Prefix"] .. "speed" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if attributes[3] then
                                if type(tonumber(attributes[3])) == "number" then
                                    if type(player) == "table" then
                                        for i, v in pairs(player) do
                                            if v:IsA('Player') then
                                                v.WalkSpeed = tonumber(attributes[3])
                                                v.SprintSpeed = tonumber(attributes[3])
                                            end
                                        end
                                    else
                                        player.WalkSpeed = tonumber(attributes[3])
                                        player.SprintSpeed = tonumber(attributes[3])
                                    end
                                else
                                    if attributes[3] == "reset" then
                                        if type(player) == "table" then
                                            for i, v in pairs(player) do
                                                if v:IsA('Player') then
                                                    v.WalkSpeed = playerDefaults.WalkSpeed
                                                    v.SprintSpeed = playerDefaults.SprintSpeed
                                                end
                                            end
                                        else
                                            player.WalkSpeed = playerDefaults.WalkSpeed
                                            player.SprintSpeed = playerDefaults.SprintSpeed
                                        end
                                    else
                                        Error("walkspeed", "Requires a number argument for the specified walk speed", plr)
                                    end
                                end
                            else
                                Error("walkspeed", "WalkSpeed attribute must be a number", plr)
                            end
                        else
                            Error("walkspeed", "That player does not exist", plr)
                        end
                    else
                        Error("walkspeed", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "jumppower" or attributes[1] == modelSettings["Prefix"] .. "jp" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if attributes[3] then
                                if type(tonumber(attributes[3])) == "number" then
                                    if type(player) == "table" then
                                        for i, v in pairs(player) do
                                            if v:IsA('Player') then
                                                v.JumpPower = tonumber(attributes[3])
                                            end
                                        end
                                    else
                                        player.JumpPower = tonumber(attributes[3])
                                    end
                                else
                                    if attributes[3] == "reset" then
                                        if type(player) == "table" then
                                            for i, v in pairs(player) do
                                                if v:IsA('Player') then
                                                    v.JumpPower = playerDefaults.JumpPower
                                                end
                                            end
                                        else
                                            player.JumpPower = playerDefaults.JumpPower
                                        end 
                                    else
                                        Error("jumppower", "Requires a number argument for the specified jump power", plr)
                                    end
                                end
                            else
                                Error("jumppower", "JumpPower attribute must be a number", plr)
                            end
                        else
                            Error("jumppower", "That player does not exist", plr)
                        end
                    else
                        Error("jumppower", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "freecam" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        local newNetworkMessage = NetMessage.New()
                        newNetworkMessage.AddString("gui", "FreecamModify")
                        newNetworkMessage.AddString("type", "new")
        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        --[[
                                        local newNetworkMessage = NetMessage.New()
                                        newNetworkMessage.AddString("camType", "free")
                                        script.Parent["CameraUpdate"].InvokeClient(newNetworkMessage, v)
                                        --]]
                                        script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, v)
        
                                        Chat:UnicastMessage('[' .. modelSettings["Prefix"] .. 'freecam] To exit free camera mode, type "' .. modelSettings["Prefix"] .. 'reset" to completely reset your player or "' .. modelSettings["Prefix"] .. 'resetcamera" to just reset your camera.', v)
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    local newNetworkMessage = NetMessage.New()
                                    newNetworkMessage.AddString("gui", "FreecamModify")
                                    newNetworkMessage.AddString("type", "new")
                                    script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, player)
        
                                    Chat:UnicastMessage('[' .. modelSettings["Prefix"] .. 'freecam] To exit free camera mode, type "' .. modelSettings["Prefix"] .. 'reset" to completely reset your player or "' .. modelSettings["Prefix"] .. 'resetcamera" to just reset your camera.', player)
                                end
                            end
                        else
                            Error("freecam", "That player does not exist", plr)
                        end
                    else
                        Error("freecam", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "reset" or attributes[1] == modelSettings["Prefix"] .. "re" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            resetPlayer(player)
                        else
                            Error("reset", "That player does not exist", plr)
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "resetcamera" or attributes[1] == modelSettings["Prefix"] .. "resetcam" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        local newNetworkMessage = NetMessage.New()
                                        newNetworkMessage.AddString("camType", "default")
                                        script.Parent["CameraUpdate"].InvokeClient(newNetworkMessage, v)
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    local newNetworkMessage = NetMessage.New()
                                    newNetworkMessage.AddString("camType", "default")
                                    script.Parent["CameraUpdate"].InvokeClient(newNetworkMessage, player)
                                end
                            end
                        else
                            Error("resetcamera", "That player does not exist", plr)
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "freeze" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        v.CanMove = false
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    player.CanMove = false
                                end
                            end
                        else
                            Error("freeze", "That player does not exist", plr)
                        end
                    else
                        Error("freeze", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "unfreeze" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        v.CanMove = true
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    player.CanMove = true
                                end
                            end
                        else
                            Error("unfreeze", "That player does not exist", plr)
                        end
                    else
                        Error("unfreeze", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "chat" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            local message = ""
        
                            for messageCheck = 3, #attributes, 1 do
                                if attributes[messageCheck] then
                                    if messageCheck != 3 then
                                        message = message .. " " .. attributes[messageCheck]
                                    else
                                        message = message .. attributes[messageCheck]
                                    end
                                end
                            end
        
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        Chat:BroadcastMessage("*" .. v.Name .. ": " .. message)
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    Chat:BroadcastMessage("*" .. player.Name .. ": " .. message)
                                end
                            end
                        else
                            Error("chat", "That player does not exist", plr)
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "chatcolor" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        if IsModelAdmin(v) == false then
                                            v.ChatColor = Color.FromHex(attributes[3])
                                        else
                                            Chat:UnicastMessage("That player's chat color cannot be modify as they are an administrator.", plr)
                                        end
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    if IsModelAdmin(v) == false then
                                        player.ChatColor = Color.FromHex(attributes[3])
                                    else
                                        Chat:UnicastMessage("That player's chat color cannot be modify as they are an administrator.", plr)
                                    end
                                end
                            end
                        else
                            Error("chatcolor", "That player does not exist", plr)
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "userinfo" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        if modelSettings["HTTPEnabled"] == true then
                            if GetHTTPCap() == false then
                                local jsonTable = ""
    
                                IncreaseHTTPCap()

                                Http:Get('https://api.polytoria.com/v1/users/getbyusername?username=' .. attributes[2], function (data, err, errmsg)
                                    if not err then
                                        local newData = ""
                                        local splitdata = SplitString(data, "\\//")
                                        for i, v in pairs(splitdata) do
                                            if v != splitdata[1] then
                                                newData = newData .. "/" .. v
                                            else
                                                newData = newData .. v
                                            end
                                        end
            
                                        jsonTable = json.parse(newData)

                                        if jsonTable["Success"] == true then
                                            local newNetworkMessage = NetMessage.New()
                                            newNetworkMessage.AddString("gui", "UserInfo")
                                            newNetworkMessage.AddString("type", "new")
                                            newNetworkMessage.AddString("json", newData)
                                            script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, plr)
                                        else
                                            Error("userinfo", "That player does not exist", plr)
                                        end
                                    else
                                        print(errmsg)
                                        Error("userinfo", "Failure to get user information", plr)
                                    end
                                end,{})

                                wait(1)
            
                                --[[
                                if jsonTable["Success"] == true then

                                    --[[
                                    Chat:UnicastMessage('<color=#000>User Information for ' .. jsonTable["Username"] .. ':</color>', plr)
                                    Chat:UnicastMessage('Username: ' .. jsonTable["Username"], plr)
                                    Chat:UnicastMessage('User ID: ' .. jsonTable["ID"], plr)
                                    Chat:UnicastMessage('Description: ' .. jsonTable["Description"], plr)
                                    Chat:UnicastMessage('Forum Signature: ' .. jsonTable["Signature"], plr)
                                    Chat:UnicastMessage('Membership Type:' .. jsonTable["MembershipType"], plr)
                                    Chat:UnicastMessage('---', plr)
                                    Chat:UnicastMessage('Profile Views: ' .. jsonTable["ProfileViews"], plr)
                                    Chat:UnicastMessage('Item Sales: ' .. jsonTable["ItemSales"], plr)
                                    Chat:UnicastMessage('Forum Posts: ' .. jsonTable["ForumPosts"], plr)
                                    Chat:UnicastMessage('Trade Value: ' .. jsonTable["TradeValue"], plr)
                                    Chat:UnicastMessage('---', plr)
                                    Chat:UnicastMessage('Join Date: ' .. jsonTable["JoinedAt"], plr)
                                    Chat:UnicastMessage('Last Online: ' .. jsonTable["LastSeenAt"], plr)
                                else
                                    Error("userinfo", "That player does not exist", plr)
                                end
                                --]]
                            else
                                Error("userinfo", "HTTP limit of " .. modelSettings["HTTPCap"] .. " has been met, please wait a minute before trying this command again.", plr)
                            end
                        else
                            Error("userinfo", "HTTP requests have been disabled by the game creator.", plr)
                        end
                    else
                        Error("userinfo", "Requires a valid user ID (number) attribute", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "userid" or attributes[1] == modelSettings["Prefix"] .. "uid" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        Success("userid", v.Name .. "'s user ID is " .. v.UserID, plr)
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    Success("userid", player.Name .. "'s user ID is " .. player.UserID, plr)
                                end
                            end
                        else
                            if GetHTTPCap() == false then
                                if modelSettings["HTTPEnabled"] == true then
                                
                                    IncreaseHTTPCap()
                        
                                    Http:Get('https://api.polytoria.com/v1/users/getbyusername?username=' .. attributes[2], function (data, err, errmsg)
                                        if not err then
                                            local newData = ""
                                            local splitdata = SplitString(data, "\\//")
                                            for i, v in pairs(splitdata) do
                                                if v != splitdata[1] then
                                                    newData = newData .. "/" .. v
                                                else
                                                    newData = newData .. v
                                                end
                                            end
                            
                                            local jsonTable = json.parse(newData)

                                            if jsonTable["Success"] == true then
                                                Success("userid", jsonTable["Username"] .. "'s user ID is " .. jsonTable["ID"], plr)
                                            else
                                                Error("userid", "That player does not exist", plr)
                                            end
                                        else
                                            Error("!console", "Error during HTTP Get: " .. errmsg, plr)
                                        end
                                    end,{})

                                    wait(5)
                                else
                                    Error("PolyAdmin", "HTTP limit of " .. modelSettings["HTTPCap"] .. " has been met, please wait a minute before trying this command again", executioner)
                                end
                            else
                                Error("PolyAdmin", "HTTP requests have been disabled by the game creator", executioner)
                            end
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "respawntime" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if attributes[3] then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        v.RespawnTime = tonumber(attributes[3])
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    player.RespawnTime = tonumber(attributes[3])
                                end
                            end
                        else
                            Error("respawntime", "RespawnTime attribute must be a number", plr)
                        end 
                    else
                        Error("respawntime", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "sit" then
                if IsModelAdmin(plr) then
                    local player = GetPlayer(attributes[2], plr)
        
                    Sit(player)
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "createtext" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if attributes[3] then
                            local newText = Instance.New('Text3D')
        
                            local message = ""
        
                            for messageCheck = 2, #attributes, 1 do
                                if attributes[messageCheck] then
                                    if messageCheck != 2 then
                                        reason = reason .. " " .. attributes[messageCheck]
                                    else
                                        reason = reason .. attributes[messageCheck]
                                    end
                                end
                            end
        
                            newText.Position = player.Position
                            newText.Rotation = player.Rotation
                            newText.Text = message
                        else
                            Error("createtext", "Text attribute must be a string", plr)
                        end
                    else
                        Error("createtext", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "message" or attributes[1] == modelSettings["Prefix"] .. "msg" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if attributes[3] then
                                local message = ""
        
                                for messageCheck = 2, #attributes, 1 do
                                    if attributes[messageCheck] then
                                        if messageCheck != 2 then
                                            message = message .. " " .. attributes[messageCheck]
                                        else
                                            message = message .. attributes[messageCheck]
                                        end
                                    end
                                end
        
                                if type(player) == "table" then
                                    for i, v in pairs(player) do
                                        if v:IsA('Player') then
                                            Chat:UnicastMessage("<color=#000>[Message from " .. plr.Name .. "]:</color> <color=c20000>" .. message .. "</color>", v)
                                        end
                                    end
                                else
                                    Chat:UnicastMessage("<color=#000>[Message from " .. plr.Name .. "]</color> <color=c20000>" .. message .. "</color>", player)
                                end
                            else
                                Error("message", "Message attribute must be a string", plr)
                            end
                        else
                            Error("message", "That player does not exist", plr)
                        end
                    else
                        Error("message", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "maxhealth" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if attributes[3] then
                                if type(tonumber(attributes[3])) == "number" then
                                    if type(player) == "table" then
                                        for i, v in pairs(player) do
                                            if v:IsA('Player') then
                                                v.MaxHealth = tonumber(attributes[3])
        
                                                if v.Health < v.MaxHealth then
                                                    v.Health = v.MaxHealth
                                                end
                                            end
                                        end
                                    else
                                        if player:IsA('Player') then
                                            player.MaxHealth = tonumber(attributes[3])
        
                                            if player.Health < player.MaxHealth then
                                                player.Health = player.MaxHealth
                                            end
                                        end
                                    end
                                else
                                    if attributes[3] == "reset" then
                                        if type(player) == "table" then
                                            for i, v in pairs(player) do
                                                if v:IsA('Player') then
                                                    v.MaxHealth = playerDefaults["MaxHealth"]
                                                end
                                            end
                                        else
                                            if player:IsA('Player') then
                                                player.MaxHealth = playerDefaults["MaxHealth"]
                                            end
                                        end
                                    else
                                        Error("maxhealth", "Requires a number argument for the specified max health", plr)
                                    end
                                end
                            else
                                Error("maxhealth", "MaxHealth attribute must be a number", plr)
                            end
                        else
                            Error("maxhealth", "That player does not exist", plr)
                        end
                    else
                        Error("maxhealth", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "cleartools" or attributes[1] == modelSettings["Prefix"] .. "notools" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        for i, v in pairs(v["Backpack"]:GetChildren()) do
                                            if v:IsA('Tool') then
                                                v:Destroy()
                                            end
                                        end
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    for i, v in pairs(player["Backpack"]:GetChildren()) do
                                        if v:IsA('Tool') then
                                            v:Destroy()
                                        end
                                    end
                                end
                            end
                        else
                            Error("cleartools", "That player does not exist", plr)
                        end
                    else
                        Error("cleartools", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "droptool" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if type(player) == "table" then
                            for i, v in pairs(player) do
                                if v:IsA('Player') then
                                    --v:DropTools()
                                end
                            end
                        else
                            if player:IsA('Player') then
                                --[[
                                for i, v in pairs(player["Backpack"]) do
                                    if v:IsA('Tool') then
                                        v.Position = Vector3.New(player.Position.X, 0, 0)
                                        v.Parent = environment
                                    end
                                end
                                --]]
        
                                player:DropTools()
                            end
                        end
                    else
                        Error("droptool", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "godmode" then
                if IsModelAdmin(plr) then
                    local newToolClone = polyadminResources:FindChild('GodMode-Explosion'):Clone()
                    newToolClone.Parent = plr["Backpack"]
                end
            end
        
            --[[
            if attributes[1] == modelSettings["Prefix"] .. "logs" then
                if IsModelAdmin(plr) then
                    local playergui = plr["PlayerGUI"]
                    local logsGUI = playergui["Logs"]
        
                    logsGUI.Visible = true
                end
            end
            --]]
        
            if attributes[1] == modelSettings["Prefix"] .. "forcefield" or attributes[1] == modelSettings["Prefix"] .. "ff" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if type(player) == "table" then
                            for i, v in pairs(player) do
                                if v:IsA('Player') then
                                    v.MaxHealth = 10000000000000000000000000
                                    v.Health = v.MaxHealth
                                    --[[
                                    if not environment:FindChild(v.UserID .. '_Forcefield') then
                                        local newPart = Instance.New("Part")
                                        newPart.Size = Vector3.New(0.1, 0.1, 0.1)
                                        newPart.Anchored = true
                                        newPart.CanCollide = false
                                        newPart.Parent = environment
                                        newPart.Name = v.UserID .. "_Forcefield"
        
                                        while v.Health < v.MaxHealth do
                                            if environment:FindChild(v.UserID .. '_Forcefield') then
                                                v.Health = v.MaxHealth
                                            else
                                                return
                                            end
                                        end
                                    end
                                    --]]
                                end
                            end
                        else
                            if player:IsA('Player') then
                                player.MaxHealth = 10000000000000000000000000
                                player.Health = player.MaxHealth
                                --[[
                                if not environment:FindChild(player.UserID .. '_Forcefield') then
                                    local newPart = Instance.New("Part")
                                    newPart.Size = Vector3.New(0, 0, 0)
                                    newPart.CanCollide = false
                                    newPart.Anchored = true
                                    newPart.Parent = environment
                                    newPart.Name = player.UserID .. "_Forcefield"
        
                                    while player.Health < player.MaxHealth do
                                        if environment:FindChild(player.UserID .. '_Forcefield') then
                                            player.Health = player.MaxHealth
                                        else
                                            return
                                        end
                                    end
                                end
                                --]]
                            end
                        end
                    else
                        Error("forcefield", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "unforcefield" or attributes[1] == modelSettings["Prefix"] .. "unff" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if type(player) == "table" then
                            for i, v in pairs(player) do
                                if v:IsA('Player') then
                                    v.MaxHealth = playerDefaults.MaxHealth
                                    v.Health = v.MaxHealth
                                    --[[
                                    if not environment:FindChild(v.UserID .. '_Forcefield') then
                                        local newPart = Instance.New("Part")
                                        newPart.Size = Vector3.New(0.1, 0.1, 0.1)
                                        newPart.Anchored = true
                                        newPart.CanCollide = false
                                        newPart.Parent = environment
                                        newPart.Name = v.UserID .. "_Forcefield"
        
                                        while v.Health < v.MaxHealth do
                                            if environment:FindChild(v.UserID .. '_Forcefield') then
                                                v.Health = v.MaxHealth
                                            else
                                                return
                                            end
                                        end
                                    end
                                    --]]
                                end
                            end
                        else
                            if player:IsA('Player') then
                                player.MaxHealth = playerDefaults.MaxHealth
                                player.Health = player.MaxHealth
                                --[[
                                if not environment:FindChild(player.UserID .. '_Forcefield') then
                                    local newPart = Instance.New("Part")
                                    newPart.Size = Vector3.New(0, 0, 0)
                                    newPart.CanCollide = false
                                    newPart.Anchored = true
                                    newPart.Parent = environment
                                    newPart.Name = player.UserID .. "_Forcefield"
        
                                    while player.Health < player.MaxHealth do
                                        if environment:FindChild(player.UserID .. '_Forcefield') then
                                            player.Health = player.MaxHealth
                                        else
                                            return
                                        end
                                    end
                                end
                                --]]
                            end
                        end
                    else
                        Error("unforcefield", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "playercollisions" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        if attributes[2] == "true" then
                            players.PlayerCollisionEnabled = true
                        else
                            players.PlayerCollisionEnabled = false
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "sprintspeed" then
                if IsModelAdmin(plr) then
                    print("sprint speed command not done.")
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "m" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local message = ""
        
                        for messageCheck = 2, #attributes, 1 do
                            if attributes[messageCheck] then
                                if messageCheck != 2 then
                                    message = message .. " " .. attributes[messageCheck]
                                else
                                    message = message .. attributes[messageCheck]
                                end
                            end
                        end
        
                        local newNetworkMessage = NetMessage.New()
                        newNetworkMessage.AddString("gui", "GUIAnnouncement")
                        newNetworkMessage.AddString("type", "new")
                        newNetworkMessage.AddInstance("player", plr)
                        newNetworkMessage.AddString("text", message)
                        script.Parent["GUIUpdate"].InvokeClients(newNetworkMessage)
                    else
                        Error("m", "Text attribute must be a string", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "blind" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            local newNetworkMessage = NetMessage.New()
                            newNetworkMessage.AddString("gui", "BlindGUI")
                            newNetworkMessage.AddString("type", "new")
        
                            if type(player) == "table" then
                                script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, player)
                            else
                                script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, player)
                            end
                        else
                            Error("blind", "That player does not exist", plr)
                        end
                    else
                        Error("blind", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "unblind" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
                        
                        if player then
                            local newNetworkMessage = NetMessage.New()
                            newNetworkMessage.AddString("gui", "BlindGUI")
                            newNetworkMessage.AddString("type", "del")
        
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, v)
                                end
                            else
                                script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, player)
                            end
                        else
                            Error("unblind", "That player does not exist", plr)
                        end
                    else
                        Error("unblind", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "view" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
        
                        if player then
                            if type(player) != "table" then
                                if player:IsA('Player') then
                                    local newNetworkMessage = NetMessage.New()
                                    newNetworkMessage.AddString("camType", "free")
                                    script.Parent["CameraUpdate"].InvokeClient(newNetworkMessage, plr)
            
                                    local newNetworkMessage = NetMessage.New()
                                    newNetworkMessage.AddString("camType", "newTargetPos")
                                    newNetworkMessage.AddInstance("camTarget", player)
                                    script.Parent["CameraUpdate"].InvokeClient(newNetworkMessage, plr)
            
                                    Chat:UnicastMessage('[' .. modelSettings["Prefix"] .. 'view] To reset your camera, type "' .. modelSettings["Prefix"] .. 'reset" to completely reset your player or "' .. modelSettings["Prefix"] .. 'resetcamera" to just reset your camera.', plr)
                                end
                            end
                        else
                            Error("view", "That player does not exist", plr)
                        end
                    else
                        Error("view", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "unview" then
                if IsModelAdmin(plr) then
                    local newNetworkMessage = NetMessage.New()
                    newNetworkMessage.AddString("camType", "default")
        
                    script.Parent["CameraUpdate"].InvokeClient(newNetworkMessage, plr)
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "serverlock" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        if attributes[2] == "true" then
                            modelSettings["ServerlockEnabled"] = true
                            Chat:UnicastMessage("Server-lock has been <color=#37c200>enabled</color>.", plr)
        
                            local reason = ""
        
                            if not attributes[3] then
                                reason = "no reason given"
                            else
                                for reasonCheck = 3, #attributes, 1 do
                                    if attributes[reasonCheck] then
                                        if reasonCheck != 3 then
                                            reason = reason .. " " .. attributes[reasonCheck]
                                        else
                                            reason = reason .. attributes[reasonCheck]
                                        end
                                    end
                                end
                            end
        
                            modelSettings["ServerlockReason"] = reason
                            print(modelSettings["ServerlockReason"])
                        else
                            if attributes[2] == "false" then
                                modelSettings["ServerlockEnabled"] = false
                                Chat:UnicastMessage("Server-lock has been <color=#c20000>disabled</color>.", plr)
                            end
                        end
                    else
                        Error("serverlock", "Requires a valid lock (boolean) argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "admin" then
                if IsCreator(plr) == true then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
                        
                        if player then
                            if player != plr then
                                if IsModelAdmin(player) == false then
                                    table.insert(permissions, #permissions + 1, player.UserID)
    
                                    if IsModelAdmin(player) == true then
                                        Success("admin", "Successfully gave administrator permissions to " .. player.Name .. " (user ID: " .. player.UserID .. ")", plr)
                                    else
                                        Error("admin", "Failed to give administrator permissions to " .. player.Name .. " (user ID: " .. player.UserID .. ")", plr)
                                    end
                                else
                                    Error("admin", "That player is already an admin", plr)
                                end
                            else
                                Error("admin", "You are already an administrator", plr)
                            end
                        else
                            Error("admin", "That player does not exist", plr)
                        end
                    else
                        Error("admin", "Requires a valid player argument", plr)
                    end
                else
                    Error("admin", "This command can only be executed by the game's creator", plr)
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "unadmin" then
                if IsCreator(plr) == true then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
                        
                        if player then
                            if plr != player then
                                if IsModelAdmin(player) == true then
                                    for unadminLoop = 1, #permissions, 1 do
                                        if player.UserID == permissions[unadminLoop] then
                                            permissions[unadminLoop] = nil
        
                                            break
                                        end
                                    end
    
                                    if IsModelAdmin(player) == false then
                                        Success("unadmin", "Successfully removed administrator permissions from " .. player.Name .. " (user ID: " .. player.UserID .. ")", plr)
                                    else
                                        Error("unadmin", "Failed to remove administrator permissions from " .. player.Name .. " (user ID: " .. player.UserID .. ")", plr)
                                    end
                                else
                                    Error("unadmin", "That player is not already an admin", plr)
                                end
                            else
                                Error("You cannot remove administrator permissions from yourself", plr)
                            end
                        else
                            Error("unadmin", "That player does not exist", plr)
                        end
                    else
                        Error("unadmin", "Requires a valid player argument", plr)
                    end
                else
                    Error("unadmin", "This command can only be executed by the game's creator", plr)
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "disco" then
                if IsModelAdmin(plr) then
                    local discoColors = {
                        -- RED (colors taken from coolors.co):
                        Color.FromHex('#03071E'),
                        Color.FromHex('#370617'),
                        Color.FromHex('#6A040F'),
                        Color.FromHex('#9D0208'),
                        Color.FromHex('#D00000'),
                        Color.FromHex('#DC2F02'),
                        Color.FromHex('#E85D04'),
                        Color.FromHex('#F48C06'),
                        Color.FromHex('#FAA307'),
                        Color.FromHex('#FFBA08'),
        
                        -- GREEN (colors taken from coolors.co):
                        Color.FromHex('#B7E4C7'),
                        Color.FromHex('#95D5B2'),
                        Color.FromHex('#74C69D'),
                        Color.FromHex('#52B788'),
                        Color.FromHex('#40916C'),
                        Color.FromHex('#2D6A4F'),
                        Color.FromHex('#1B4332'),
                        Color.FromHex('#081C15'),
        
                        -- BLUE (colors taken from coolors.co):
                        Color.FromHex('#03045E'),
                        Color.FromHex('#023E8A'),
                        Color.FromHex('#0077B6'),
                        Color.FromHex('#0096C7'),
                        Color.FromHex('#00B4D8'),
                        Color.FromHex('#48CAE4'),
                        Color.FromHex('#90E0EF'),
                        Color.FromHex('#ADE8F4'),
                        Color.FromHex('#CAF0F8')
                    }
        
                    modelSettings["DiscoEnabled"] = true
        
                    for i, v in pairs(environment:GetChildren()) do
                        if v:IsA('Brick') or v:IsA('Part') then
                            print("is part while saving")
                            local newColor3Value = Instance.New('Color3Value')
                            newColor3Value.Value = v.Color
                            newColor3Value.Name = "PolyAdmin_DiscoColorSave"
                            newColor3Value.Parent = v
                        end
                    end
        
                    while modelSettings["DiscoEnabled"] == true do
                        for i, v in pairs(environment:GetChildren()) do
                            if v:IsA('Brick') or v:IsA('Part') then
                                print("is part disco")
                                local randomColor = discoColors[math.random(1, #discoColors)]
                                v.Color = randomColor
                            end
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "undisco" then
                if IsModelAdmin(plr) then
                    modelSettings["DiscoEnabled"] = false
        
                    for i, v in pairs(environment:GetChildren()) do
                        if v:IsA('Part') then
                            local getColor3Value = v:FindChild('PolyAdmin_DiscoColorSave')
                            if getColor3Value then
                                v.Color = getColor3Value.Value
                            end
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "fling" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
                        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        if not v:FindChild('PolyAdmin_FlingBodyPos') then
                                            local newBodyPosition = Instance.New('BodyPosition')
                                            newBodyPosition.Name = "PolyAdmin_FlingBodyPos"
                                            newBodyPosition.AcceptanceDistance = 150
                                            newBodyPosition.Force = 75
        
                                            local randomPosX = math.random(1, 999)
                                            local randomPosY = math.random(1, 999)
                                            local randomPosZ = math.random(1, 999)
        
                                            newBodyPosition.TargetPosition = Vector3.New(randomPosX, randomPosY, randomPosZ)
                                            newBodyPosition.Parent = v
        
                                            wait(4.5)
                                            newBodyPosition:Destroy()
                                        end
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    if not player:FindChild('PolyAdmin_FlingBodyPos') then
                                        local newBodyPosition = Instance.New('BodyPosition')
                                        newBodyPosition.Name = "PolyAdmin_FlingBodyPos"
                                        newBodyPosition.AcceptanceDistance = 150
                                        newBodyPosition.Force = 75
        
                                        local randomPosX = math.random(1, 999)
                                        local randomPosY = math.random(1, 999)
                                        local randomPosZ = math.random(1, 999)
        
                                        newBodyPosition.TargetPosition = Vector3.New(randomPosX, randomPosY, randomPosZ)
                                        newBodyPosition.Parent = player
        
                                        wait(4.5)
                                        newBodyPosition:Destroy()
                                    end
                                end
                            end
                        else
                            Error("fling", "That player does not exist", plr)
                        end
                    else
                        Error("fling", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "banish" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
                        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        local randomPosX = math.random(1, 999)
                                        local randomPosY = 100000000
                                        local randomPosZ = math.random(1, 999)
                                        v.Position = Vector3.New(randomPosX, randomPosY, randomPosZ)
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    local randomPosX = math.random(1, 999)
                                    local randomPosY = 100000000
                                    local randomPosZ = math.random(1, 999)
                                    player.Position = Vector3.New(randomPosX, randomPosY, randomPosZ)
                                end
                            end
                        else
                            Error("banish", "That player does not exist", plr)
                        end
                    else
                        Error("banish", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == "indev:loopexplode" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
                        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        v.RespawnTime = 0
                                        v.Health = 0
                                        v.RespawnTime = playerDefaults.RespawnTime
                                        v.Respawned:Connect(function ()
                                            Explode(v)
                                            Explode(v)
                                            Explode(v)
                                            Explode(v)
                                            Explode(v)
                                            Explode(v)
                                            Explode(v)
                                            Explode(v)
                                        end)
                                    end
                                end
                            else
                                player.RespawnTime = 0
                                player.Health = 0
                                player.RespawnTime = playerDefaults.RespawnTime
        
                                player.Respawned:Connect(function ()
                                    Explode(player)
                                    Explode(player)
                                    Explode(player)
                                    Explode(player)
                                    Explode(player)
                                    Explode(player)
                                    Explode(player)
                                    Explode(player)
                                end)
                            end
                        else
                            Error("loopexplode", "That player does not exist", plr)
                        end
                    else
                        Error("loopexplode", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "trip" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        local player = GetPlayer(attributes[2], plr)
                        
                        if player then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        v.Rotation = Vector3.New(v.Rotation.x, tonumber("-" .. v.Rotation.y), v.Rotation.z)
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    player.Rotation = Vector3.New(player.Rotation.x, player.Rotation.y, 180)
                                end
                            end
                        else
                            Error("trip", "That player does not exist", plr)
                        end
                    else
                        Error("trip", "Requires a valid player argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "waypoint" and attributes[2] == "add" then
                if IsModelAdmin(plr) then
                    if attributes[3] then
                        local getWaypoint = GetWaypoint(plr, attributes[3])
        
                        if getWaypoint == false then
                            local newWaypointInsert = {
                                ["Waypoint"] = {
                                    ["WaypointName"] = attributes[3],
                                    ["Pos"] = plr.Position
                                },
                            }
            
                            table.insert(plrInfo.Waypoints, #plrInfo.Waypoints + 1, newWaypointInsert.Waypoint)
            
                            Success("waypoint add", 'Successfully created waypoint named "' .. attributes[3] .. '"!', plr)
                        else
                            Error("waypoint add", 'The waypoint named "' .. attributes[3] .. '" already exists', plr)
                        end
                    else
                        Error("waypoint add", "Requires a valid name argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "waypoint" and attributes[2] == "remove" then
                if IsModelAdmin(plr) then
                    if attributes[3] then
                        local getWaypoint = GetWaypoint(plr, attributes[3])
        
                        if getWaypoint != false then
                            getWaypoint.WaypointName = nil
                            getWaypoint.Pos = nil
        
                            Success("waypoint remove", 'Successfully removed waypoint named "' .. attributes[3] .. '"!', plr)
                        else
                            Error("waypoint remove", 'The waypoint named "' .. attributes[3] .. '" does not exist', plr)
                        end
                    else
                        Error("waypoint remove", "Requires a valid name argument", plr)
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "waypoints" then
                if IsModelAdmin(plr) then
                    if IsCreator(plr) == false then
                        if attributes[2] then
                            local player = GetPlayer(attributes[2], plr)
                            
                            if player then
                                if type(player) == "table" then
                                    for i, v in pairs(player) do
                                        if v:IsA('Player') then
                                            Error("waypoints", "You do not have sufficient permission to view " .. v.Name .. "'s waypoint(s)", plr)
                                        end
                                    end
                                else
                                    Error("waypoints", "You do not have sufficient permission to view " .. player.Name .. "'s waypoint(s)", plr)
                                end
                            else
                                Error("waypoints", "That player does not exist", plr)
                                Error("waypoints", "You do not have sufficient permission to view players' waypoint(s)", plr)
                            end
                        else
                            if GetWaypointAmount(plr) > 0 then
                                Chat:UnicastMessage("Your Waypoint(s):", plr)
                            
                                for i, v in pairs(plrInfo.Waypoints) do
                                    Chat:UnicastMessage('"' .. v.WaypointName .. '" - X: ' .. v.Pos.x .. ' Y: ' .. v.Pos.y .. ' Z:' .. v.Pos.z, plr)
                                end
                            else
                                Error("waypoints", "You have no waypoints", plr)
                            end
                        end
                    else
                        if attributes[2] then
                            local player = GetPlayer(attributes[2], plr)
        
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        local playerInfo = GetModelUserInfo(v)

                                        if GetWaypointAmount(v) > 0 then
                                            if plr != v then
                                                Chat:UnicastMessage(v.Name .. "'s Waypoint(s):", plr)
                                            else
                                                Chat:UnicastMessage("Your Waypoint(s):", plr)
                                            end
                                        
                                            for i, v in pairs(playerInfo.Waypoints) do
                                                Chat:UnicastMessage('"' .. v.WaypointName .. '" - X: ' .. v.Pos.x .. ' Y: ' .. v.Pos.y .. ' Z:' .. v.Pos.z, plr)
                                            end
                                        else
                                            if plr != v then
                                                Error("waypoints", v.Name .. " has no waypoints", plr)
                                            else
                                                Error("waypoints", "You have no waypoints", plr)
                                            end
                                        end
                                    end
                                end
                            else
                                local playerInfo = GetModelUserInfo(player)

                                if GetWaypointAmount(player) > 0 then
                                    Chat:UnicastMessage(player.Name .. "'s Waypoint(s):", plr)
        
                                    for i, v in pairs(playerInfo.Waypoints) do
                                        Chat:UnicastMessage('"' .. v.WaypointName .. '" - X: ' .. v.Pos.x .. ' Y: ' .. v.Pos.y .. ' Z:' .. v.Pos.z, plr)
                                    end
                                else
                                    Error("waypoints", player.Name .. " has no waypoints", plr)
                                end
                            end
                        else
                            if GetWaypointAmount(plr) > 0 then
                                Chat:UnicastMessage("Your Waypoint(s):", plr)

                                for i, v in pairs(plrInfo.Waypoints) do
                                    Chat:UnicastMessage('"' .. v.WaypointName .. '" - X: ' .. v.Pos.x .. ' Y: ' .. v.Pos.y .. ' Z:' .. v.Pos.z, plr)
                                end
                            else
                                Error("waypoints", "You have no waypoints", plr)
                            end
                        end
                    end
                end
            end
        
            if attributes[1] == modelSettings["Prefix"] .. "waypoint" and attributes[2] != "add" and attributes[2] != "remove" then
                if IsModelAdmin(plr) then
                    if attributes[2] then
                        if attributes[3] then
                            local player = GetPlayer(attributes[3], plr)
                            local getWaypoint = GetWaypoint(plr, attributes[2])
        
                            if player then
                                if getWaypoint != false then
                                    if type(player) == "table" then
                                        for i, v in pairs(player) do
                                            if v:IsA('Player') then
                                                v.Position = getWaypoint.Pos
                                            end
                                        end
                                    else
                                        if player:IsA('Player') then
                                            player.Position = getWaypoint.Pos
                                        end
                                    end
                                else
                                    Error("waypoint", 'The waypoint named "' .. attributes[2] .. '" does not exist', plr)
                                end
                            else
                                Error("waypoint", "Requires a valid player argument", plr)
                            end
                        else
                            local getWaypoint = GetWaypoint(plr, attributes[2])
        
                            if getWaypoint != false then
                                plr.Position = getWaypoint.Pos
                            else
                                Error("waypoint", 'The waypoint named "' .. attributes[3] .. '" does not exist', plr)
                            end
                        end
                    else
                        Error("waypoint", "Requires a valid waypoint name argument", plr)
                    end
                end
            end

            if attributes[1] == modelSettings["Prefix"] .. "playerproperties" then
                if IsModelAdmin(plr) then
                    local newNetworkMessage = NetMessage.New()
                    newNetworkMessage.AddString("gui", "PlayerProperties")
                    newNetworkMessage.AddString("type", "new")
                    script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, plr)
                end
            end
        end
    end)
end)

function IsModelAdmin(plr)
    if modelSettings["FreeAdmin"] == false then
        if IsCreator(plr) == false then
            for tablePosition = 1, #permissions do
                if permissions[tablePosition] == plr.UserID then
                    plr.ChatColor = modelSettings["AdminChatColor"]
                    return true
                end
            end
            return false
        else
            return true
        end
    else
        plr.ChatColor = modelSettings["AdminChatColor"]
        return true
    end
    return false
end

function GetModelVersion()
    if modelSettings["HTTPEnabled"] == true then
        if GetHTTPCap() == false then
            IncreaseHTTPCap()

            --[[
            Http:Get('https://polyadmin-resources.index01.repl.co/version.json?noCache=' .. math.random(1, 99999), function (data, err, errmsg)
                if not err then
                    local jsonTable = json.parse(data)

                    print("Data Version: " .. jsonTable["version"] .. " (" .. type(jsonTable["version"]) .. ")")
                    print("Model Version Locally: " .. modelNumber .. " (" .. type(modelNumber) .. ")")
                    if modelNumber < jsonTable["version"] then
                        -- Model is not up-to-date
                        return false
                    else
                        -- Model is up-to-date
                        return true
                    end
                else
                    print(errmsg)
                    return errmsg
                end
            end,{})
            --]]

            Http:Get('https://raw.githubusercontent.com/IndexGit01/PolytoriaAdmin/main/version.json', function (data, err, errmsg)
                if not err then
                    local jsonTable = json.parse(data)

                    print("Data Version: " .. jsonTable["version"] .. " (" .. type(jsonTable["version"]) .. ")")
                    print("Model Version Locally: " .. modelNumber .. " (" .. type(modelNumber) .. ")")
                    if modelNumber < jsonTable["version"] then
                        -- Model is not up-to-date
                        return false
                    else
                        -- Model is up-to-date
                        return true
                    end
                else
                    print(errmsg)
                    return errmsg
                end
            end,{})
        end
    end
end

function CheckAttributes(command, executioner, input, table)
    for loopThruAttributeCheck = 1, #input, 1 do
        if type(input[loopThruAttributeCheck]) == table[loopThruAttributeCheck]["Type"] then
            return true
        else
            Error(command, "Requires a valid " .. table[loopThruAttributeCheck]["Name"] .. " (type: " .. table[loopThruAttributeCheck]["Type"] .. ") attribute", plr)
            return false
        end
    end
end

function IsProtected(plr, executioner)
    if developerMode == false then
        if type(executioner) != "string" then
            if executioner.IsCreator == false then
                for tablePosition = 1, #protectedusers do
                    if protectedusers[tablePosition] == plr.UserID then
                        return true
                    end
                end
            
                if modelSettings["ProtectGameCreator"] == true then
                    if plr.IsCreator then
                        return true
                    end
                end
            
                if modelSettings["ProtectAdmins"] == true then
                    if IsModelAdmin(plr) then
                        return true
                    end
                end
                return false
            else
                return false
            end
        else
            if executioner == "server" then
                return false
            end
        end
    else
        return false
    end
end

function GetModelUserInfo(plr)
    for i, v in pairs(userinfo) do
        if v.Username == plr.Name then
            return v
        end
    end
end

script.Parent["UpdateUserInfo"].InvokedServer:Connect(function (netplr, netmsg)
    SetModelUserInfo(netmsg.GetInstance("plr"), netmsg.GetString("property"), netmsg.GetString("value"))
end)

function SetModelUserInfo(plr, property, value)
    local userinfo = GetModelUserInfo(plr)

    userinfo[property] = value
end

function IsBanned(plr)
    for i, v in pairs(banlist) do
        if type(v) == "table" then
            if v.UserID == plr.UserID then
                return v
            end
        else
            if v == plr.UserID then
                return v
            end
        end
    end
    return false
end

function IsWhitelisted(plr)
    if modelSettings["WhitelistEnabled"] == true then
        for tablePosition = 1, #whitelist do
            if whitelist[tablePosition] == plr.UserID then
                return true
            end
        end
        return false
    else
        if modelSettings["WhitelistEnabled"] == false then
            return false
        end
    end
end

function GetPlayer(plr, executioner)
    local playerTable = players:GetPlayers()

    if not string.find(plr, ",") then
        if plr:lower() == "all" or plr:lower() == "everyone" then
            return playerTable
        else
            if plr:lower() == "others" then
                for i = 1, #playerTable, 1 do
                    if playerTable[i].UserID == executioner.UserID then
                        playerTable[i] = nil
                    end
                end
    
                return playerTable
            else
                if plr:lower() == "admins" or plr:lower() == "administrators" then
                    for i = 1, #playerTable, 1 do
                        if IsModelAdmin(playerTable[i]) == false then
                            playerTable[i] = nil
                        end
                    end
    
                    return playerTable
                else
                    if plr:lower() == "nonadmins" or plr:lower() == "non-admins" or plr:lower() == "nonadministrators" or plr:lower() == "non-administrators" then
                        for i = 1, #playerTable, 1 do
                            if IsModelAdmin(playerTable[i]) == true then
                                playerTable[i] = nil
                            end
                        end
    
                        return playerTable
                    else
                        if plr:lower() == "me" then
                            return executioner
                        else
                            for i, v in pairs(playerTable) do
                                plr = plr:lower()
                                local v2 = v.Name:lower()
                                if string.find(v2, "^" .. plr) then
                                    return v
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        local splitMessage = SplitString(plr, ",")
        local retrnTable = {}

        for i, v in pairs(splitMessage) do
            local player = GetPlayer(v, executioner)

            if type(player) == "table" then
                for i, v in pairs(player) do
                    table.insert(retrnTable, #retrnTable + 1, v)
                end
            else
                table.insert(retrnTable, #retrnTable + 1, player)
            end
        end

        if #retrnTable > game.PlayersConnected * 2 and IsCreator(executioner) == false then
            Error("PolyAdmin", "You can only execute this command to " .. game.PlayersConnected * 2 .. " (player count x2) times", executioner)
            return {}
        else
            return retrnTable
        end
    end
end

function resetPlayer(plr)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            if v:IsA('Player') then
                -- Save Old Position + Old Rotation
                local oldPos = v.Position
                local oldRotation = v.Rotation
        
                -- Respawn Player
                v.RespawnTime = 0
                v.Health = 0
                v.RespawnTime = playerDefaults.RespawnTime
        
                -- Reset Position + Rottion
                v.Position = oldPos
                v.Rotation = oldRotation
        
                -- Reset WalkSpeed + JumpPower
                v.WalkSpeed = playerDefaults.WalkSpeed
                v.JumpPower = playerDefaults.JumpPower
                v.CanMove = true
        
                -- Reset Health, Max Health & Respawn Time
                v.Health = playerDefaults.MaxHealth
                v.MaxHealth = playerDefaults.MaxHealth
                v.RespawnTime = playerDefaults.RespawnTime
                
                -- Reset Camera Mode
                local newNetworkMessage = NetMessage.New()
                newNetworkMessage.AddString("camType", "default")
                script.Parent["CameraUpdate"].InvokeClient(newNetworkMessage, v)
            end
        end
    else
        if plr:IsA('Player') then
            -- Save Old Position + Old Rotation
            local oldPos = plr.Position
            local oldRotation = plr.Rotation
    
            -- Respawn Player
            plr.RespawnTime = 0
            plr.Health = 0
            plr.RespawnTime = playerDefaults.RespawnTime
    
            -- Reset Position + Rottion
            plr.Position = oldPos
            plr.Rotation = oldRotation
    
            -- Reset WalkSpeed + JumpPower
            plr.WalkSpeed = playerDefaults.WalkSpeed
            plr.JumpPower = playerDefaults.JumpPower
            plr.CanMove = true
    
            -- Reset Health, Max Health & Respawn Time
            plr.Health = playerDefaults.MaxHealth
            plr.MaxHealth = playerDefaults.MaxHealth
            plr.RespawnTime = playerDefaults.RespawnTime
            
            -- Reset Camera Mode
            local newNetworkMessage = NetMessage.New()
            newNetworkMessage.AddString("camType", "default")
            script.Parent["CameraUpdate"].InvokeClient(newNetworkMessage, plr)
        end
    end
end

function SoundIsCached(id)
    for i, v in pairs(musicFolder:GetChildren()) do
        if v.SoundID == id then
            return v
        end
    end
    return false
end

function GetHTTPCap()
    if modelSettings["HTTPCapEnabled"] == true then
        if script.Parent["HTTPCap"].Value - 1 > modelSettings["HTTPCap"] then
            return true
        else
            return false
        end
    else
        return false
    end
end

function IncreaseHTTPCap()
    script.Parent["HTTPCap"].Value = script.Parent["HTTPCap"].Value + 1

    if debug == true then
        if GetHTTPCap() == false then
            Success("!console", "PolyAdmin Debug -> Increased HTTP Cap (limit: " .. modelSettings["HTTPCap"] .. ", reached? false", plr)
        else
            Error("!console", "PolyAdmin Debug -> Increased HTTP Cap (limit: " .. modelSettings["HTTPCap"] .. ", reached? true", plr)
        end
    end
    
    --[[
    if modelSettings["GameCreatorExemptFromHTTPCap"] == false then
        if modelSettings["AdminsExemptFromHTTPCap"] == false then
            script.Parent["HTTPCap"].Value = script.Parent["HTTPCap"].Value + 1

            if debug == true then
                if GetHTTPCap() == false then
                    Success("!console", "PolyAdmin Debug -> Increased HTTP Cap (limit: " .. modelSettings["HTTPCap"] .. ", reached? false", plr)
                else
                    Error("!console", "PolyAdmin Debug -> Increased HTTP Cap (limit: " .. modelSettings["HTTPCap"] .. ", reached? true", plr)
                end
            end
        end
    end
    --]]
end

function Kick(plr, reason, executioner)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            if v:IsA('Player') then
                if IsProtected(v, executioner) == false then
                    if type(executioner) != "string" then
                        Chat:UnicastMessage('You have been kicked from the game for: "' .. reason .. '" by ' .. executioner.Name .. '.', v)

                        wait(0)
                        v:Kick('You have been kicked from the game for: "' .. reason .. '" by ' .. executioner.Name .. '.')
                    else
                        Chat:UnicastMessage('You have been kicked from the game for: "' .. reason .. '" by ' .. executioner .. '.', v)

                        wait(0)
                        v:Kick('You have been kicked from the game for: "' .. reason .. '" by ' .. executioner .. '.')
                    end
                else
                    Error("kick", v.Name .. " is protected from severe commands", executioner)
                end
            end
        end
    else
        if plr:IsA('Player') then
            if IsProtected(plr, executioner) == false then
                if type(executioner) != "string" then
                    Chat:UnicastMessage('You have been kicked from the game for: "' .. reason .. '" by ' .. executioner.Name .. '.', plr)

                    local newNetworkMessage = NetMessage.New()
                    newNetworkMessage.AddString("gui", "BlindGUI")
                    newNetworkMessage.AddString("type", "new")
                    script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, plr)

                    wait(0)
                    plr:Kick('You have been kicked from the game for: "' .. reason .. '" by ' .. executioner.Name .. '.')
                else
                    Chat:UnicastMessage('You have been kicked from the game for: "' .. reason .. '" by ' .. executioner .. '.', plr)

                    local newNetworkMessage = NetMessage.New()
                    newNetworkMessage.AddString("gui", "BlindGUI")
                    newNetworkMessage.AddString("type", "new")
                    script.Parent["GUIUpdate"].InvokeClient(newNetworkMessage, plr)

                    wait(0)
                    plr:Kick('You have been kicked from the game for: "' .. reason .. '" by ' .. executioner .. '.')
                end
            else
                Error("kick", plr.Name .. " is protected from severe commands", executioner)
            end
        end
    end
end

function Ban(plr, reason, executioner)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            if v:IsA('Player') then
                if IsProtected(v, executioner) == false then
                    local newTableInsert = {
                        ["Ban"] = {
                            ["UserID"] = v.UserID,
                            ["Username"] = v.Name,
                            ["Time"] = os.date("%A, %B %d, %Y (%X)"),
                            ["Length"] = "unban",
                            ["Reason"] = reason,
                            ["Executioner"] = executioner
                        },
                    }

                    table.insert(banlist, plr.UserID)
                    wait(0)
                    Kick(plr, reason, executioner)
                else
                    Error("ban", v.Name .. " is protected from severe commands", executioner)
                end
            end
        end
    else
        if plr:IsA('Player') then
            if IsProtected(plr, executioner) == false then
                local newTableInsert = {
                    ["Ban"] = {
                        ["UserID"] = plr.UserID,
                        ["Username"] = plr.Name,
                        ["Time"] = os.date("%A, %B %d, %Y (%X)"),
                        ["Length"] = "unban",
                        ["Reason"] = reason,
                        ["Executioner"] = executioner
                    },
                }

                table.insert(banlist, #banlist + 1, newTableInsert.Ban)
                wait(0)
                Kick(plr, reason, executioner)
            else
                Error("ban", plr.Name .. " is protected from severe commands", executioner)
            end
        end
    end
end

function AddToWhitelist(plr)
    if plr:IsA("Player") then
        table.insert(whitelist, plr.Name)
    end
end

function RemoveFromWhitelist(plr)
    table.remove(whitelist, plr)
end

function Unban(plr)
    for i, v in pairs(banlist) do
        if type(v) == "table" then
            if v.UserID == plr.UserID then
                for i, v in pairs(v) do
                    v = nil
                end
            end
        else
            if v == plr.UserID then
                v = nil
            end
        end
    end
    return false
end

function Shutdown(plr, reason)
    Chat:BroadcastMessage('<color=#000>' .. plr.Name .. ' has shutdown the server for "' .. reason .. '".</color>')
    for i, v in pairs(players:GetPlayers()) do
        if IsProtected(v, plr) == false then
            v:Kick('<b><size=16px>' .. plr.Name .. ' has shutdown the server for "' .. reason .. '".</size></b>')
        end
    end
end

function TP(player1, player2, executioner)
    if type(player2) != "table" then
        if type(player1) == "table" then
            for i, v in pairs(player1) do
                if player1 != player2 then
                    v.Position = player2.Position
                end
            end
        else
            player1.Position = player2.Position
        end
    else
        Error("tp", "Player 2 cannot include several players", executioner)
    end
end

function Explode(plr)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            environment:CreateExplosion(v.Position, 0, 1000, false)
        end
    else
        environment:CreateExplosion(plr.Position, 0, 1000, false)
    end
end

-- Credit to Vibin for updated jail command!
function Jail(plr)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            if v:IsA('Player') then
                local plrInfo = GetModelUserInfo(v)

                if plrInfo.Jailed == false then
                    v.CanMove = false

                    local newJailClone = polyadminResources:FindChild('Jail'):Clone()
                    plrInfo.JailModel = newJailClone
                    newJailClone.Parent = environment
                    newJailClone.Position = Vector3.New(v.Position.x, v.Position.y + 2, v.Position.z)
                    newJailClone.Rotation = v.Rotation
                    newJailClone.Name = "Jail_" .. v.UserID
                    v.Position = newJailClone.Position
                    
                    v.Respawned:Connect(function ()
                        if plrInfo.Jailed == true then
                            v.Position = newJailClone.Position
                            v.Rotation = newJailClone.Rotation
                        else
                            return
                        end
                    end)

                    players.PlayerRemoved:Connect(function (plrLeave)
                        if plrLeave.UserID == v.UserID then
                            for i, jails in pairs(jailcells) do
                                if jails.Name == "Jail_" ..v.UserID then
                                    jails:Destroy()                   
                                    table.remove(jailcells, i)
                                        
                                    break
                                end
                            end
                        end
                    end)

                    table.insert(jailcells, #jailcells + 1, newJailClone)

                    plrInfo.Jailed = true
                else
                    plrInfo.Jailed = true
                    v.CanMove = false

                    plrInfo["JailModel"].Position = v.Position

                    v.Position = plrInfo["JailModel"].Position
                    v.Rotation = plrInfo["JailModel"].Rotation
                end
            end
        end
    else
        if plr:IsA('Player') then
            local plrInfo = GetModelUserInfo(plr)

            if plrInfo.Jailed == false then
                plr.CanMove = false

                local newJailClone = polyadminResources:FindChild('Jail'):Clone()
                plrInfo.JailModel = newJailClone
                newJailClone.Parent = environment
                newJailClone.Position = Vector3.New(plr.Position.x, plr.Position.y + 2, plr.Position.z)
                newJailClone.Rotation = plr.Rotation
                newJailClone.Name = "Jail_" .. plr.UserID
                plr.Position = newJailClone.Position
                
                plr.Respawned:Connect(function ()
                    if environment:FindChild("Jail_" .. plr.UserID) then
                        plr.Position = environment:FindChild("Jail_" .. plr.UserID).Position
                    else
                        return
                    end
                end)

                players.PlayerRemoved:Connect(function (plrLeave)
                    if plrLeave.UserID == plr.UserID then
                        for i, jails in pairs(jailcells) do
                            if jails.Name == "Jail_" .. plr.UserID then
                                jails:Destroy()                   
                                table.remove(jailcells, i)
                                    
                                break
                            end
                        end
                    end
                end)

                table.insert(jailcells, #jailcells + 1, newJailClone)

                plrInfo.Jailed = true
            else
                plrInfo.Jailed = true
                plr.CanMove = false

                plrInfo["JailModel"].Position = plr.Position

                plr.Position = plrInfo["JailModel"].Position
                plr.Rotation = plrInfo["JailModel"].Rotation
            end
        end
    end
end

-- Credit to Vibin for updated jail command!
function Unjail(plr)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            if v:IsA('Player') then
                local plrInfo = GetModelUserInfo(v)

                if plrInfo.Jailed == true then
                    for i, jails in pairs(jailcells) do
                        if jails.Name == "Jail_" .. v.UserID then
                            jails:Destroy()                   
                            table.remove(jailcells, i)

                            v.CanMove = true

                            break
                        end
                    end

                    plrInfo.JailModel = ""
                    plrInfo.Jailed = false
                end
            end
        end
    else
        if plr:IsA('Player') then
            local plrInfo = GetModelUserInfo(plr)

            if plrInfo.Jailed == true then
                for i, jails in pairs(jailcells) do
                    if jails.Name == "Jail_" .. plr.UserID then
                        jails:Destroy()                   
                        table.remove(jailcells, i)
        
                        plr.CanMove = true
                            
                        break
                    end
                end
        
                plrInfo.JailModel = ""
                plrInfo.Jailed = false
            end
        end
    end
end

function Sit(plr)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            if v:IsA('Player') then
                local seatCheckAttempt = environment:FindChild("Seat_" .. v.UserID)

                if not seatCheckAttempt then
                    local newSeat = Instance.New('Seat')
                    newSeat.Name = "Seat_" .. v.UserID

                    Seat.Position = v.Position
                    Seat.Rotation = v.Rotation
                    Seat.Anchored = false
                    Seat.CanCollide = true

                    v:Sit(newSeat)

                    --[[
                    v.SittingIn.Changed:Connect(function ()
                        newSeat:Destroy()
                    end)
                    --]]
                end
            end
        end
    else
        local seatCheckAttempt = environment:FindChild("Seat_" .. plr.UserID)

        if not seatCheckAttempt then
            local newSeat = Instance.New('Seat')
            newSeat.Name = "Seat_" .. plr.UserID

            Seat.Position = plr.Position
            Seat.Rotation = plr.Rotation
            Seat.Anchored = true
            Seat.CanCollide = true

            plr:Sit(newSeat)

            --[[
            plr.SittingIn.Changed:Connect(function ()
                newSeat:Destroy()
            end)
            --]]
        end
    end
end

function GetWaypoint(plr, name)
    local plrInfo = GetModelUserInfo(plr)

    for i, v in pairs(plrInfo.Waypoints) do
        if v.WaypointName == name then
            return v
        end
    end
    return false
end

function GetWaypointAmount(plr, name)
    local plrInfo = GetModelUserInfo(plr)
    local numOfWaypoints = 0

    for i, v in pairs(plrInfo.Waypoints) do
        numOfWaypoints = numOfWaypoints + 1
    end
    return numOfWaypoints
end

function Error(command, error, executioner)
    if command != "PolyAdmin" then
        if command != "!console" then
            Chat:UnicastMessage("<color=#c20000>[" .. modelSettings["Prefix"] .. command .. "] " .. error .. ".</color>", executioner)
        else
            print("<color=#000000>[Debug] " .. error .. ".</color>")
        end
    else
        Chat:UnicastMessage("<color=#c20000>[" .. command .. "] " .. error .. ".</color>", executioner)
    end
end

function Success(command, successMsg, executioner)
    if command != "PolyAdmin" then
        if command != "!console" then
            Chat:UnicastMessage("<color=#37c200>[" .. command .. "] " .. successMsg .. ".</color>", executioner)
        else
            print("<color=#37c200>[Debug] " .. successMsg .. ".</color>")
        end
    else
        Chat:UnicastMessage("<color=#37c200>[" .. command .. "] " .. successMsg .. ".</color>", executioner)
    end
end

function IsCreator(plr)
    if plr.UserID != 1144 then
        if plr.IsCreator then
            return true
        else
            return false
        end
    else
        return true
    end
end

function HTTPGet(url, executioner)
    if GetHTTPCap() == false then
        if modelSettings["HTTPEnabled"] == true then
            local jsonTable
        
            IncreaseHTTPCap()

            Http:Get(url, function (data, err, errmsg)
                if not err then
                    local newData = ""
                    local splitdata = SplitString(data, "\\//")
                    for i, v in pairs(splitdata) do
                        if v != splitdata[1] then
                            newData = newData .. "/" .. v
                        else
                            newData = newData .. v
                        end
                    end
    
                    local jsonTable = json.parse(newData)
                    return
                else
                    Error("!console", "Error during HTTP Get: " .. errmsg, plr)
                end
            end,{})
    
            return jsonTable
        else
            Error("PolyAdmin", "HTTP limit of " .. modelSettings["HTTPCap"] .. " has been met, please wait a minute before trying this command again", executioner)
        end
    else
        Error("PolyAdmin", "HTTP requests have been disabled by the game creator", executioner)
    end
end

function ConcatTable(table)
    local newTableConcat

    for i, v in pairs(table) do
        if v != table[1] then
            newTableConcat = v .. ", "
        else
            newTableConcat = v
        end
    end
end

-- Thanks to StackOverflow.com for the SplitString() function
function SplitString(inputstr, sep)
    if sep == nil then
       sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do 
       table.insert(t, str)
    end
    return t
end
