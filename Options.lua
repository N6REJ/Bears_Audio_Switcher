-- Set our options used in interface here

BearsSwitcher.defaults = {
    profile = {
        spkr1 = 0, -- default
        sprk2 = 2, -- Banana
        key = "NUMPADPLUS" -- default keypress
    },
    global = {
        devlist = {},
        -- Make Keybind variable name Global
        key = {"NUMPADPLUS"}
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
                    order = 3,
                    name = "Speaker One",
                    values = {"Apple", "Banana", "Strawberry"} -- replace with values from db
                },
                spkr2 = {
                    type = "select",
                    order = 3,
                    name = "Speaker Two",
                    values = {"one"} -- replace with values from db
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
