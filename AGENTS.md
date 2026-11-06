# Project guidance

- Scope: this addon uses only the repository at `E:\wow\Bears_Audio_Switcher` and these test installs: `C:\Gaming\World of Warcraft\_retail_\Interface\AddOns\Bears_Audio_Switcher` and `C:\Gaming\World of Warcraft\_forever_\Interface\AddOns\Bears_Audio_Switcher`. Do not read, search, edit, or use files from any other project.
- Bears_Audio_Switcher targets retail World of Warcraft (Midnight 12.1.5+) and also supports World of Warcraft: Forever (1.60.1, interface 16001) as an optional, additional client. Neither client is required to be installed. Do not add other Classic variants.
- Keep the addon Lua 5.1 compatible. Ace libraries are declared as packager externals in `.pkgmeta`; local copies under `Libs/` are ignored by git.
- Keep the folder name, TOC filename, addon name, and SavedVariables prefix (`BearsSwitcherDB`) consistent.
- Register runtime files in `Bears_Audio_Switcher.toc` before `Options.lua`.
- Slash commands are `/bas`, `/bs`, and `/switcher`.
- Keep media asset paths consistent with `Interface\AddOns\Bears_Audio_Switcher\media\`.
- Update `README.md` and `CHANGELOG.md` when behavior changes.