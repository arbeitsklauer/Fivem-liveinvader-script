-- Lifeinvader Server Script
local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('liveinvader:sendAd')
AddEventHandler('liveinvader:sendAd', function(data)
    local _source = source
    local message = data.message
    local paymentMethod = data.paymentMethod or 'money'
    local cost = #message * 5
    local xPlayer = ESX.GetPlayerFromId(_source)

    if not xPlayer then return end

    local currentCash = xPlayer.getAccount(paymentMethod).money
    
    if currentCash >= cost then
        xPlayer.removeAccountMoney(paymentMethod, cost)
        
        -- BROADCAST TO ALL PLAYERS
        local playerName = xPlayer.getName()
        TriggerClientEvent('liveinvader:receiveAd', -1, playerName, message)
        
        -- Global Sound/Notification (Optional but good for feedback)
        -- TriggerClientEvent('chat:addMessage', -1, { args = { '^1Liveinvader', playerName .. ': ' .. message } })
    else
        TriggerClientEvent('liveinvader:notify', _source, "Lifeinvader", "Nicht genug Geld! (" .. cost .. "$ benötigt)", "error")
    end
end)
