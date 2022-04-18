local players = game["Players"]
local environment = game["Environment"]

print("IndexAdminCommands: enabled.")

local freeadmin = false
-- **ENABLING THIS SETTING WILL MAKE EVERYONE IN YOUR GAME HAVE PERMISSIONS TO USE ADMIN**

local prefix = ":"
-- **PREFIX CANNOT BE "/" OR ALL COMMANDS WILL BE UNUSABLE DUE TO POLYTORIA'S INTEGRATED COMMAND AUTOCOMPLETION!**

-- PERMISSIONS:
local permissions = {
    -- INDEX (you can remove me if you want UwU):
    2782
}

-- PLAYER BLACKLIST:
local playerBlacklist = {
    -- Enter a USER ID here.
}

local adminChatColor = Color.FromHex('#000000')
local argumentsError = "[Only you can see this message] This command is missing argument(s). Do " .. prefix .. "help for more command information."

local listOfCommands = {
    prefix .. "help",
    prefix .. "shutdown [REASON (required)]",
    prefix .. "announce [TEXT (required)]",
    prefix .. "kick [PLAYER (required)] [REASON (required)]",
    prefix .. "explode [PLAYER (default: me)]",
    --prefix .. "giant [PLAYER (required)]",
    prefix .. "kill [PLAYER (default: me)]",
    prefix .. "damage [PLAYER (required)] [DAMAGE (required)]",
    prefix .. "heal [PLAYER (required)] [HEAL BY]",
    prefix .. "health [PLAYER (required)] [HEALTH (required)]",
    prefix .. "createNPC",
    prefix .. "clone [PLAYER (default: me)]"
}

players.PlayerAdded:Connect(function (plr)

    if checkPlayerBlackList(plr, plr.UserID) == true then
        Chat:UnicastMessage("You have been blacklisted, thank you for playing.", plr)
    end

    print("Player joined: " .. plr.Name)
    if checkPlayerPermissions(plr, plr.UserID) == true then
        print("Player is creator: " .. plr.Name)

        plr.ChatColor = adminChatColor
        Chat:UnicastMessage("You are an administrator inside of this game. Do " .. prefix .. "help for a list of commands.", plr)

        plr.Chatted:Connect(function (msg)
            print("Creator sent message: " .. msg)

            local filteredMessage = msg:gsub("<noparse>", ""):gsub("</noparse>", "")
            filteredMessage = mysplit(filteredMessage)

            if filteredMessage[1] == prefix .. "help" then
                wait(0)

                Chat:UnicastMessage("List of commands (" .. #listOfCommands .. " commands currently available)", plr)

                for i, v in pairs(listOfCommands) do
                    Chat:UnicastMessage(v, plr)
                end
            end

            if filteredMessage[1] == prefix .. "shutdown" then
                wait(0)     

                print("Run shutdown command.")

                local reason = filteredMessage[2]
                for reasonCheck = 3, #filteredMessage, 1 do
                    if filteredMessage[reasonCheck] then
                        reason = reason .. " " .. filteredMessage[reasonCheck]
                    end
                end

                if reason != "" then
                    shutdownCommand(reason)
                end
                
                if reason then
                    -- do nothing
                else
                    Chat:UnicastMessage(argumentsError, plr)
                end
            end

            if filteredMessage[1] == prefix .. "kick" then
                wait(0)   

                print("Run kick command.")

                local player = players:GetPlayer(filteredMessage[2])
                local reason = filteredMessage[3]

                for reasonCheck = 4, #filteredMessage, 1 do
                    if filteredMessage[reasonCheck] then
                        reason = reason .. " " .. filteredMessage[reasonCheck]
                    end
                end

                if reason != nil then
                    if player:IsA("Player") then
                        kickCommand(player, reason)
                    end
                else
                    Chat:UnicastMessage(argumentsError, plr)
                end
            end

            if filteredMessage[1] == prefix .. "announce" then
                wait(0)

                print("Run announce command.")

                local text = filteredMessage[2]

                for textCheck = 3, #filteredMessage, 1 do
                    if filteredMessage[textCheck] then
                        text = text .. " " .. filteredMessage[textCheck]
                    end
                end

                if text != nil then
                    announceCommand(text, plr)
                else
                    Chat:UnicastMessage(argumentsError, plr)
                end
            end

            if filteredMessage[1] == prefix .. "explode" then
                wait(0)

                print("Run explode player command.")

                local player = players:GetPlayer(filteredMessage[2])

                if player != nil then
                    explodePlayerCommand(player, plr)
                else
                    explodePlayerCommand(plr, plr)
                    --Chat:UnicastMessage(argumentsError, plr)
                end
            end

            if filteredMessage[1] == prefix .. "giant" then
                wait(0)

                print("Run giant player command.")

                local player = players:GetPlayer(filteredMessage[2])

                if player != nil then
                    giantPlayerCommand(player, plr)
                else
                    giantPlayerCommand(plr, plr)
                    --Chat:UnicastMessage(argumentsError, plr)
                end
            end

            if filteredMessage[1] == prefix .. "kill" then
                wait(0)

                print("Run kill player command.")

                local player = players:GetPlayer(filteredMessage[2])

                if player != nil then
                    killPlayerCommand(player, plr)
                else
                    killPlayerCommand(plr, plr)
                    --Chat:UnicastMessage(argumentsError, plr)
                end
            end

            if filteredMessage[1] == prefix .. "damage" then
                wait(0)

                print("Run damage player command.")

                local player = players:GetPlayer(filteredMessage[2])
                local damage = filteredMessage[3]

                if player != nil then
                    if damage != nil then
                        damagePlayerCommand(player, damage, plr)
                    else
                        Chat:UnicastMessage(argumentsError, plr)
                    end
                else
                    Chat:UnicastMessage(argumentsError, plr)
                end
            end

            if filteredMessage[1] == prefix .. "heal" then
                wait(0)

                print("Run heal player command.")

                local player = players:GetPlayer(filteredMessage[2])
                local health = filteredMessage[3]

                if player != nil then
                    if health != nil then
                        healPlayerCommand(player, health, plr)
                    else
                        healPlayerCommand(player, 100, plr)
                    end
                else
                    Chat:UnicastMessage(argumentsError, plr)
                end
            end

            if filteredMessage[1] == prefix .. "health" then
                wait(0)

                print("Run set player health command.")

                local player = players:GetPlayer(filteredMessage[2])
                local health = filteredMessage[3]

                if player != nil then
                    if health != nil then
                        setHealthPlayerCommand(player, health, plr)
                    else
                        Chat:UnicastMessage(argumentsError, plr)
                    end
                else
                    Chat:UnicastMessage(argumentsError, plr)
                end
            end

            if filteredMessage[1] == prefix .. "createNPC" then
                wait(0)

                print("Run createNPC command.")

                createNPCCommand(plr)
            end

            if filteredMessage[1] == prefix .. "clone" then
                wait(0)

                print("Run clone player command.")

                local player = players:GetPlayer(filteredMessage[2])

                if player != nil then
                    playerCloneCommand(player, plr)
                else
                    Chat:UnicastMessage(argumentsError, plr)
                end
            end
        end)
    end
end)

function checkPlayerPermissions(plr, userid)
    if freeadmin == false then
        print("Free Admin: disabled.")
        for i, v in pairs(permissions) do
            if userid == v then
                return true
            else
                return false
            end
        end
    else
        if freeadmin == true then
            print("Free Admin: enabled.")
            return true
        end
    end
end

function checkPlayerBlackList(plr, userid)
    for i, v in pairs(playerBlacklist) do
        if userid == v then
            return true
        else
            return false
        end
    end
end

--[[
CHECK FOR COMMON PLAYERS (ex. "me", "all", "everyone", "others")

function checkForCommonPlayers(plr, i)
    if i == "me" then
        return plr
    else i == "everyone" then
        return players:GetPlayers()
    else
        return i
    end
end
--]]

function shutdownCommand(reason)
    print(reason)
    Chat:BroadcastMessage("The server will shutdown in 3 second(s) for " .. reason .. ".")
    for loop = 2, 0, -1 do
        wait(1.1)
        Chat:BroadcastMessage("The server will shutdown in " .. loop .. " second(s) for " .. reason .. ".")
    end

    for i, v in pairs(game["Players"]:GetPlayers()) do
        v:Kick()
    end
end

function kickCommand(player, reason, executioner)
    print(reason)

    if reason == nil then
        reason = "nil reason"
    end

    Chat:UnicastMessage('You have been kicked for "' .. reason .. '"', player)
    player:Kick()

    Chat:UnicastMessage("Successfully kicked player " .. player.Name .. ".", executioner)
end

function announceCommand(text, executioner)
    Chat:BroadcastMessage(text)
    Chat:UnicastMessage("Successfully send announcement, " .. text .. ".", executioner)
end

function explodePlayerCommand(player, executioner)
    player.Health = 0
    environment:CreateExplosion(player.Position, 30, 1000, false)
    Chat:UnicastMessage("Successfully exploded " .. player.Name, executioner)
end

function giantPlayerCommand(player, executioner)
    player.Size = Vector.new(2, 2, 2)
    Chat:UnicastMessage("Successfully made " .. player.Name .. " giant.", executioner)
end

function killPlayerCommand(player, executioner)
    player.Health = 0
    Chat:UnicastMessage("Successfully killed " .. player.Name .. ".", executioner)
end

function damagePlayerCommand(player, damage, executioner)
    player.Health = player.Health - damage
    Chat:UnicastMessage("Successfully damaged " .. player.Name .. " by " .. damage  .. ".", executioner)
end

function healPlayerCommand(player, health, executioner)
    player.Health = player.Health + health

    if player.Health > 100 then
        local over100Health = player.Health - 100
        local health = player.Health - over100Health
        player.Health = health
    end

    Chat:UnicastMessage("Successfully healed " .. player.Name .. " by " .. health .. ".", executioner)
end

function createNPCCommand(executioner)
    local newNPC = Instance.New('NPC')
    newNPC.Position = executioner.Position
    newNPC.Rotation = executioner.Rotation
end

function playerCloneCommand(plr, executioner)
    local newClone = plr:Clone()
    newClone.Position = plr.Position
    newClone.Rotation = plr.Rotation
end

function setHealthPlayerCommand(player, health, executioner)
    player.health = health
    Chat:UnicastMessage("Successfully set health of " .. player.Name .. " to " .. health .. ".", executioner)
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
