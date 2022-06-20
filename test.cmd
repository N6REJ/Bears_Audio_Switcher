{
    "label": "FindGlobals",
    "type": "shell",
    "command": "C:\\Path\\To\\lua-wow\\luac-wow.exe -p -l '${file}' | C:\\Path\\To\\lua-wow\\lua-wow.exe 'C:\\Path\\To\\globals.lua' '${file}'",
    "group": {
        "kind": "build",
        "isDefault": true
    }
 }
