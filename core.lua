-- Create BearsSwitcher in wow
BearsSwitcher = LibStub("AceAddon-3.0"):NewAddon("BearsSwitcher", "AceEvent-3.0", "AceConsole-3.0")

-- Create local variable for globals incase we need them.
local _G = _G

-- Locals
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

function BearsSwitcher:OnInitialize()
	-- uses the "Default" global instead of character-specific globals
	-- https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
	self.db = LibStub("AceDB-3.0"):New("BearsSwitcherDB", self.defaults, true)

	-- registers an options table and adds it to the Blizzard options window
	-- https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0
	AC:RegisterOptionsTable("BearsSwitcher_Options", BearsSwitcher.options)
	self.optionsFrame = ACD:AddToBlizOptions("BearsSwitcher_Options", "Bears Audio Switcher")

	-- https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0
	self:RegisterChatCommand("bs", "SlashCommand")
	self:RegisterChatCommand("switcher", "SlashCommand")

	-- Let them know the addon is working
	print("|cff00FF00Bears Audio Switcher loaded.  For options type /bs|r")
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

-- Volume variables.
local SOUND_MASTERVOLUME_STEP = .1
--local SOUND_MASTERVOLUME_STEP = BearsSwitcher.db.global.volumeSteps
--local feedback = BearsSwitcher.db.global.feedback

-- VOLUME CONTROLS
local function AdjustMasterVolume(SOUND_MASTERVOLUME_STEP)
	local volume = tonumber(GetCVar("Sound_MasterVolume"))
	if (volume) then
		volume = volume + SOUND_MASTERVOLUME_STEP

		if (volume >= 1.0) then
			volume = 1.0
			if BearsSwitcher.db.global.feedback == true then
				-- Sound to let them know the valume is maxed
				PlaySoundFile("Interface\\AddOns\\Bears_Audio_Switcher\\media\\100.ogg")
			end
		elseif (volume < 0.0) then
			volume = 0.0
		end

		SetCVar("Sound_MasterVolume", volume)
	end
end

function VolumeUp()
	AdjustMasterVolume(SOUND_MASTERVOLUME_STEP)
end

function VolumeDown()
	AdjustMasterVolume(SOUND_MASTERVOLUME_STEP * -1)
end

-- Check for valid keypress
local f = CreateFrame("Button")
f:SetScript(
	"OnKeyDown",
	function(self, key)
		if key == BearsSwitcher.db.global.toggle then
			-- Check for volume up or down
			-- Which speaker is active?
			local cVar = "Sound_OutputDriverIndex"
			local switch = tonumber(GetCVar(cVar))
			local spkr1 = BearsSwitcher.db.global.spkr1 - 1
			local spkr2 = BearsSwitcher.db.global.spkr2 - 1

			-- print("spkr1=", BearsSwitcher.db.global.spkr1)
			-- print("spkr2=", BearsSwitcher.db.global.spkr2)
			-- print("switch is: ", switch)
			if switch == spkr1 then
				-- print("set spkr1 active")
				SetCVar("Sound_OutputDriverIndex", spkr2)
			else
				-- print("set spkr2 active")
				SetCVar("Sound_OutputDriverIndex", spkr1)
			end

			-- Make the device active.
			AudioOptionsFrame_AudioRestart()

			-- Find out current device so we can tell them what it is.
			cVar = "Sound_OutputDriverIndex"
			current = tonumber(GetCVar(cVar))
			print(
				"|cff00FF00Audio Devices changed:|r",
				"|cffe3ff00",
				Sound_GameSystem_GetOutputDriverNameByIndex(current),
				"|r|cff00FF00 active|r"
			)
		elseif key == BearsSwitcher.db.global.volumeUp then
			VolumeUp()
			-- Sound to let them know the button was pushed
			local volume = tonumber(GetCVar("Sound_MasterVolume"))
			if BearsSwitcher.db.global.feedback == true and volume < 1 then
				PlaySoundFile("Interface\\AddOns\\Bears_Audio_Switcher\\media\\volumeUp.ogg")
			end
		elseif key == BearsSwitcher.db.global.volumeDown then
			VolumeDown()
			-- Sound to let them know the button was pushed
			local volume = tonumber(GetCVar("Sound_MasterVolume"))
			if BearsSwitcher.db.global.feedback == true and volume >= .01 then
				PlaySoundFile("Interface\\AddOns\\Bears_Audio_Switcher\\media\\volumeDown.ogg")
			end
		end

		-- ok, pass the key thru
		self:SetPropagateKeyboardInput(true)
	end
)
