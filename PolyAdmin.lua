-- PolyAdmin v1.0
-- Model made by Index

-- I recommend joining this Discord server to be notified when the model gets updates: https://discord.gg/XV6rDrjVkV

local players = game["Players"]
local environment = game["Environment"]
local polyAdminModel = environment:FindChild('PolyAdmin')

local modelVersion = "1.0"

local musicFolder = Instance.New("Part")
musicFolder.Size = Vector3.New(0, 0, 0)
musicFolder.CanCollide = false
musicFolder.Anchored = true
musicFolder.Parent = environment
musicFolder.Name = "Music_Folder"

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

local whitelistEnabled = false
-- Stores if the whitelist is enabled or disabled (**WHITELIST IS COMING SOON**)

local whitelist = {}
-- Players that are whitelisted from your game if "whitelistEnabled" variable equals true (**WHITELIST IS COMING SOON**)

local banlist = {}
-- Players that are banned from your game

local adminChatColor = Color.FromHex('#000')
-- Chat color for admins that join your game

local freeAdmin = false
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
    prefix .. "reset (OR) re [plr]",
    prefix .. "walkspeed (OR) speed [plr] [speed]",
    prefix .. "jumppower (OR) jp [plr] [power]",
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
    end

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
                for i, v in pairs(commandList) do
                    Chat:UnicastMessage(v, plr)
                end
            end
        else
            if attributes[1] == prefix .. "kick" then
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
                            Kick(player, reason, plr)
                        end
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
                        end
                    end
                end
            end

            if attributes[1] == prefix .. "ban" then
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
                            Ban(player, reason, plr)
                        end
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
                            if checkForPermissions(player) == true then
                                Chat:UnicastMessage(player.Name .. ' is an admin.', plr)
                            else
                                Chat:UnicastMessage(player.Name .. ' is NOT an admin.', plr)
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

                    Unjail(plr)
                end
            end

            if attributes[1] == prefix .. "sword" then
                if checkForPermissions(plr) then
                    local player = getPlayer(attributes[2], plr)
                        
                    if type(player) == "table" then
                        for i, v in pairs(player) do
                            local newToolClone = game["Hidden"]:FindChild('Great-Sword'):Clone()
                            newToolClone.Parent = v["Backpack"]
                        end
                    else
                        local newToolClone = game["Hidden"]:FindChild('Great-Sword'):Clone()
                        newToolClone.Parent = player["Backpack"]
                    end
                end
            end

            if attributes[1] == prefix .. "music" and attributes[2] == prefix .. "play" then
                if checkForPermissions(plr) then
                    if attributes[1] and attributes[2] and attributes[3] then
                        local newMusic = Instance.New('Sound')
                        newMusic.SoundID = attributes[3]
                        newMusic.Parent = musicFolder
                        newMusic:Play()
                        newMusic.Playing = true
                    end
                end
            end

            if attributes[1] == prefix .. "music" and attributes[2] == prefix .. "stop" then
                if checkForPermissions(plr) then
                    if attributes[1] and attributes[2] then
                        for i, v in pairs(musicFolder:GetChildren()) do
                            if v:IsA('Sound') then
                                v:Destroy()
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
                            Error("jumppower", "Requires a valid jump power (number) argument", plr)
                        end
                    else
                        Error("jumppower", "Requires a valid player argument", plr)
                    end
                end
            end

            if attributes[1] == prefix .. "version" then
                if checkForPermissions(plr) then
                    SuccessMessage("The PolyAdmin model in this game is: v" .. modelVersion, plr)
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
    if plr:IsA('Player') then
        -- Save Old Position + Old Rotation
        local oldPos = plr.Position
        local oldRotation = plr.Rotation

        -- Respawn Player
        plr.RespawnTime = 0
        plr:Respawn()

        -- Reset Position + Rottion
        plr.Position = oldPos
        plr.Rotation = oldRotation

        -- Reset WalkSpeed + JumpPower
        plr.WalkSpeed = 16
        plr.JumpPower = 36

        -- Reset Health & Respawn Time
        plr.Health = 100
        plr.RespawnTime = 5
        -- plr.CameraMode = CameraMode.FollowPlayer
    end
end

function Kick(plr, reason, executioner)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            if plr.Name != "Index" then
                Chat:UnicastMessage('You have been kicked from the game for: "' .. reason .. '".', v)
                wait(0)
                v:Kick('You have been kicked for: "' .. reason .. '".')
            else
                Error("kick", "You do not have the correct permission to run this command", plr)
            end
        end
    else
        Chat:UnicastMessage('You have been kicked from the game for: "' .. reason .. '".', plr)
        wait(0)
        plr:Kick('You have been kicked from the game for: "' .. reason .. '".')
    end
end

function Ban(plr, reason, executioner)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            if plr.Name != "Index" then
                table.insert(banlist, plr.UserID)
                wait(0)
                Kick(plr, reason)
            else
                Error("ban", "You do not have the correct permission to run this command", plr)
            end
        end
    else
        table.insert(banlist, plr.UserID)
        wait(0)
        Kick(plr, reason)
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
                        if environment:FindChild("Jail_" .. v.UserID) then
                            environment:FindChild("Jail_" .. v.UserID):Destroy()
                        end
                    end
                end)
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
                    if environment:FindChild("Jail_" .. plr.UserID) then
                        environment:FindChild("Jail_" .. plr.UserID):Destroy()
                    end
                end
            end)
        else
            jailCheckAttempt.Position = plr.Position
            plr.Position = jailCheckAttempt.Position
            plr.Rotation = jailCheckAttempt.Rotation
        end
    end
end

function Unjail(plr)
    if type(plr) == "table" then
        for i, v in pairs(plr) do
            local jailCheckAttempt = environment:FindChild("Jail_" .. v.UserID)

            if jailCheckAttempt then
                jailCheckAttempt:Destroy()
            end
        end
    else
        local jailCheckAttempt = environment:FindChild("Jail_" .. plr.UserID)

        if jailCheckAttempt then
            jailCheckAttempt:Destroy()
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
