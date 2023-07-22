-- Bears Audio Switcher - Database
-- Created by N6REJ character is Bearesquishy - dalaran please credit whenever.
-- Source on GitHub: https://n6rej.github.io
---
---@class ns

-- Create BearsSwitcher in wow
BearsSwitcher = LibStub("AceAddon-3.0"):NewAddon("BearsSwitcher", "AceEvent-3.0", "AceConsole-3.0")

-- Create local variable for profiles incase we need them.
local _G = _G

-- Locals
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

function BearsSwitcher:OnInitialize()
    -- uses the "Default" profile instead of character-specific profiles
    -- https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
    self.db = LibStub("AceDB-3.0"):New("BearsSwitcherDB", self.defaults, true)

    -- registers an options table and adds it to the Blizzard options window
    -- https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0
    AC:RegisterOptionsTable("BearsSwitcher_Options", BearsSwitcher.options)
    self.optionsFrame = ACD:AddToBlizOptions("BearsSwitcher_Options", "Bears Audio Switcher")

    -- adds a child options table, in this case our profiles panel
    local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    AC:RegisterOptionsTable("BearsSwitcher_Profiles", profiles)
    ACD:AddToBlizOptions("BearsSwitcher_Profiles", "Profiles", "Bears Audio Switcher")

    -- https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0
    self:RegisterChatCommand("bs", "SlashCommand")
    self:RegisterChatCommand("switcher", "SlashCommand")

    -- We need to set some defaults to use if they've not set things up before.
    local defaults = {
        volumeUp = GetBindingText("NUMPADPLUS"),
        volumeDown = GetBindingText("NUMPADMINUS"),
        volumeSteps = 1,
        toggle = GetBindingText("NUMPADMULTIPLY"),
        music_toggle = GetBindingText("NUMPADDIVIDE"),
        enableSound = true
    }

    for key, value in pairs(defaults) do
        if BearsSwitcher.db.profile[key] == nil then
            BearsSwitcher.db.profile[key] = value
        end
    end

    -- Let them know the addon is working
    print("|cff00FF00Bears Audio Switcher loaded.  For options type /bs|r")
end

-- Let them use profiles
function BearsSwitcher:GetCharacterInfo()
    -- stores character-specific data
    self.db.char.level = UnitLevel("player")
end

function BearsSwitcher:SlashCommand(input, editbox)
    if input == "enable" then
        self:Enable()
        self:Print("Enabled.")
    elseif input == "disable" then
        -- unregisters all events and calls BearsSwitcher:OnDisable() if you defined that
        self:Disable()
        self:Print("Disabled.")
    else
        --[[ or as a standalone window
        if ACD.OpenFrames["BearsSwitcher_Options"] then
            ACD:Close("BearsSwitcher_Options")
        else
            ACD:Open("BearsSwitcher_Options")
        end
        ]]
        -- https://github.com/Stanzilla/WoWUIBugs/issues/89
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    end
end

-- VOLUME CONTROLS
local function AdjustMasterVolume(SOUND_MASTERVOLUME_STEP)
    -- Set volume to 1-100
    SOUND_MASTERVOLUME_STEP = SOUND_MASTERVOLUME_STEP / 100

    -- Get current volume level from 1 - 100
    local volume = tonumber(GetCVar("Sound_MasterVolume"))

    if (volume) then
        volume = volume + SOUND_MASTERVOLUME_STEP

        if (volume >= 1.0) then
            volume = 1.0
            if BearsSwitcher.db.profile.enableSound == true then
                -- Sound to let them know the volume is maxed
                PlaySoundFile("Interface\\AddOns\\Bears_Audio_Switcher\\media\\100.ogg")
            end
        elseif (volume <= 0.0) then
            volume = 0.0
        end

        SetCVar("Sound_MasterVolume", volume)
    end
end

function VolumeUp()
    AdjustMasterVolume(BearsSwitcher.db.profile.volumeSteps)
end

function VolumeDown()
    AdjustMasterVolume(-BearsSwitcher.db.profile.volumeSteps)
end

-- Check for valid keypress
local f = CreateFrame("Button")
f:SetScript(
        "OnKeyDown",
        function(self, key)
            if key == BearsSwitcher.db.profile.toggle then
                -- Check for volume up or down
                -- Which speaker is active?
                local cVar = "Sound_OutputDriverIndex"
                local switch = tonumber(GetCVar(cVar))
                local current
                local spkr1 = BearsSwitcher.db.profile.spkr1 - 1
                local spkr2 = BearsSwitcher.db.profile.spkr2 - 1

                -- print("spkr1=", BearsSwitcher.db.profile.spkr1)
                -- print("spkr2=", BearsSwitcher.db.profile.spkr2)
                -- print("switch is: ", switch)
                if switch == spkr1 then
                    -- print("set spkr1 active")
                    SetCVar("Sound_OutputDriverIndex", tostring(spkr2))
                else
                    -- print("set spkr2 active")
                    SetCVar("Sound_OutputDriverIndex", tostring(spkr1))
                end

                -- Make the device active.
                Sound_GameSystem_RestartSoundSystem()

                -- Find out current device so we can tell them what it is.
                cVar = "Sound_OutputDriverIndex"
                current = tonumber(GetCVar(cVar))
                print(
                        "|cff00FF00Audio Devices changed:|r",
                        "|cffe3ff00",
                        Sound_GameSystem_GetOutputDriverNameByIndex(current),
                        "|r|cff00FF00 active|r"
                )
            elseif key == BearsSwitcher.db.profile.volumeUp then
                VolumeUp()
                -- Sound to let them know the button was pushed
                local volume = tonumber(GetCVar("Sound_MasterVolume"))
                if BearsSwitcher.db.profile.enableSound == true and volume < 1 then
                    PlaySoundFile("Interface\\AddOns\\Bears_Audio_Switcher\\media\\volumeUp.ogg")
                end
            elseif key == BearsSwitcher.db.profile.volumeDown then
                VolumeDown()
                -- Sound to let them know the button was pushed
                local volume = tonumber(GetCVar("Sound_MasterVolume"))
                if BearsSwitcher.db.profile.enableSound == true and volume >= .01 then
                    PlaySoundFile("Interface\\AddOns\\Bears_Audio_Switcher\\media\\volumeDown.ogg")
                end
            elseif key == BearsSwitcher.db.profile.music_toggle then
                -- Check for current state of music toggle.
                Sound_ToggleMusic()
            end

            -- ok, pass the key thru
            self:SetPropagateKeyboardInput(true)
        end
)

-- Addon compartment usage
function BearsAudioSwitcher_OnAddonCompartmentClick(addonName, buttonName, editbox)
    BearsSwitcher:SlashCommand("/bs", editbox)
end
