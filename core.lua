-- Get libraries


-- Create variables
--------------------------

-- Create array of devices
local c = "Sound_OutputDriverIndex";
local n, m= Sound_GameSystem_GetNumOutputDrivers(), GetCVar(c);
if tonumber(m)>=n-1 then m = 1
else
    m = m+1
end;

-- Create GUI


-- Get variables from GUI


-- Set keybind ( default = pause/break )




-- Handles switching devices.


-- Watch for key stroke



-- Switch Sources
print(Sound_GameSystem_GetOutputDriverNameByIndex(m));
SetCVar(c, m); AudioOptionsFrame_AudioRestart()

-- Print that source has switched.
