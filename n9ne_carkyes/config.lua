Config = {}

Config.Debug = false

-- Keybind settings
Config.Keybind = 'U'
Config.KeybindDescription = 'Zamknij/otworz pojazd'

-- Animation settings
Config.Animation = {
    dict = 'anim@mp_player_intmenu@key_fob@',
    anim = 'fob_click',
    duration = 1000
}

-- Notification settings
Config.Notify = {
    locked = 'Pojazd zamknięty',
    unlocked = 'Pojazd otwarty',
    no_keys = 'Nie masz kluczy do tego pojazdu',
    not_close = 'Brak pojazdu w pobliżu'
}

-- Item name in ox_inventory
Config.ItemName = 'carkey'

-- Engine Toggle settings
Config.EngineKeybind = 'Y'
Config.EngineKeybindDescription = 'Uruchom/Zgas silnik'

-- Hotwire settings
Config.Hotwire = {
    time = 5000,                       -- Time to find wires in ms
    difficulty = { 'easy', 'medium' }, -- ox_lib skill check difficulty
    inputs = { 'w', 'a', 's', 'd' },   -- ox_lib skill check keys
    chance = 50                        -- 50% chance to alert police (placeholder for future)
}
