-- List of globals for Mikk's FindGlobals script.
--
-- WoW API functions:
-- GLOBALS: GetCVar, SetCVar, Sound_GameSystem_GetNumOutputDrivers, Sound_GameSystem_GetOutputDriverNameByIndex, Sound_GameSystem_RestartSoundSystem
--
-- UIDropDownMenu functions:
-- GLOBALS: ToggleDropDownMenu, UIDropDownMenu_AddButton, UIDropDownMenu_CreateInfo, UIDropDownMenu_GetSelectedValue, UIDropDownMenu_Initialize, UIDropDownMenu_SetSelectedValue, UIDropDownMenu_SetWidth

local CVAR = "Sound_OutputDriverIndex"

local tonumber = tonumber

local function GetDriverIndex()
	return tonumber(GetCVar(CVAR))
end

local function SetDriverIndex(index)
	SetCVar(CVAR, index)
	Sound_GameSystem_RestartSoundSystem()
end

--------------
-- DropDown --
--------------

local DropDown = CreateFrame("Frame", "Broker_AudioHardware_DropDown", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_SetWidth(DropDown, 136)

local function DropDownButton_OnClick(self)
	local selectedDriverIndex = self.value
	if selectedDriverIndex ~= GetDriverIndex() then
		UIDropDownMenu_SetSelectedValue(DropDown, selectedDriverIndex)
		SetDriverIndex(selectedDriverIndex) -- The call to SetCVar automatically updates the data object's text
	end
end

-- Adapted from AudioOptionsSoundPanelHardwareDropDown_Initialize in FrameXML\AudioOptionsPanels.lua
local function DropDown_Init(self)
	local selectedDriverIndex = UIDropDownMenu_GetSelectedValue(self)
	local numDrivers = Sound_GameSystem_GetNumOutputDrivers()
	local info = UIDropDownMenu_CreateInfo()
	
	for driverIndex = 0, numDrivers - 1 do
		info.text = Sound_GameSystem_GetOutputDriverNameByIndex(driverIndex)
		info.value = driverIndex
		info.checked = selectedDriverIndex and driverIndex == selectedDriverIndex		
		info.func = DropDownButton_OnClick

		UIDropDownMenu_AddButton(info)
	end
end

UIDropDownMenu_Initialize(DropDown, DropDown_Init, "MENU")

-----------------
-- Data Object --
-----------------

local DataObj = LibStub("LibDataBroker-1.1"):NewDataObject("Broker_AudioHardware", {
	type = "data source",
	text = Sound_GameSystem_GetOutputDriverNameByIndex(GetDriverIndex()),
	icon = [[Interface\ICONS\INV_Gizmo_GoblinBoomBox_01]]
})

function DataObj:OnClick()
	UIDropDownMenu_SetSelectedValue(DropDown, GetDriverIndex())
	ToggleDropDownMenu(nil, nil, DropDown, self, 0, -5)
end

-- This hook won't for AddOns loaded before this one that create a local reference to SetCVar,
-- but there probably aren't many that create a local reference AND change the value of the "Sound_OutputDriverIndex" CVar.
--
-- Using the CVAR_UPDATE event won't work, because the Blizzard audio options menu doesn't pass a third argument to SetCVar to trigger the event
-- and any AddOn that does could pass anything it wanted, making it nearly impossible to detect which CVar is being changed.
hooksecurefunc("SetCVar", function(cvar, value, scriptArg)
	if cvar == CVAR then
		DataObj.text = Sound_GameSystem_GetOutputDriverNameByIndex(value)
	end
end)