BearsSwitcher = LibStub("AceAddon-3.0"):NewAddon("BearsSwitcher", "AceEvent-3.0", "AceConsole-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local speaker1, speaker2
local numDevices = Sound_GameSystem_GetNumOutputDrivers()

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
	self:RegisterChatCommand("BearsSwitcher", "SlashCommand")

	-- Get profile settings
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

function BearsSwitcher:OnEnable()
	self:RegisterEvent("CHAT_MSG_CHANNEL")
end

function BearsSwitcher:CHAT_MSG_CHANNEL(event, text, ...)
	print(event, text, ...)
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
