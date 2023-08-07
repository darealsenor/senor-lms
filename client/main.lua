
-- Commands
RegisterCommand('lms', function(source, args, rawCommand)
    TriggerServerEvent('senor-lms:server:enterlms')
end, false)

RegisterCommand('leave', function(source, args, rawCommand)
    TriggerServerEvent('senor-lms:server:leavelms', args)
end, false)

RegisterCommand('flag', function()
    print(playerFlagged)
end)

-- -- -- -- -

-- States and Events
local playerFlagged = nil

RegisterNetEvent('senor-lms:client:flagPlayer')
AddEventHandler('senor-lms:client:flagPlayer', function(state)
    print('you are being flagged with' .. state)
    playerFlagged = state
end)

-- Threads
CreateThread(function()
    -- TODO: FIX - I want to run the loop only if player is flagged
    while true do
        Wait(1000)
        if playerFlagged == States['WAITING'] then
            TriggerServerEvent('senor-lms:server:attemptTransfer')
        end
    end
end)


