
-- Commands
RegisterCommand('lms', function(source, args, rawCommand)
    TriggerServerEvent('senor-lms:server:enterlms')
end, false)

RegisterCommand('leave', function(source, args, rawCommand)
    TriggerServerEvent('senor-lms:server:leavelms', args)
end, false)


-- function IsPlayerInList(playerList, player)
    
--     for k,v in ipairs(playerList) do
        
--         if (playerList.license)
--     end
-- end

-- -- -- -- -

-- States and Events
local playerFlagged = nil

RegisterNetEvent('senor-lms:client:flagPlayer')
AddEventHandler('senor-lms:client:flagPlayer', function(state)
    playerFlagged = state
    print('given state:', state)
    print(get_key_for_value(States, state))
end)

RegisterNetEvent('senor-lms:client:killSubscriber')
AddEventHandler('senor-lms:client:killSubscriber', function(players)
    -- TODO: Get player entity from network (Only LMS Players), if found true >
    -- Send server killers & victim data.
    AddEventHandler('gameEventTriggered', function(name ,data)
        if (name == 'CEventNetworkEntityDamage') then
            local victim, attacker, victimDied, weapon = data[1], data[2], data[4], data[7]
            if not IsEntityAPed(victim) then 
                print('thats an npc,' .. victim)
                return 
            end

            local playerid = NetworkGetPlayerIndexFromPed(victim)
            local playerName = GetPlayerName(playerid) .. " " .. "("..GetPlayerServerId(playerid)..")"
            local killerId = NetworkGetPlayerIndexFromPed(attacker)
            local killerName = GetPlayerName(killerId) .. " " .. "("..GetPlayerServerId(killerId)..")"
            print(playerId, playerName , 'victim')
            print( killerId, killerName, 'killer')
        end
    end)
end)

-- Debug
function get_key_for_value( t, value )
    for k,v in pairs(t) do
      if v==value then return k end
    end
    return nil
  end

-- Threads
CreateThread(function()
    -- TODO: FIX - I want to run the loop only if player is flagged
    while true do
        Wait(1000)
        if playerFlagged == States['WAITING'] and  playerFlagged ~= States['IN_PROGRES'] then
            TriggerServerEvent('senor-lms:server:attemptTransfer')
        end
    end
end)




RegisterCommand('flag', function()
    print(playerFlagged)
end)