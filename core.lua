BearsSwitcher = LibStub("AceAddon-3.0"):NewAddon("addon", "AceEvent-3.0", "AceConsole-3.0")
local addonName = "AdiBags"
local addon = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = addon.L

--<GLOBALS
local _G = _G
local ClearCursor = _G.ClearCursor
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local speaker1, speaker2
local numDevices = Sound_GameSystem_GetNumOutputDrivers()

addon.defaults = {
	profile = {
		spkr1 = 0, -- default
		sprk2 = 2, -- Banana
		key = "NUMPADPLUS" -- default keypress
	}
}

-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables
addon.options = {
	type = "group",
	name = "Bears Audio Switcher",
	handler = addon,
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
					SetKey = addon:SetKey(addon.key),
					GetKey = addon.key
				}
			}
		}
	}
}

-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-1
function addon:GetValue(info)
	self.db.profile[info[#info]] = self.spkr2
	print("The " .. info[#info] .. " was set to: " .. tostring(self.spkr2))
	return self.db.profile[info[#info]]
end

function addon:SetValue(info, value)
	self.db.profile[info[#info]] = value
end

function addon:OnInitialize()
	-- uses the "Default" profile instead of character-specific profiles
	-- https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
	self.db = LibStub("AceDB-3.0"):New("addonDB", self.defaults, true)

	-- registers an options table and adds it to the Blizzard options window
	-- https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0
	AC:RegisterOptionsTable("addon_Options", self.options)
	self.optionsFrame = ACD:AddToBlizOptions("addon_Options", "Bears Audio Switcher")

	-- https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0
	self:RegisterChatCommand("bs", "SlashCommand")

	-- Get profile settings
end

-- Get listing of audio devices available
function addon:FindDevices(numDevices)
	-- query audio devices and populate array.
	for index = 0, numDevices - 1, 1 do
		-- print(index, Sound_GameSystem_GetOutputDriverNameByIndex(index))
		self.db.Devices = Sound_GameSystem_GetOutputDriverNameByIndex(index)
		print(index, self.db.Devices)
	end
end

-- Get devices chosen
function addon:GetDevices()
	-- Read from profile the devices they want to use and assign them to variables.
	local x = tonumber(GetCVar("Sound_OutputDriverIndex"))
	if x == 0 then
		SetCVar("Sound_OutputDriverIndex", "3")
	else
		SetCVar("Sound_OutputDriverIndex", "0")
	end
end

-- Get keybind
function addon:SetKey(key)
	-- set the keybind here
end

function addon:SlashCommand(input, editbox)
	if input == "enable" then
		self:Enable()
		self:Print("Enabled.")
	elseif input == "disable" then
		-- unregisters all events and calls addon:OnDisable() if you defined that
		self:Disable()
		self:Print("Disabled.")
	else
		--[[ or as a standalone window
		if ACD.OpenFrames["addon_Options"] then
			ACD:Close("addon_Options")
		else
			ACD:Open("addon_Options")
		end
		]]
		-- Store choices
		addon:FindDevices(numDevices)
		-- We need to tell them what device is being used now.
		self:Print("Audio Devices changed")

		-- Make the device active.
		Sound_GameSystem_RestartSoundSystem()

		-- https://github.com/Stanzilla/WoWUIBugs/issues/89
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	end
end
