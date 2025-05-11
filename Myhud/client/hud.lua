local isHidden = false
local uiLoaded = false
local wasTalking = false
local hunger, thirst = 100, 100
local currentStreet = "Unknown Street"
local ESX = exports['es_extended']:getSharedObject()



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)
        local isTalking = NetworkIsPlayerTalking(PlayerId())
        
        if isTalking ~= wasTalking then
            wasTalking = isTalking
            if uiLoaded then
                SendNUIMessage({
                    type = 'UPDATE_VOICE',
                    talking = isTalking
                })
            end
        end
    end
end)



Citizen.CreateThread(function()
    while true do
        if not isHidden then
            local playerPed = PlayerPedId()
            local health = math.max(0, math.min(100, GetEntityHealth(playerPed) - 100))
            local armor = math.max(0, math.min(100, GetPedArmour(playerPed)))
            
            if uiLoaded then
                SendNUIMessage({
                    type = 'UPDATE_HUD',
                    health = health,
                    armor = armor,
                    hunger = hunger,
                    thirst = thirst
                })
            end
        end
        Citizen.Wait(1000)
    end
end)


Citizen.CreateThread(function()
    while true do
        TriggerEvent('esx_status:getStatus', 'hunger', function(status)
            hunger = status.getPercent()
        end)
        
        TriggerEvent('esx_status:getStatus', 'thirst', function(status)
            thirst = status.getPercent()
        end)
        Citizen.Wait(10000)
    end
end)


Citizen.CreateThread(function()
    while true do
        if not isHidden then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local streetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
            local streetName = GetStreetNameFromHashKey(streetHash)
            
            if streetName ~= currentStreet then
                currentStreet = streetName
                if uiLoaded then
                    SendNUIMessage({
                        type = 'UPDATE_HUD',
                        street = streetName
                    })
                end
            end
        end
        Citizen.Wait(2000)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)
        local shouldHide = IsPauseMenuActive() or IsRadarHidden()
        
        if shouldHide and not isHidden then
            isHidden = true
            if uiLoaded then SendNUIMessage({type = 'HIDE_HUD'}) end
        elseif not shouldHide and isHidden then
            isHidden = false
            if uiLoaded then SendNUIMessage({type = 'SHOW_HUD'}) end
        end
    end
end)


Citizen.CreateThread(function()
    while not uiLoaded do
        SendNUIMessage({type = 'PING'})
        Citizen.Wait(1000)
    end
end)


RegisterNUICallback('UI_READY', function(data, cb)
    uiLoaded = true
    cb({})
end)