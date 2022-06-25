local DefaultVolumeSteps = .01

-- Get listing of audio devices available and populate the "Devices" variable with those values so they can be selected.
function BearsSwitcher:GetDevices()
    -- query audio devices and populate array.
    local Devices = {}

    for index = 0, Sound_GameSystem_GetNumOutputDrivers() - 1, 1 do
        table.insert(Devices, Sound_GameSystem_GetOutputDriverNameByIndex(index))
        --print(index, Devices[#Devices])
    end
    return Devices
end

-- Set our options used in interface here
BearsSwitcher.defaults = {
    global = {
        spkr1 = {}, -- default
        sprk2 = {}, -- Banana
        toggle = GetBindingText("NUMPADMULTIPLY"), -- default keypress
        Devices = {},
        volumeUp = GetBindingText("NUMPADPLUS"),
        volumeDown = GetBindingText("NUMPADMINUS"),
        volumeSteps = .1,
        enableSound = true
    }
}

-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables
BearsSwitcher.options = {
    type = "group",
    name = "Bears Switcher",
    handler = BearsSwitcher,
    args = {
        group1 = {
            type = "group",
            order = 1,
            name = "Audio Devices",
            inline = true,
            -- getters/setters can be inherited through the table tree
            get = "GetValue",
            set = "SetValue",
            args = {
                spkr1 = {
                    type = "select",
                    order = 1,
                    name = "Speaker One",
                    style = "radio",
                    values = BearsSwitcher:GetDevices(),
                    set = function(info, value)
                        BearsSwitcher.db.global.spkr1 = value
                        -- Now that we have a value what do we do with it?
                        print(
                            "|cff00FF00Speaker 1 set to: |r|cffe3ff00 ",
                            Sound_GameSystem_GetOutputDriverNameByIndex(value - 1),
                            "|r"
                        )
                    end,
                    get = function(info)
                        return BearsSwitcher.db.global.spkr1
                    end
                },
                spkr2 = {
                    type = "select",
                    order = 2,
                    name = "Speaker Two",
                    style = "radio",
                    values = BearsSwitcher:GetDevices(),
                    set = function(info, value)
                        BearsSwitcher.db.global.spkr2 = value
                        -- Now that we have a value what do we do with it?
                        print(
                            "|cff00FF00Speaker 2 set to: |r|cffe3ff00 ",
                            Sound_GameSystem_GetOutputDriverNameByIndex(value - 1),
                            "|r"
                        )
                        -- BearsSwitcher.db.global.spkr2 = value
                    end,
                    get = function(info)
                        return BearsSwitcher.db.global.spkr2
                    end
                }
            }
        },
        group2 = {
            type = "group",
            order = 2,
            name = "Keybinds",
            inline = true,
            -- getters/setters can be inherited through the table tree
            get = "GetValue",
            set = "SetValue",
            args = {
                key = {
                    type = "keybinding",
                    order = 3,
                    name = "Toggle key",
                    desc = "Key to use to switch audio devices",
                    get = function(info)
                        return GetBindingText(BearsSwitcher.db.global.toggle)
                    end,
                    set = function(info, value)
                        BearsSwitcher.db.global.toggle = value or BearsSwitcher.db.global.toggle
                        -- Now that we have a value what do we do with it?
                        print("|cff00FF00Speaker toggle key set to: |r|cffe3ff00 ", GetBindingText(value), "|r")
                    end
                },
                volumeUp = {
                    type = "keybinding",
                    order = 4,
                    name = "Volume Up",
                    desc = "Raise master volume",
                    get = function(info)
                        return GetBindingText(BearsSwitcher.db.global.volumeUp)
                    end,
                    set = function(info, value)
                        BearsSwitcher.db.global.volumeUp = value or BearsSwitcher.db.global.volumeUp
                        -- Now that we have a value what do we do with it?
                        print("|cff00FF00Volume up key set to: |r|cffe3ff00 ", GetBindingText(value), "|r")
                    end
                },
                volumeDown = {
                    type = "keybinding",
                    order = 5,
                    name = "Volume Down",
                    desc = "lower master volume",
                    get = function(info)
                        return GetBindingText(BearsSwitcher.db.global.volumeDown)
                    end,
                    set = function(info, value)
                        BearsSwitcher.db.global.volumeDown = value or BearsSwitcher.db.global.volumeDown
                        -- Now that we have a value what do we do with it?
                        print("|cff00FF00Volume down key set to: |r|cffe3ff00 ", GetBindingText(value), "|r")
                    end
                }
            }
        },
        group3 = {
            type = "group",
            order = 3,
            name = "Controls",
            inline = true,
            -- getters/setters can be inherited through the table tree
            get = "GetValue",
            set = "SetValue",
            args = {
                volumeSteps = {
                    type = "range",
                    order = 1,
                    name = "Volume steps",
                    -- this will look for a getter/setter on our handler object
                    get = "GetVolumeSteps",
                    set = "SetVolumeSteps",
                    min = .01,
                    max = 1,
                    step = DefaultVolumeSteps
                },
                enableSound = {
                    type = "toggle",
                    order = 2,
                    name = "Beep On",
                    desc = "Beep when changing volume",
                    -- inline getter/setter example
                    get = function(info)
                        return BearsSwitcher.db.global.enableSound
                    end,
                    set = function(info, value)
                        BearsSwitcher.db.global.enableSound = value
                    end
                }
            }
        }
    }
}

-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-1
function BearsSwitcher:GetValue(info)
    return self.db.global[info[#info]]
end

function BearsSwitcher:SetValue(info, value)
    self.db.global[info[#info]] = value
end

function BearsSwitcher:GetVolumeSteps(info)
    return self.db.global.volumeStep
end

function BearsSwitcher:SetVolumeSteps(info, value)
    self.db.global.volumeStep = value
end
