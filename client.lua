local CBCore = exports['cb-core']:GetCoreObject()
local hasPhone = false

local function DoPhoneCheck(PlayerItems)
    local _hasPhone = false

    for _,item in pairs(PlayerItems) do
        if Config.PhoneList[item.name] then
            _hasPhone = true
            break;
        end
    end

    hasPhone = _hasPhone
    exports['npwd']:setPhoneDisabled(not hasPhone)
end

local function HasPhone()
    return hasPhone
end
  
exports("HasPhone", HasPhone)

-- Handles state right when the player selects their character and location.
RegisterNetEvent('CBCore:Client:OnPlayerLoaded', function()
    DoPhoneCheck(QBCore.Functions.GetPlayerData().items)
end)

-- Resets state on logout, in case of character change.
RegisterNetEvent('CBCore:Client:OnPlayerUnload', function()
    DoPhoneCheck({})
    TriggerServerEvent("cb-npwd:server:UnloadPlayer")
end)

-- Handles state when PlayerData is changed. We're just looking for inventory updates.
RegisterNetEvent('CBCore:Player:SetPlayerData', function(PlayerData)
    DoPhoneCheck(PlayerData.items)
end)

-- Handles state if resource is restarted live.
AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource and GetResourceState('npwd') == 'started' then
        DoPhoneCheck(CBCore.Functions.GetPlayerData().items)
    end
end)

-- Allows use of phone as an item.
RegisterNetEvent('cb-npwd:client:setPhoneVisible', function(isPhoneVisible)
    exports['npwd']:setPhoneVisible(isPhoneVisible)
end)