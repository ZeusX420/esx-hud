function ShowNotification(msg)
    ESX.ShowNotification(msg)
end

function UpdateHUD(data)
    SendNUIMessage({
        type = 'UPDATE_HUD',
        health = data.health,
        armor = data.armor,
        hunger = data.hunger,
        thirst = data.thirst,
        street = data.street
    })
end