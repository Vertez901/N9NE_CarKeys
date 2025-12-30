local ESX = exports['es_extended']:getSharedObject()

local function Trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

---@diagnostic disable: undefined-global
local function PlayAnimation()
    if not Config.Animation then return end
    lib.requestAnimDict(Config.Animation.dict)
    TaskPlayAnim(cache.ped, Config.Animation.dict, Config.Animation.anim, 8.0, 8.0, Config.Animation.duration, 48, 0,
        false, false, false)
end

local function ToggleVehicleLock()
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords, 5.0, true)

    if not vehicle then
        return lib.notify({ type = 'error', description = Config.Notify.not_close })
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    local trimmedPlate = Trim(plate)

    -- Check for key in inventory
    local count = exports.ox_inventory:Search('count', Config.ItemName, { plate = trimmedPlate })

    if count > 0 then
        PlayAnimation()

        -- Toggle lock
        local lockStatus = GetVehicleDoorLockStatus(vehicle)
        local newStatus = (lockStatus == 1 or lockStatus == 0) and 2 or 1

        SetVehicleDoorsLocked(vehicle, newStatus)

        -- Play sound/Prop/Lights
        SetVehicleLights(vehicle, 2)
        Wait(200)
        SetVehicleLights(vehicle, 0)
        Wait(200)
        SetVehicleLights(vehicle, 2)
        Wait(200)
        SetVehicleLights(vehicle, 0)

        if newStatus == 2 then
            lib.notify({ type = 'success', description = Config.Notify.locked })
        else
            lib.notify({ type = 'success', description = Config.Notify.unlocked })
        end
    else
        lib.notify({ type = 'error', description = Config.Notify.no_keys })
    end
end

lib.addKeybind({
    name = 'toggle_lock',
    description = Config.KeybindDescription,
    defaultKey = Config.Keybind,
    onPressed = ToggleVehicleLock
})

local HotwiredVehicles = {}

local function HasKeys(plate)
    local trimmedPlate = Trim(plate)
    local count = exports.ox_inventory:Search('count', Config.ItemName, { plate = trimmedPlate })
    return count > 0
end

local function HotwireVehicle(vehicle, plate)
    if HotwiredVehicles[plate] then
        lib.notify({ type = 'info', description = 'Vehicle is already hotwired' })
        SetVehicleEngineOn(vehicle, true, true, false)
        return
    end

    if lib.progressBar({
            duration = Config.Hotwire.time,
            label = 'Searching for wires...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true
            },
            anim = {
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                clip = 'machinic_loop_mechandplayer'
            }
        }) then
        local success = lib.skillCheck(Config.Hotwire.difficulty, Config.Hotwire.inputs)

        if success then
            HotwiredVehicles[plate] = true
            SetVehicleEngineOn(vehicle, true, true, false)
            lib.notify({ type = 'success', description = 'Engine hotwired!' })
        else
            lib.notify({ type = 'error', description = 'Hotwire failed' })
            -- Trigger alarm logic here if needed
            SetVehicleAlarm(vehicle, true)
            SetVehicleAlarmTimeLeft(vehicle, 30000)
        end
    else
        lib.notify({ type = 'info', description = 'Canceled' })
    end
end

local function ToggleEngine()
    local vehicle = cache.vehicle
    if not vehicle or cache.seat ~= -1 then return end

    local plate = GetVehicleNumberPlateText(vehicle)

    if HasKeys(plate) or HotwiredVehicles[plate] then
        local engineStatus = GetIsVehicleEngineRunning(vehicle)
        SetVehicleEngineOn(vehicle, not engineStatus, false, true)

        if not engineStatus then
            lib.notify({ type = 'success', description = 'Engine started' })
        else
            lib.notify({ type = 'info', description = 'Engine stopped' })
        end
    else
        -- Start Hotwire
        HotwireVehicle(vehicle, plate)
    end
end

lib.addKeybind({
    name = 'toggle_engine',
    description = Config.EngineKeybindDescription,
    defaultKey = Config.EngineKeybind,
    onPressed = ToggleEngine
})

-- Prevent auto-start and handle entry
lib.onCache('vehicle', function(value)
    if value then
        SetVehicleNeedsToBeHotwired(value, false) -- Disable GTA default hotwire

        -- Optional: Wait a moment for GTA to try auto-start then kill it if no keys
        -- But for better UX, we let it run if it was ALREADY running.
        -- If it was off, keep it off.

        if GetIsVehicleEngineRunning(value) then
            -- If engine is running, we leave it be?
            -- Or do we check if player has keys?
            -- Usually if engine is running, it stays running until turned off.
        else
            SetVehicleEngineOn(value, false, true, true)
        end
    end
end)
