BearsSwitcher = LibStub("AceAddon-3.0"):NewAddon("BearsSwitcher", "AceEvent-3.0", "AceConsole-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

function BearsSwitcher:OnInitialize()
	-- uses the "Default" profile instead of character-specific profiles
	-- https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
	self.db = LibStub("AceDB-3.0"):New("BearsSwitcherDB", self.defaults, true)

	-- registers an options table and adds it to the Blizzard options window
	-- https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0
	AC:RegisterOptionsTable("BearsSwitcher_Options", self.options)
	self.optionsFrame = ACD:AddToBlizOptions("BearsSwitcher_Options", "BearsSwitcher (label 1)")

	-- adds a child options table, in this case our profiles panel
	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	AC:RegisterOptionsTable("BearsSwitcher_Profiles", profiles)
	ACD:AddToBlizOptions("BearsSwitcher_Profiles", "Profiles", "BearsSwitcher (label 1)")

	-- https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0
	self:RegisterChatCommand("bs", "SlashCommand")
	self:RegisterChatCommand("BearsSwitcher", "SlashCommand")

	self:GetCharacterInfo()
end

function BearsSwitcher:OnEnable()
	self:RegisterEvent("CHAT_MSG_CHANNEL")
end

function BearsSwitcher:PLAYER_STARTED_MOVING(event)
	print(event)
end

function BearsSwitcher:CHAT_MSG_CHANNEL(event, text, ...)
	print(event, text, ...)
end

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
	elseif input == "message" then
		print("this is our saved message:", self.db.profile.someInput)
	else
		--[[ or as a standalone window
		if ACD.OpenFrames["BearsSwitcher_Options"] then
			ACD:Close("BearsSwitcher_Options")
		else
			ACD:Open("BearsSwitcher_Options")
		end
		]]
		self:Print("Some useful help message.")
		-- https://github.com/Stanzilla/WoWUIBugs/issues/89
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	end
end
