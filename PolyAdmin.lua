-- PolyAdmin v1.2
-- Model made by Index

-- I recommend joining this Discord server to be notified when the model gets updates: https://discord.gg/XV6rDrjVkV

local players = game["Players"]
local environment = game["Environment"]
local playerDefaults = game["PlayerDefaults"]
local polyAdminModel = environment:FindChild('PolyAdmin')

local modelVersion = '{"version":1.2}'
local modelNumber = 1.2

local musicFolder = Instance.New("Part")
musicFolder.Size = Vector3.New(0.1, 0.1, 0.1)
musicFolder.Anchored = true
musicFolder.CanCollide = false
musicFolder.Parent = polyAdminModel
musicFolder.Name = "MusicFolder"

--[[
local playerItems = Instance.New("Part")
playerItems.Size = Vector3.New(0.1, 0.1, 0.1)
playerItems.Anchored = true
playerItems.CanCollide = false
playerItems.Parent = polyAdminModel
playerItems.Name = "playerItems"
--]]

for i, v in pairs(polyAdminModel:GetChildren()) do
    if not v:IsA("Script") then
        if v.Name == "Jail" then
            for i, v in pairs(v:GetChildren()) do
                if v.Name != "Walls" then
                    v.Color = Color.New(v.Color.r, v.Color.g, v.Color.b, 255)
                end
            end
        end
        v.Parent = game["Hidden"]
    end
end

local prefix = ":"
-- The prefix cannot be "/" otherwise you won't be able to use commands because Polytoria will use their built-in commands if the message starts with a "/"

local permissions = {}
-- To make a user an admin, get their USER ID & paste it in this table (separate each USER ID by a comma)

local protectGameCreator = true
-- Blocks any severe commands such as kick & ban if the target is the game creator

local protectAdmins = true
-- Blocks any severe commands such as kick & ban if the target is a game administrator

local protectedusers = {}
-- Users that are protected from severe commands such as kick & ban commands.

--[[
local whitelistEnabled = false
-- Stores if the whitelist is enabled or disabled (**COMING SOON**)

local keepItems = false
-- Keeps inventory items upon death/respawn. (**COMING SOON**)

local whitelist = {}
-- Players that are whitelisted from your game if "whitelistEnabled" variable equals true (**COMING SOON**)
--]]

local banlist = {}
-- Players that are banned from your game

local jailcells = {}
-- Stores all jail instances in the game

local adminChatColor = Color.FromHex('#000')
-- Chat color for admins that join your game

local freeAdmin = true
-- If this variable equals true, checkForPermissions() will get overridden & always return true unless the player is banned from your game

local commandList = {
    prefix .. "help",
    prefix .. "version",
    prefix .. "userid (OR) uid [plr]",
    prefix .. "warn [plr] [reason]",
    prefix .. "kick [plr] [reason]",
    prefix .. "ban [plr] [reason]",
    prefix .. "announce [text]",
    prefix .. "tp [plr 1] [plr 2]",
    prefix .. "explode [plr]",
    prefix .. "respawn [plr]",
    prefix .. "damage [plr]",
    prefix .. "kill [plr]",
    prefix .. "jail [plr]",
    prefix .. "unjail [plr]",
    prefix .. "sword [plr]",
    prefix .. "health [plr] [health]",
    prefix .. "heal [plr]",
    prefix .. "forcefield (OR) ff [plr]",
    prefix .. "unforcefield (OR) unff [plr]",
    prefix .. "reset (OR) re [plr]",
    prefix .. "walkspeed (OR) speed [plr] [speed]",
    prefix .. "jumppower (OR) jp [plr] [power]",
    prefix .. "maxhealth [plr] [health]",
    prefix .. "music play [sound ID]",
    prefix .. "music stop"
}
-- This table is used for the ":help" command to list all commands.

-- !!! If you find any command in the code that is not shown in this table, that means the command is not ready to be used & it's highly recommended you not use the command !!!

players.PlayerAdded:Connect(function (plr)
    if checkBanList(plr) == true then
        Kick(plr, "banned")
    else
        if whitelistEnabled == true then
            if checkWhitelist(plr) == true then
                Kick(plr, "not whitelisted")
            end
        end
    end

    if checkForPermissions(plr) then
        Chat:UnicastMessage("<color=#000>You are an administrator in this game, </color><color=#f50000>" .. plr.Name .. "</color><color=#000>. Do </color><color=#f50000>" .. prefix .. "help</color><color=#000> for a list of commands.</color>", plr)
        -- Notify the player that they are an administrator in this game

        plr.ChatColor = adminChatColor
        -- Change the player's chat color to an administrator color

        --[[
        local attemptToAGetModelVersion = checkModelVersion()

        if attemptToAGetModelVersion != modelVersion then
            Chat:UnicastMessage('The PolyAdmin model used in your game is out-of-date. I recommend updating the model by deleting it & re-adding it from the toolbox in the Polytoria Creator or by copying and pasting the script here: https://github.com/IndexGit01/PolytoriaAdmin/blob/main/PolyAdmin.lua', plr)
        end
        -- Check if the model is up-to-date
        --]]
    end

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

    plr.Chatted:Connect(function (msg)
        wait(0)
        -- Delay so the command happens after the message shows in chat
        
        local msg = msg:gsub("<noparse>", " "):gsub("</noparse>", " ")
        -- Remove the <noparse></noparse> to make the msg able to be used in an "if" statement

        local attributes = mysplit(msg)
        attributes[1] = attributes[1]:lower()
        -- Split the msg string by each space

        if attributes[1] == prefix .. "help" then
            if checkForPermissions(plr) then
                --[[
                local newNetworkMessage = NetMessage.New()
                newNetworkMessage.AddString("gui", "Cmds")
                script.Parent:FindChild('guiUpdate'):InvokeClient(newNetworkMessage, plr)
                --]]
                
                Chat:UnicastMessage('<color=#000>List of Commands (' .. #commandList .. ' commands available):</color>', plr)
                for i, v in pairs(commandList) do
                    Chat:UnicastMessage(v, plr)
                end
            end
        end

        if attributes[1] == prefix .. "about" then
            if checkForPermissions(plr) then
                Chat:UnicastMessage('<color=#000>About PolyAdmin (v' .. modelNumber .. '):</color>', plr)
                Chat:UnicastMessage('PolyAdmin is a model available on Polytoria that allows for moderation, utility, & fun commands made by Index.', plr)
                Chat:UnicastMessage('Thank you to Vibin <color=#007bff>(https://polytoria.com/user/20547)</color> for updated jail command!', plr)
                Chat:UnicastMessage('Thank you to Iaceon <color=#007bff>(https://polytoria.com/user/15952)</color> for many suggestions!', plr)
            end
        end

        if attributes[1] == prefix .. "kick" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)
    
                    if player != plr then
                        local reason = ""

                        for reasonCheck = 3, #attributes, 1 do
                            if attributes[reasonCheck] then
                                reason = reason .. " " .. attributes[reasonCheck]
                            end
                        end
        
                        if not reason then
                            reason = "no reason specified"
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

        if attributes[1] == prefix .. "warn" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)
    
                    local reason = ""

                    for reasonCheck = 3, #attributes, 1 do
                        if attributes[reasonCheck] then
                            reason = reason .. " " .. attributes[reasonCheck]
                        end
                    end
    
                    if not reason then
                        reason = "no reason specified"
                    end
    
                    if player then
                        Warn(player, reason)
                    else
                        Error("warn", "That player does not exist", plr)
                    end
                else
                    Error("warn", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "ban" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)
                    
                        if player != plr then
                            local reason = ""

                        for reasonCheck = 3, #attributes, 1 do
                            if attributes[reasonCheck] then
                                reason = reason .. " " .. attributes[reasonCheck]
                            end
                        end
    
                        if not reason then
                            reason = "no reason specified"
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

        if attributes[1] == prefix .. "shutdown" then
            if checkForPermissions(plr) then

                local reason = ""

                for reasonCheck = 2, #attributes, 1 do
                    if attributes[reasonCheck] then
                        reason = reason .. " " .. attributes[reasonCheck]
                    end
                end

                if reason == "" then
                    reason = "no reason given"
                end

                Shutdown(plr, reason)
            end
        end

        if attributes[1] == prefix .. "unban" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    Unban(attributes[2])
                end
            end
        end

        if attributes[1] == prefix .. "whitelist" then
            if checkForPermissions(plr) then
                local whitelistToPrint = 0
                for i, v in pairs(whitelist) do
                    if v then
                        whitelistToPrint = whitelistToPrint .. ", " .. v
                    end
                end
            end
        end

        if attributes[1] == prefix .. "whitelist" and attributes[2] == "enable" then
            if checkForPermissions(plr) then
                whitelistEnabled = true
                print(whitelistEnabled)
                Success(attributes[1] .. " " .. attributes[2], plr)
            end
        end

        if attributes[1] == prefix .. "whitelist" and attributes[2] == "disable" then
            if checkForPermissions(plr) then
                whitelistEnabled = false
                Success(attributes[1] .. " " .. attributes[2], plr)
            end
        end

        if attributes[1] == prefix .. "whitelist" and attributes[2] == "add" then
            if checkForPermissions(plr) then
                if attributes[3] then
                    local player = getPlayer(attributes[3])

                    if player then
                        AddToWhitelist(player)
                    else
                        Error("whitelist add", "Requires a valid player argument", plr)
                    end
                end
            end
        end

        if attributes[1] == prefix .. "whitelist" and attributes[2] == "remove" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[3])

                    if player then
                        RemoveFromWhitelist(player)
                    else
                        Error("whitelist remove", "Requires a valid player argument", plr)
                    end
                else
                    Error("whitelist remove", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "whitelist" and attributes[2] == "check" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[3])

                    if player then
                        Success("[" .. attributes[1] .. " " .. attributes[2] .. "] " .. checkWhitelist(player))
                    else
                        Error("whitelist check", "That player does not exist", plr)
                    end
                else
                    Error("whitelist check", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "isadmin" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    if player then
                        if freeAdmin == false then
                            if checkForPermissions(player) == true then
                                Chat:UnicastMessage('<color=#37c200>' .. player.Name .. ' is an admin.</color>', plr)
                            else
                                Chat:UnicastMessage('<color=#fa0000>' .. player.Name .. ' is NOT an admin.</color>', plr)
                            end
                        else
                            Chat:UnicastMessage('<color=#37c200>' .. player.Name .. ' is an admin [FREE ADMIN IS SET TO TRUE].</color>', plr)
                        end
                    else
                        Error("isadmin", "That player does not exist", plr)
                    end
                else
                    Error("isadmin", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "announce" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local reason = attributes[2]
                    for reasonCheck = 3, #attributes, 1 do
                        if attributes[reasonCheck] then
                            reason = reason .. " " .. attributes[reasonCheck]
                        end
                    end

                    Chat:BroadcastMessage("<color=#000>[Announcement by " .. plr.Name .. "]:</color> <color=#f50000>" .. reason .. "</color>")
                else
                    Error("announce", "Requires a valid announcement (string) argument.")
                end
            end
        end

        if attributes[1] == prefix .. "tp" then
            if checkForPermissions(plr) then
                if attributes[2] and attributes[3] then
                    local player1 = getPlayer(attributes[2], plr)
                    local player2 = getPlayer(attributes[3])

                    TP(player1, player2)
                else
                    Error("tp", "Requires 2 valid player arguments", plr)
                end
            end
        end

        if attributes[1] == prefix .. "bring" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player2 = getPlayer(attributes[2], plr)

                    TP(player2, plr)
                else
                    Error("bring", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "to" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player2 = getPlayer(attributes[2], plr)

                    TP(plr, player2)
                else
                    Error("to", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "explode" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)
                        
                    Explode(player)
                else
                    Error("explode", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "clickteleport" then
            if checkForPermissions(plr) then
                local newToolClone = game["Hidden"]:FindChild('ClickTeleport'):Clone()
                newToolClone.Parent = plr["Backpack"]
            end
        end

        if attributes[1] == prefix .. "respawn" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

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

        if attributes[1] == prefix .. "jail" then
            if checkForPermissions(plr) then
                local player = getPlayer(attributes[2], plr)

                Jail(player)
            end
        end

        if attributes[1] == prefix .. "unjail" then
            if checkForPermissions(plr) then
                local player = getPlayer(attributes[2], plr)

                Unjail(player)
            end
        end

        if attributes[1] == prefix .. "sword" then
            if checkForPermissions(plr) then
                local player = getPlayer(attributes[2], plr)
                    
                if type(player) == "table" then
                    for i, v in pairs(player) do
                        local newToolClone = game["Hidden"]:FindChild('Sword'):Clone()
                        newToolClone.Parent = v["Backpack"]
                    end
                else
                    local newToolClone = game["Hidden"]:FindChild('Sword'):Clone()
                    newToolClone.Parent = player["Backpack"]
                end
            end
        end

        if attributes[1] == prefix .. "music" and attributes[2] == "play" then
            if checkForPermissions(plr) then
                if attributes[1] and attributes[2] and attributes[3] then
                    if type(tonumber(attributes[3])) == "number" then
                        print("Attempt to start sound.")

                        print("Stopped all sound(s).")
                        for i, v in pairs(musicFolder:GetChildren()) do
                            if v:IsA('Sound') then
                                v:Stop()
                            end
                        end
                        
                        print("Broadcasted sound change alert.")
                        Chat:BroadcastMessage("<color=#37c200>Now playing: " .. attributes[3] .. " started by " .. plr.Name .. ".</color>")

                        print("Checked for cached sound:")
                        local cachedSoundCheck = checkCachedSounds(tonumber(attributes[3]))
                        print(cachedSoundCheck)

                        if cachedSoundCheck == false then
                            print("Sound is not cached.")

                            local newMusic = Instance.New('Sound')
                            newMusic.SoundID = tonumber(attributes[3])

                            newMusic.Volume = 5
                            newMusic.Parent = musicFolder
                            newMusic:Play()
                        else
                            print("Sound is cached.")

                            cachedSoundCheck:Play()
                        end
                    end
                end
            end
        end

        if attributes[1] == prefix .. "music" and attributes[2] == "stop" then
            if checkForPermissions(plr) then
                if attributes[1] and attributes[2] then
                    for i, v in pairs(musicFolder:GetChildren()) do
                        if v:IsA('Sound') then
                            v:Stop()
                        end
                    end
                end
            end
        end

        if attributes[1] == prefix .. "health" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

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
                        Error("health", "Requires a valid health argument", plr)
                    end
                else
                    Error("health", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "heal" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

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

        if attributes[1] == prefix .. "damage" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

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
                        Error("damage", "Requires a valid damage (number) argument", plr)
                    end
                else
                    Error("damage", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "kill" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

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
                    Error("kill", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "walkspeed" or attributes[1] == prefix .. "speed" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    if attributes[3] then
                        if type(tonumber(attributes[3])) == "number" then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        v.WalkSpeed = tonumber(attributes[3])
                                    end
                                end
                            else
                                player.WalkSpeed = tonumber(attributes[3])
                            end
                        else
                            if attributes[3] == "reset" then
                                if type(player) == "table" then
                                    for i, v in pairs(player) do
                                        if v:IsA('Player') then
                                            v.WalkSpeed = playerDefaults.WalkSpeed
                                        end
                                    end
                                else
                                    player.WalkSpeed = playerDefaults.WalkSpeed
                                end
                            else
                                Error("walkspeed", "Requires a number argument for the specified walk speed", plr)
                            end
                        end
                    else
                        Error("walkspeed", "Requires a valid walkspeed (number) argument", plr)
                    end
                else
                    Error("walkspeed", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "jumppower" or attributes[1] == prefix .. "jp" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

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
                        Error("jumppower", "Requires a valid jump power (number) argument", plr)
                    end
                else
                    Error("jumppower", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "freecam" then
            if checkForPermissions(plr) then
                Chat:UnicastMessage('[' .. prefix .. 'freecam] To exit free camera mode, type "' .. prefix .. 'reset" to completely reset your player or "' .. prefix .. 'resetcamera" to just reset your camera.', plr)
                plr.CameraMode = CameraMode.Free
            end
        end

        if attributes[1] == prefix .. "reset" or attributes[1] == prefix .. "re" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    resetPlayer(player)
                end
            end
        end

        if attributes[1] == prefix .. "resetcamera" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    player.CameraMode = CameraMode.FollowPlayer
                end
            end
        end

        if attributes[1] == prefix .. "freeze" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    if type(player) == "table" then
                        for i, v in pairs(player) do
                            if v:IsA('Player') then
                                v.WalkSpeed = 0
                            end
                        end
                    else
                        if player:IsA('Player') then
                            player.WalkSpeed = 0
                        end
                    end
                end
            end
        end

        if attributes[1] == prefix .. "unfreeze" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    if type(player) == "table" then
                        for i, v in pairs(player) do
                            if v:IsA('Player') then
                                v.WalkSpeed = 16
                            end
                        end
                    else
                        if player:IsA('Player') then
                            player.WalkSpeed = 16
                        end
                    end
                end
            end
        end

        if attributes[1] == prefix .. "chat" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    local message = ""

                    for messageCheck = 3, #attributes, 1 do
                        if attributes[messageCheck] then
                            message = message .. " " .. attributes[messageCheck]
                        end
                    end

                    -- Using the chat command to get players in moderation trouble either on Polytoria or in games is strictly forbidden

                    if type(player) == "table" then
                        for i, v in pairs(player) do
                            if v:IsA('Player') then
                                Chat:BroadcastMessage(v.Name .. ":" .. message)
                            end
                        end
                    else
                        if player:IsA('Player') then
                            Chat:BroadcastMessage(player.Name .. ":" .. message)
                        end
                    end
                end
            end
        end

        if attributes[1] == prefix .. "chatcolor" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    if type(player) == "table" then
                        for i, v in pairs(player) do
                            if v:IsA('Player') then
                                if checkForPermissions(v) == false then
                                    v.ChatColor = Color.FromHex(attributes[3])
                                else
                                    Chat:UnicastMessage("That player's chat color cannot be modify as they are an administrator.", plr)
                                end
                            end
                        end
                    else
                        if player:IsA('Player') then
                            if checkForPermissions(v) == false then
                                player.ChatColor = Color.FromHex(attributes[3])
                            else
                                Chat:UnicastMessage("That player's chat color cannot be modify as they are an administrator.", plr)
                            end
                        end
                    end
                end
            end
        end

        if attributes[1] == prefix .. "userid" or attributes[1] == prefix .. "uid" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    if type(player) != "table" then
                        if player:IsA('Player') then
                            Chat:UnicastMessage(player.Name .. "'s user ID is " .. player.UserID .. ".", plr)
                        end
                    end
                end
            end
        end

        if attributes[1] == prefix .. "respawntime" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

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
                        Error("respawntime", "Requires a valid respawn time (number) argument", plr)
                    end 
                else
                    Error("respawntime", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "sit" then
            if checkForPermissions(plr) then
                local player = getPlayer(attributes[2], plr)

                Sit(player)
            end
        end

        if attributes[1] == prefix .. "createtext" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    if attributes[3] then
                        local newText = Instance.New('Text3D')

                        local message = ""

                        for messageCheck = 3, #attributes, 1 do
                            if attributes[messageCheck] then
                                message = message .. " " .. attributes[messageCheck]
                            end
                        end

                        newText.Position = player.Position
                        newText.Rotation = player.Rotation
                        newText.Text = message
                    else
                        Error("createtext", "Requires a valid text (string) argument", plr)
                    end
                else
                    Error("createtext", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "message" or attributes[1] == prefix .. "msg" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    if attributes[3] then
                        local message = ""

                        for messageCheck = 3, #attributes, 1 do
                            if attributes[messageCheck] then
                                message = message .. " " .. attributes[messageCheck]
                            end
                        end

                        if type(player) == "table" then
                            for i, v in pairs(player) do
                                if v:IsA('Player') then
                                    Chat:UnicastMessage("[Message from " .. plr.Name .. "] " .. message, v)
                                end
                            end
                        else
                            Chat:UnicastMessage("[Message from " .. plr.Name .. "] " .. message, player)
                        end
                    else
                        Error("message", "Requires a valid message (string) argument", plr)
                    end
                else
                    Error("message", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "maxhealth" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    if attributes[3] then
                        if type(tonumber(attributes[3])) == "number" then
                            if type(player) == "table" then
                                for i, v in pairs(player) do
                                    if v:IsA('Player') then
                                        v.MaxHealth = tonumber(attributes[3])
                                    end
                                end
                            else
                                if player:IsA('Player') then
                                    player.MaxHealth = tonumber(attributes[3])
                                end
                            end
                        else
                            if attributes[3] == "reset" then
                                if type(player) == "table" then
                                    for i, v in pairs(player) do
                                        if v:IsA('Player') then
                                            v.MaxHealth = playerDefaults.MaxHealth
                                        end
                                    end
                                else
                                    if player:IsA('Player') then
                                        player.MaxHealth = playerDefaults.MaxHealth
                                    end
                                end
                            else
                                Error("maxhealth", "Requires a number argument for the specified max health", plr)
                            end
                        end
                    else
                        Error("maxhealth", "Requires a valid respawn time (number) argument", plr)
                    end 
                else
                    Error("maxhealth", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "cleartools" or attributes[1] == prefix .. "notools" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

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
                    Error("cleartools", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "droptool" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    if type(player) == "table" then
                        for i, v in pairs(player) do
                            if v:IsA('Player') then
                                v:DropTools()
                            end
                        end
                    else
                        if player:IsA('Player') then
                            player:DropTools()
                        end
                    end
                else
                    Error("droptool", "Requires a valid player argument", plr)
                end
            end
        end

        if attributes[1] == prefix .. "godmode" then
            if checkForPermissions(plr) then
                local newToolClone = game["Hidden"]:FindChild('GodMode-Explosion'):Clone()
                newToolClone.Parent = plr["Backpack"]
            end
        end

        --[[
        if attributes[1] == prefix .. "logs" then
            if checkForPermissions(plr) then
                local playergui = plr["PlayerGUI"]
                local logsGUI = playergui["Logs"]

                logsGUI.Visible = true
            end
        end
        --]]

        if attributes[1] == prefix .. "forcefield" or attributes[1] == prefix .. "ff" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

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

        if attributes[1] == prefix .. "unforcefield" or attributes[1] == prefix .. "unff" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    local player = getPlayer(attributes[2], plr)

                    if type(player) == "table" then
                        for i, v in pairs(player) do
                            if v:IsA('Player') then
                                v.MaxHealth = game["PlayerDefaults"].MaxHealth
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
                            player.MaxHealth = game["PlayerDefaults"].MaxHealth
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

        if attributes[1] == prefix .. "playercollisions" then
            if checkForPermissions(plr) then
                if attributes[2] then
                    if attributes[2] == "true" then
                        players.PlayerCollisionEnabled = true
                    else
                        players.PlayerCollisionEnabled = false
                    end
                end
            end
        end
    end)
end)

function checkForPermissions(plr)
    if freeAdmin == false then
        if not plr.IsCreator then
            for tablePosition = 1, #permissions do
                if permissions[tablePosition] == plr.UserID then
                    plr.ChatColor = adminChatColor
                    return true
                end
            end
            return false
        else
            plr.ChatColor = adminChatColor
            return true
        end
    else
        plr.ChatColor = adminChatColor
        return true
    end
    return false
end

function checkModelVersion()
    Http:Get('https://raw.githubusercontent.com/IndexGit01/PolytoriaAdmin/main/version.json', function (data, err, errmsg)
        if not err then
            print("DATA: " .. data)
            print("MODEL VERSION: " .. modelVersion)
            return data
        else
            print(errmsg)
            return errmsg
        end
    end,{})
end

function checkProtectedUsers(plr, executioner)
    if executioner.IsCreator == false then
        for tablePosition = 1, #protectedusers do
            if protectedusers[tablePosition] == plr.UserID then
                return true
            end
        end
    
        if protectGameCreator == true then
            if plr.IsCreator then
                return true
            end
        end
    
        if protectAdmins == true then
            if checkForPermissions(plr) then
                return true
            end
        end
        return false
    else
        return false
    end
end

function checkBanList(plr)
    for tablePosition = 1, #banlist do
        if banlist[tablePosition] == plr.UserID then
            return true
        end
    end
    return false
end

function checkWhitelist(plr)
    if whitelistEnabled == true then
        for tablePosition = 1, #whitelist do
            if whitelist[tablePosition] == plr.UserID then
                return true
            end
        end
        return false
    else
        if whitelistEnabled == false then
            return false
        end
    end
end

function getPlayer(plr, executioner)
    local playerTable = players:GetPlayers()

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
            if plr:lower() == "admins" then
                for i = 1, #playerTable, 1 do
                    if checkForPermissions(playerTable[i]) == false then
                        playerTable[i] = nil
                    end
                end

                return playerTable
            else
                if plr:lower() == "nonadmins" or plr:lower() == "non-admins" then
                    for i = 1, #playerTable, 1 do
                        if checkForPermissions(playerTable[i]) == true then
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
                            if string.find(v2, plr) then
                                return v
                            end
                        end
                    end
                end
            end
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
                v.RespawnTime = playerDefaults.RespawnTime
                v:Respawn()
        
                -- Reset Position + Rottion
                v.Position = oldPos
                v.Rotation = oldRotation
        
                -- Reset WalkSpeed + JumpPower
                v.WalkSpeed = playerDefaults.WalkSpeed
                v.JumpPower = playerDefaults.JumpPower
        
                -- Reset Health, Max Health & Respawn Time
                v.Health = playerDefaults.MaxHealth
                v.MaxHealth = playerDefaults.MaxHealth
                v.RespawnTime = playerDefaults.RespawnTime
                -- v.CameraMode = CameraMode.FollowPlayer
            end
        end
    else
        if plr:IsA('Player') then
            -- Save Old Position + Old Rotation
            local oldPos = plr.Position
            local oldRotation = plr.Rotation
    
            -- Respawn Player
            plr.RespawnTime = playerDefaults.RespawnTime
            plr:Respawn()
    
            -- Reset Position + Rottion
            plr.Position = oldPos
            plr.Rotation = oldRotation
    
            -- Reset WalkSpeed + JumpPower
            plr.WalkSpeed = playerDefaults.WalkSpeed
            plr.JumpPower = playerDefaults.JumpPower
    
            -- Reset Health, Max Health & Respawn Time
            plr.Health = playerDefaults.MaxHealth
            plr.MaxHealth = playerDefaults.MaxHealth
            plr.RespawnTime = playerDefaults.RespawnTime
            -- v.CameraMode = CameraMode.FollowPlayer
        end
    end
end

function checkCachedSounds(id)
    for i, v in pairs(musicFolder:GetChildren()) do
        if v.SoundID == id then
            return v
        end
    end
    return false
end

function Kick(plr, reason, executioner)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            if v:IsA('Player') then
                if checkProtectedUsers(v, executioner) == false then
                    Chat:UnicastMessage('You have been kicked from the game for: "' .. reason .. '".', v)
                    wait(0)
                    v:Kick('You have been kicked for: "' .. reason .. '".')
                else
                    Error("kick", v.Name .. " is protected from severe commands", executioner)
                end
            end
        end
    else
        if plr:IsA('Player') then
            if checkProtectedUsers(plr, executioner) == false then
                Chat:UnicastMessage('You have been kicked from the game for: "' .. reason .. '".', plr)
                wait(0)
                plr:Kick('You have been kicked from the game for: "' .. reason .. '".')
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
                if checkProtectedUsers(v, executioner) == false then
                    table.insert(banlist, plr.UserID)
                    wait(0)
                    Kick(plr, reason)
                else
                    Error("ban", v.Name .. " is protected from severe commands", executioner)
                end
            end
        end
    else
        if plr:IsA('Player') then
            if checkProtectedUsers(plr, executioner) == false then
                table.insert(banlist, plr.UserID)
                wait(0)
                Kick(plr, reason)
            else
                Error("ban", plr.Name .. " is protected from severe commands", executioner)
            end
        end
    end
end

function Warn(plr, reason)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            Chat:UnicastMessage('<color=#000>You have been warned for: "' .. reason .. '".</color>', plr)
        end
    else
        Chat:UnicastMessage('<color=#000>You have been warned for: "' .. reason .. '".</color>', plr)
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
    table.remove(banlist, plr.Name)
end

function Shutdown(plr, reason)
    Chat:BroadcastMessage('<color=#000>' .. plr.Name .. ' has shutdown the server for "' .. reason .. '".</color>')
    for i, v in pairs(players:GetPlayers()) do
        v:Kick(plr.Name .. ' has shutdown the server for "' .. reason .. '".')
    end
end

function TP(player1, player2)
    if type(player1) == "table" then
        for i, v in pairs(player1) do
            v.Position = player2.Position
        end
    else
        player1.Position = player2.Position
    end
end

function Explode(plr)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            environment:CreateExplosion(v.Position, 5, 1000, false)
        end
    else
        environment:CreateExplosion(plr.Position, 5, 1000, false)
    end
end

-- Credit to Vibin for updated jail command!
function Jail(plr)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            local jailCheckAttempt = environment:FindChild("Jail_" .. v.UserID)

            if not jailCheckAttempt then
                local newJailClone = game["Hidden"]:FindChild('Jail'):Clone()
                newJailClone.Parent = environment
                newJailClone.Position = v.Position
                newJailClone.Rotation = v.Rotation
                newJailClone.Name = "Jail_" .. v.UserID
                v.Position = newJailClone.Position
                
                v.Respawned:Connect(function ()
                    if environment:FindChild("Jail_" .. v.UserID) then
                        v.Position = newJailClone.Position
                        v.Rotation = newJailClone.Rotation
                    end
                end)

                players.PlayerRemoved:Connect(function (plrLeave)
                    if plrLeave.UserID == v.UserID then
                        for i, jails in pairs(jailcells) do
                            if jails.Name == "Jail_"..v.UserID then
                                jails:Destroy()                   
                                table.remove(jailcells, i)
                                    
                                break
                            end
                        end
                    end
                end)

                table.insert(jailcells, #jailcells + 1, newJailClone)
            else
                jailCheckAttempt.Position = v.Position
                v.Position = jailCheckAttempt.Position
                v.Rotation = jailCheckAttempt.Rotation
            end
        end
    else
        local jailCheckAttempt = environment:FindChild("Jail_" .. plr.UserID)

        if not jailCheckAttempt then
            local newJailClone = game["Hidden"]:FindChild('Jail'):Clone()
            newJailClone.Parent = environment
            newJailClone.Position = plr.Position
            newJailClone.Rotation = plr.Rotation
            newJailClone.Name = "Jail_" .. plr.UserID
            plr.Position = newJailClone.Position
            
            plr.Respawned:Connect(function ()
                if environment:FindChild("Jail_" .. plr.UserID) then
                    plr.Position = environment:FindChild("Jail_" .. plr.UserID).Position
                end
            end)

            players.PlayerRemoved:Connect(function (plrLeave)
                if plrLeave.UserID == plr.UserID then
                    for i, jails in pairs(jailcells) do
                        if jails.Name == "Jail_"..plr.UserID then
                            jails:Destroy()                   
                            table.remove(jailcells, i)
                                
                            break
                        end
                    end
                end
            end)

            table.insert(jailcells, #jailcells + 1, newJailClone)
        else
            jailCheckAttempt.Position = plr.Position
            plr.Position = jailCheckAttempt.Position
            plr.Rotation = jailCheckAttempt.Rotation
        end
    end
end

-- Credit to Vibin for updated jail command!
function Unjail(plr)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            for i, jails in pairs(jailcells) do
                if jails.Name == "Jail_"..v.UserID then
                    jails:Destroy()                   
                    table.remove(jailcells, i)

                    break
                end
            end
        end
    else
        for i, jails in pairs(jailcells) do
            if jails.Name == "Jail_"..plr.UserID then
                jails:Destroy()                   
                table.remove(jailcells, i)
                    
                break
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

                    Seat.Position = v.Position
                    Seat.Rotation = v.Rotation
                    Seat.Anchored = false
                    Seat.CanCollide = true

                    v:Sit(newSeat)

                    v.SittingIn.Changed:Connect(function ()
                        newSeat:Destroy()
                    end)
                end
            end
        end
    else
        local seatCheckAttempt = environment:FindChild("Seat_" .. plr.UserID)

        if not seatCheckAttempt then
            local newSeat = Instance.New('Seat')

            Seat.Position = plr.Position
            Seat.Rotation = plr.Rotation
            Seat.Anchored = true
            Seat.CanCollide = true

            plr:Sit(newSeat)

            plr.SittingIn.Changed:Connect(function ()
                newSeat:Destroy()
            end)
        end
    end
end

function Error(command, error, executioner)
    Chat:UnicastMessage("<color=#c20000>[" .. prefix .. command .. "] " .. error .. ".</color>", executioner)
end

function ErrorBool(error, executioner)
    Chat:UnicastMessage("<color=#c20000>[" .. error .. "] false.</color>", executioner)
end

function ErrorMessage(error, executioner)
    Chat:UnicastMessage("<color=#c20000>" .. error .. "</color>", executioner)
end

function Success(command, executioner)
    Chat:UnicastMessage("<color=#37c200>[" .. command .. "] Success.</color>", executioner)
end

function SuccesssBool(command, executioner)
    Chat:UnicastMessage("<color=#37c200>[" .. command .. "] true.</color>", executioner)
end

function SuccessMessage(command, executioner)
    Chat:UnicastMessage("<color=#37c200>" .. command .. "</color>", executioner)
end

function mysplit (inputstr, sep)
    if sep == nil then
       sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do 
       table.insert(t, str)
    end
    return t
end
