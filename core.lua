-- Create BearsSwitcher in wow
BearsSwitcher = LibStub("AceBearsSwitcher-3.0"):NewBearsSwitcher("BearsSwitcher", "AceEvent-3.0", "AceConsole-3.0")

-- Locals
local BearsSwitcherName = "AdiBags"
local BearsSwitcher = LibStub("AceBearsSwitcher-3.0"):GetBearsSwitcher(BearsSwitcherName)
local L = BearsSwitcher.L

--<GLOBALS
local _G = _G
local ClearCursor = _G.ClearCursor
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local speaker1, speaker2
local numDevices = Sound_GameSystem_GetNumOutputDrivers()

-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables#title-4-1
function BearsSwitcher:GetValue(info)
	self.db.profile[info[#info]] = self.spkr2
	print("The " .. info[#info] .. " was set to: " .. tostring(self.spkr2))
	return self.db.profile[info[#info]]
end

function BearsSwitcher:SetValue(info, value)
	self.db.profile[info[#info]] = value
end

function BearsSwitcher:OnInitialize()
	-- uses the "Default" profile instead of character-specific profiles
	-- https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
	self.db = LibStub("AceDB-3.0"):New("BearsSwitcherDB", self.defaults, true)

	-- registers an options table and adds it to the Blizzard options window
	-- https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0
	AC:RegisterOptionsTable("BearsSwitcher_Options", self.options)
	self.optionsFrame = ACD:AddToBlizOptions("BearsSwitcher_Options", "Bears Audio Switcher")

	-- https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0
	self:RegisterChatCommand("bs", "SlashCommand")

	-- Get profile settings
	if self.db ~= nil then
		self:CreateInterfaceOptions()
	end
end

-- Get listing of audio devices available
function BearsSwitcher:FindDevices(numDevices)
	-- query audio devices and populate array.
	for index = 0, numDevices - 1, 1 do
		-- print(index, Sound_GameSystem_GetOutputDriverNameByIndex(index))
		self.db.Devices = Sound_GameSystem_GetOutputDriverNameByIndex(index)
		print(index, self.db.Devices)
	end
end

-- Get devices chosen
function BearsSwitcher:GetDevices()
	-- Read from profile the devices they want to use and assign them to variables.
	local x = tonumber(GetCVar("Sound_OutputDriverIndex"))
	if x == 0 then
		SetCVar("Sound_OutputDriverIndex", "3")
	else
		SetCVar("Sound_OutputDriverIndex", "0")
	end
end

-- Get keybind
function BearsSwitcher:SetKey(key)
	-- set the keybind here
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
		-- Store choices
		BearsSwitcher:FindDevices(numDevices)
		-- We need to tell them what device is being used now.
		self:Print("Audio Devices changed")

		-- Make the device active.
		Sound_GameSystem_RestartSoundSystem()

		-- https://github.com/Stanzilla/WoWUIBugs/issues/89
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	end
end
