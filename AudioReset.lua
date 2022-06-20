-- Addon based on Ace3 addons like Bugsack, CoolGlow, SimulationCraft and many others

local _, AudioReset = ...
AudioReset = LibStub("AceAddon-3.0"):NewAddon(AudioReset, "AudioReset", "AceConsole-3.0", "AceEvent-3.0")

---Minimap Broker inspired by countless ace3 addons like bugsack, simulationcraft, coolglow and others
AudioResetLDB = LibStub("LibDataBroker-1.1"):NewDataObject("AudioReset", {
	type = "data source",
	text = "Audio Reset",
	icon = "Interface\\Addons\\AudioReset\\media\\icon.blp",
	OnClick = function(_, button)
		if button == "LeftButton" then
			AudioOptionsFrame_AudioRestart()
		elseif button == "RightButton" then
			AudioOptionsFrame_AudioRestart()
		end
	end,
	OnTooltipShow = function(tt)
    tt:AddLine("Audio Reset")
    tt:AddLine(" ")
    tt:AddLine("Click to reset the game sound default audio device")
	tt:AddLine(" ")
	tt:AddLine("Toggle minimap button by typing |c33c9fcff/AudioReset minimap|r")
    end
})

LibDBIcon = LibStub("LibDBIcon-1.0")

-- db implemention copied from simulationcraft
function AudioReset:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("AudioResetDB", {
    profile = {
      minimap = {
        hide = false,
      },
      frame = {
        point = "CENTER",
        relativeFrame = nil,
        relativePoint = "CENTER",
        ofsx = 0,
        ofsy = 0,
        width = 750,
        height = 400,
      },
    },
  });
  LibDBIcon:Register("AudioReset", AudioResetLDB, self.db.profile.minimap)
  AudioReset:UpdateMinimapButton()
	
  AudioReset:RegisterChatCommand('AudioReset', 'HandleChatCommand')
end

-- functions copied from simulationcraft
function AudioReset:OnEnable()

end

function AudioReset:OnDisable()

end

function AudioReset:UpdateMinimapButton()
  if (self.db.profile.minimap.hide) then
    LibDBIcon:Hide("AudioReset")
  else
    LibDBIcon:Show("AudioReset")
  end
end

local function getLinks(input)
  local separatedLinks = {}
  for link in input:gmatch("|c.-|h|r") do
     separatedLinks[#separatedLinks + 1] = link
  end
  return separatedLinks
end

--- handle chat copied from simulationcraft, credits to them 
function AudioReset:HandleChatCommand(input)
  local args = {strsplit(' ', input)}
  local links = getLinks(input)
  for _, arg in ipairs(args) do
    if arg == 'minimap' then
      self.db.profile.minimap.hide = not self.db.profile.minimap.hide
      DEFAULT_CHAT_FRAME:AddMessage("Audio Reset Minimap Icon is now " .. (self.db.profile.minimap.hide and "hidden" or "shown"))
      AudioReset:UpdateMinimapButton()
      return 
    end
  end
end