local ox_inventory = exports.ox_inventory
local ESX = exports['es_extended']:getSharedObject()


-- Export to give a key to a player
exports('GiveKey', function(playerId, plate, modelName)
    if not playerId or not plate then return false end

    local metadata = {
        plate = plate,
        description = modelName or 'Unknown Model'
    }

    local success, response = ox_inventory:AddItem(playerId, Config.ItemName, 1, metadata)
    return success
end)

-- Export to remove a key from a player (by plate)
exports('RemoveKey', function(playerId, plate)
    if not playerId or not plate then return false end

    local success = ox_inventory:RemoveItem(playerId, Config.ItemName, 1, { plate = plate })
    return success
end)

-- Export to check if player has key (Server Side)
exports('HasKeys', function(playerId, plate)
    if not playerId or not plate then return false end

    local count = ox_inventory:Search(playerId, 'count', Config.ItemName, { plate = plate })
    return count > 0
end)

-- Command to test key giving (Admin only)
RegisterCommand('givekey', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or xPlayer.getGroup() == 'user' then return end

    local plate = args[1]
    if not plate then
        local ped = GetPlayerPed(source)
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 then
            plate = GetVehicleNumberPlateText(vehicle)
        else
            return
        end
    end

    exports['n9ne_carkyes']:GiveKey(source, plate, 'Admin Key')
end, false)
