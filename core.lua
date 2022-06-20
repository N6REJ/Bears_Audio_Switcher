-- Get libraries

-- Create variables
--------------------------

-- Create array of devices
local c = "Sound_OutputDriverIndex"
local n, m = Sound_GameSystem_GetNumOutputDrivers(), GetCVar(c)
local keybind = "breakkey"
local keystroke = false

if tonumber(m) >= n - 1 then
    m = 1
    -- Only default found
    SetCVar("Sound_OutputDriverIndex", "0")
else
    m = m + 1
end

-- Create GUI

-- Get variables from GUI

-- Set keybind ( default = pause/break )

-- Handles switching devices.
--------------------------------------

-- Watch for key stroke
if (keystroke == keybind) then
    --[ statement(s) will execute if the boolean expression is true --]
else
    --[ statement(s) will execute if the boolean expression is false --]

    -- Switch Sources
    ---------------------
    -- Print that source has switched.
    print(Sound_GameSystem_GetOutputDriverNameByIndex(m))
    SetCVar(c, m)

    -- push changes to wow
    AudioOptionsFrame_AudioRestart()
end
