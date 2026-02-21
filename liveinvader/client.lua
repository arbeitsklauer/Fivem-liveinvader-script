-- Lifeinvader Client Script
local isUIOpen = false
local lifeinvaderCoords = vector3(-1083.0861, -248.0762, 37.7633) -- NEW COORDINATES

-- Function to Toggle UI
function ToggleUI()
    isUIOpen = not isUIOpen
    SetNuiFocus(isUIOpen, isUIOpen)
    SendNUIMessage({
        type = "toggleUI",
        status = isUIOpen
    })
end

-- Custom Notification Trigger
function TriggerNotification(title, message, style)
    SendNUIMessage({
        type = "notification",
        title = title,
        message = message,
        style = style or "default"
    })
end

-- Notification Event for Server
RegisterNetEvent('liveinvader:notify')
AddEventHandler('liveinvader:notify', function(title, message, style)
    TriggerNotification(title, message, style)
end)

-- Send Ad Callback
RegisterNUICallback('sendAd', function(data, cb)
    if data.message and #data.message > 0 then
        TriggerServerEvent('liveinvader:sendAd', data)
        cb('ok')
    else
        cb('error')
    end
end)

-- Receive Ad from Server
RegisterNetEvent('liveinvader:receiveAd')
AddEventHandler('liveinvader:receiveAd', function(name, message)
    SendNUIMessage({
        type = "addAd",
        name = name,
        message = message
    })
    
    -- Global Notification for the Ad (Format: Name: Message)
    TriggerNotification("Lifeinvader News", name .. ": " .. message, "info")
end)

-- Close UI Callback
RegisterNUICallback('closeUI', function(data, cb)
    ToggleUI()
    cb('ok')
end)

-- Interaction Loop (Marker & Interaction)
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - lifeinvaderCoords)

        if distance < 10.0 then
            sleep = 0
            -- Roter Zylinder-Marker am Boden (Circle Interaction)
            DrawMarker(1, lifeinvaderCoords.x, lifeinvaderCoords.y, lifeinvaderCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 209, 33, 39, 150, false, false, 2, false, nil, nil, false)
            
            if distance < 2.0 then
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName("Drücke ~INPUT_CONTEXT~ um ~r~Lifeinvader~s~ zu öffnen")
                EndTextCommandDisplayHelp(0, false, true, -1)

                if IsControlJustReleased(0, 38) then -- E Taste
                    ToggleUI()
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- Command also available (optional, but markers are now primary)
RegisterCommand('liveinvader', function()
    ToggleUI()
end)
