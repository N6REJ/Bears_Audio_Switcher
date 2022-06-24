-- Create BearsSwitcher in wow
BearsSwitcher = LibStub("AceAddon-3.0"):NewAddon("BearsSwitcher", "AceEvent-3.0", "AceConsole-3.0")

-- Create local variable for globals incase we need them.
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

	-- https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0
	self:RegisterChatCommand("bs", "SlashCommand")
	self:RegisterChatCommand("switcher", "SlashCommand")

	-- Let them know the addon is working
	print("Bears Audio Switcher loaded.  type options type /bs")
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

-- Check for valid keypress
local f = CreateFrame("Button")
f:SetScript(
	"OnKeyDown",
	function(self, key)
		if key == BearsSwitcher.db.profile.toggle then
			-- Which speaker is active?
			local cVar = "Sound_OutputDriverIndex"
			local switch = tonumber(GetCVar(cVar))
			local spkr1 = BearsSwitcher.db.profile.spkr1 - 1
			local spkr2 = BearsSwitcher.db.profile.spkr2 - 1

			-- print("spkr1=", BearsSwitcher.db.profile.spkr1)
			-- print("spkr2=", BearsSwitcher.db.profile.spkr2)
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
			-- We need to tell them what device is being used now.
			--		print("Audio Devices changed.  Speaker ", Sound_ChatSystem_GetOutputDriverNameByIndex(current), " active")
			print("Audio Devices changed:  Speaker ", Sound_GameSystem_GetOutputDriverNameByIndex(current), " active")
		end

		self:SetPropagateKeyboardInput(true)
	end
)
