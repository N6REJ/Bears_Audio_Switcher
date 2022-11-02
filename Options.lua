-- Bears Audio Switcher - Database
-- Created by N6REJ character is Bearesquishy - dalaran please credit whenever.
-- Source on GitHub: https://n6rej.github.io
---@type
---

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
    profile = {
        spkr1 = {}, -- default
        spkr2 = {}, -- normally headset
        toggle = GetBindingText("NUMPADMULTIPLY"), -- default keypress
        Devices = {},
        volumeUp = GetBindingText("NUMPADPLUS"),
        volumeDown = GetBindingText("NUMPADMINUS"),
        volumeSteps = 1,
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
                        BearsSwitcher.db.profile.spkr1 = value
                        -- Now that we have a value what do we do with it?
                        print(
                            "|cff00FF00Speaker 1 set to: |r|cffe3ff00 ",
                            Sound_GameSystem_GetOutputDriverNameByIndex(value - 1),
                            "|r"
                        )
                    end,
                    get = function(info)
                        return BearsSwitcher.db.profile.spkr1
                    end
                },
                spkr2 = {
                    type = "select",
                    order = 2,
                    name = "Speaker Two",
                    style = "radio",
                    values = BearsSwitcher:GetDevices(),
                    set = function(info, value)
                        BearsSwitcher.db.profile.spkr2 = value
                        -- Now that we have a value what do we do with it?
                        print(
                            "|cff00FF00Speaker 2 set to: |r|cffe3ff00 ",
                            Sound_GameSystem_GetOutputDriverNameByIndex(value - 1),
                            "|r"
                        )
                        -- BearsSwitcher.db.profile.spkr2 = value
                    end,
                    get = function(info)
                        return BearsSwitcher.db.profile.spkr2
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
                        return GetBindingText(BearsSwitcher.db.profile.toggle)
                    end,
                    set = function(info, value)
                        BearsSwitcher.db.profile.toggle = value or BearsSwitcher.db.profile.toggle
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
                        return GetBindingText(BearsSwitcher.db.profile.volumeUp)
                    end,
                    set = function(info, value)
                        BearsSwitcher.db.profile.volumeUp = value or BearsSwitcher.db.profile.volumeUp
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
                        return GetBindingText(BearsSwitcher.db.profile.volumeDown)
                    end,
                    set = function(info, value)
                        BearsSwitcher.db.profile.volumeDown = value or BearsSwitcher.db.profile.volumeDown
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
                    min = 0,
                    max = 100,
                    step = 10
                },
                enableSound = {
                    type = "toggle",
                    order = 2,
                    name = "Sound On",
                    desc = "Sound notification when changing volume",
                    -- inline getter/setter example
                    get = function(info)
                        return BearsSwitcher.db.profile.enableSound
                    end,
                    set = function(info, value)
                        BearsSwitcher.db.profile.enableSound = value
                    end
                }
            }
        }
    }
}

-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-1
function BearsSwitcher:GetValue(info)
    return self.db.profile[info[#info]]
end

function BearsSwitcher:SetValue(info, value)
    self.db.profile[info[#info]] = value
end

function BearsSwitcher:GetVolumeSteps(info)
    return self.db.profile.volumeSteps
end

function BearsSwitcher:SetVolumeSteps(info, value)
    self.db.profile.volumeSteps = value
end
