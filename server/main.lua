local gameState = {
    players = {},
    map = '',
    currentState = States.WAITING,
    currentRound = 0,
    currentRoundState = nil,
    winners = {}
}

local LMS = {}

function LMS.Init()
    local self = {}
    self.Functions = {}

    -- taken from qb core
    function self.Functions.GetIdentifier(source, idtype)
        local identifiers = GetPlayerIdentifiers(source)
        for _, identifier in pairs(identifiers) do
            if string.find(identifier, idtype) then
                return identifier
            end
        end
        return nil
    end

    function self.Functions.addPlayerToGame(plyID)
        local license = self.Functions.GetIdentifier(plyID, 'license')
        local pName = GetPlayerName(plyID)
        if license and license ~= 'nil' then
            -- Player = self.Functions.isPlayerAlreadyIn(license) == true or table.insert(gameState.players, license)
            local retval = self.Functions.isPlayerAlreadyIn(license)
            if not retval then
                 table.insert(gameState.players, license)
                 print(pName, 'joined the game', json.encode(self.Functions.getPlayers()))
                 return
            end
            print(pName, ' Attemping to join the game but hes already in')
        end
    end

    function self.Functions.getPlayers()
        return gameState.players
    end

    function self.Functions.isPlayerAlreadyIn(plyID)
        local players = self.Functions.getPlayers()
        for _,v in pairs(players) do
            if v == plyID then
                return true
            end
            return false
        end
    end

    function self.Functions.removePlayerFromGame(plyID)
        local players = self.Functions.getPlayers()
        local player = nil


        for k,v in pairs(players) do
            if v == plyID then
                player = v or plyID
                table.remove(players, k)
            end
        end
        return player
    end

    function self.Functions.changeState(Mode)
        gameState.currentState = States[Mode]
    end

    return self
end

RegisterNetEvent('senor-lms:server:enterlms')
AddEventHandler('senor-lms:server:enterlms', function()
    local src = source

    if (gameState.currentState == States.IN_PROGRESS) then
        print('cant join right now, game is active')
        return
    end

    LMS.Init().Functions.addPlayerToGame(src)
    TriggerClientEvent('senor-lms:client:flagPlayer', src, States['WAITING'])
end)

RegisterNetEvent('senor-lms:server:leavelms')
AddEventHandler('senor-lms:server:leavelms', function(data)
    local src = source
    local args = (data[1] ~= nil and data[1] ~= "") and data[1] or src
    local license = QBCore.Functions.GetIdentifier(args, 'license')
    local pName = GetPlayerName(src)

    if args ~= nil then
        local retval = LMS.Init().Functions.removePlayerFromGame(license)
        if (retval and retval ~= nil) then
            print(pName .. ' was removed from the game')
            TriggerClientEvent('senor-lms:client:flagPlayer', src, States['OFF'])
            return
        end
    end

    print('you are not in a game, cant leave')
end)

RegisterNetEvent('senor-lms:server:attemptTransfer')
AddEventHandler('senor-lms:server:attemptTransfer', function()
    local src = source

    if (#gameState.players <= Config.MinimumPlayers) then
        TriggerEvent('senor-lms:server:TeleportPlayers')
        TriggerClientEvent('QBCore:Notify', src, 'You are being teleported to LMS', 'primary', 5000)
        TriggerClientEvent('senor-lms:client:flagPlayer', src, States['STARTING'])
        return
    end

    print('Not enough players')
end)




-- Old code no Class
-- local function getPlayers()
--     return gameState.players
-- end

-- local function addPlayerToGame(netId)
--     local license = string.gsub(GetPlayerIdentifiers(netId)[1], "license:", "")
--     local steamName = GetPlayerName(netId)

--     local players = getPlayers()
--     for k,v in pairs(players) do
--         local playerLicense = v[1]
--         local playerObj = players[k][1]
--         if playerObj == playerLicense then 
--             print('Player: ' .. steamName .. ' already in game')
--             return
--         end
--     end
--     print('Player: '.. steamName .. ' joined game.')
--     table.insert(gameState.players, {license, steamName})
-- end

-- RegisterNetEvent('senor-lms:client:enterlms')
-- AddEventHandler('senor-lms:client:enterlms', function()
--     local src = source

--     if (gameState.currentState == States.IN_PROGRESS) then 
--         print('cant join right now, game is active')
--         return
--     end

--     addPlayerToGame(src)

--     TriggerClientEvent('senor-lms:client:enteredlms', src)
-- end)

-- function ShareGameData(field)
--     if (not field) then return gameState end

--     return gameState[field]
-- end

