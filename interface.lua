-- We need to hook this into core
BearsSwitcher = LibStub("AceBearsSwitcher-3.0"):GetBearsSwitcher("BearsSwitcher")
local L = LibStub("AceLocale-3.0"):GetLocale("BearsSwitcher")

function BearsSwitcher:CreateInterfaceOptions()
    self.defaults = {
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
    self.options = {
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
                    },
                    key = {
                        SetKey = "NUMPADPLUS",
                        GetKey = ""
                    }
                }
            }
        }
    }
    BearsSwitcher.AceConfig:RegisterOptionsTable("BearsSwitcher", self.Options)
    BearsSwitcher.AceConfigDialog:AddToBlizOptions("BearsSwitcher", "Bears Switcher")
end
