-- Set local
local numDevices = Sound_GameSystem_GetNumOutputDrivers()
local Devices = {}

-- Set our options used in interface here

BearsSwitcher.defaults = {
    profile = {
        spkr1 = {}, -- default
        sprk2 = {}, -- Banana
        toggle = "NUMPADPLUS" -- default keypress
    },
    global = {
        devlist = {},
        -- Make Keybind variable name Global
        toggle = {"NUMPADPLUS"}
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
            order = 3,
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
                    values = Devices -- replace with values from db
                },
                spkr2 = {
                    type = "select",
                    order = 2,
                    name = "Speaker Two",
                    values = Devices -- replace with values from db
                },
                key = {
                    type = "keybinding",
                    order = 3,
                    name = "Toggle key",
                    desc = "Key to use to switch audio devices",
                    get = function(info)
                        return BearsSwitcher.db.profile.toggle
                    end,
                    set = function(info, value)
                        BearsSwitcher.db.profile.toggle = value
                    end
                }
            }
        }
    }
}

-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-1
function BearsSwitcher:GetToggle(info)
    return self.db.profile[info[#info]]
end

function BearsSwitcher:SetToggle(info, value)
    self.db.profile[info[#info]] = value
end

-- Get listing of audio devices available and populate the "Devices" variable with those values so they can be selected.
function BearsSwitcher:FindDevices(numDevices)
    -- query audio devices and populate array.
    for index = 0, numDevices - 1, 1 do
        self.db.devices = Sound_GameSystem_GetOutputDriverNameByIndex(index)
        Devices[index] = self.db.devices
    end
end
