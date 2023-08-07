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
    self.States = {}

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
                 table.insert(gameState.players, {license = license, entity = GetPlayerPed(plyID)})
                 print(pName, 'joined the game', json.encode(self.Functions.getPlayers()))
                 return
            end
            print(pName, ' Attemping to join the game but hes already in')
        end
    end

    function self.Functions.getPlayers()
        return gameState.players
    end

    function self.Functions.playersAmount()
        return #gameState.players
    end

    function self.Functions.isPlayerAlreadyIn(plyID)
        local players = self.Functions.getPlayers()
        for _,v in pairs(players) do
            if v.license == plyID then
                return true
            end
            return false
        end
    end

    function self.Functions.removePlayerFromGame(plyID)
        local players = self.Functions.getPlayers()
        local player = nil


        for k,v in pairs(players) do
            if v.license == plyID then
                player = v or plyID
                table.remove(players, k)
            end
        end
        return player
    end

    function self.Functions.GenerateMap()
        local randomNumber = math.random(1, #Config.Locations)
        self.States.setMap(Config.Locations[randomNumber].name)

        return Config.Locations[randomNumber].name
    end

    -- Getters and Setters
    function self.States.setMap(map)
        gameState.map = map
        return gameState.map
    end

    function self.States.getMap()
        return gameState.map
    end

    function self.States.getMapCoords(map)
        for k,v in pairs(Config.Locations) do
            if (v.name == map) then
                return v.coords
            end
            return nil
        end
    end

    function self.States.change(Mode)
        gameState.currentState = States[Mode]
    end
    return self
end

local NewLMS = LMS.Init()

RegisterNetEvent('senor-lms:server:enterlms')
AddEventHandler('senor-lms:server:enterlms', function()
    local src = source
    local ped = GetPlayerPed(src)

    if (gameState.currentState == States.IN_PROGRESS) then
        print('cant join right now, game is active')
        return
    end

    NewLMS.Functions.addPlayerToGame(src)
    TriggerClientEvent('senor-lms:client:flagPlayer', src, States['WAITING'])
end)

RegisterNetEvent('senor-lms:server:leavelms')
AddEventHandler('senor-lms:server:leavelms', function(data)
    local src = source
    local args = (data[1] ~= nil and data[1] ~= "") and data[1] or src
    local license = NewLMS.Functions.GetIdentifier(args, 'license')
    local pName = GetPlayerName(src)

    if args ~= nil then
        local retval = NewLMS.Functions.removePlayerFromGame(license)
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
        NewLMS.Functions.GenerateMap()
        TriggerEvent('senor-lms:server:TeleportPlayers', NewLMS.Functions.getPlayers())
        TriggerClientEvent('QBCore:Notify', src, 'You are being teleported to LMS', 'primary', 5000)
        TriggerClientEvent('senor-lms:client:flagPlayer', src, States['STARTING'])
        return
    end

    print('Not enough players')
end)

RegisterNetEvent('senor-lms:server:TeleportPlayers')
AddEventHandler('senor-lms:server:TeleportPlayers', function(players)
    local src = source
    local map = NewLMS.States.getMapCoords(NewLMS.States.getMap()) 
    local playersAmount = NewLMS.Functions.playersAmount()
    -- TODO: set the Config.Locations[1] dynamic with the maps and not hardcoded
    for k,v in pairs(players) do
        SetEntityCoords(v.entity, Config.Locations[1].coords[k])
    end
end)


