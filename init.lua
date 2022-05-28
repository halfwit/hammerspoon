-------------------
-- configuration --
-------------------
hs.window.animationDuration = 0

--------------
-- Keybinds --
--------------
-- Close window
hs.hotkey.bind('leftCmd', 'w', function()
  local window = hs.window.frontmostWindow()
  window:close()
end)

-- Window management
require('wm')
hs.hotkey.bind('leftCmd', 'l', hs.window.filter.focusEast)
hs.hotkey.bind('leftCmd', 'h', hs.window.filter.focusWest)
hs.hotkey.bind('leftCmd', 'j', hs.window.filter.focusSouth)
hs.hotkey.bind('leftCmd', 'k', hs.window.filter.focusNorth)
hs.hotkey.bind('leftCmd shift', 'l', increaseWindow, nil, increaseWindow)
hs.hotkey.bind('leftCmd shift', 'h', decreaseWindow, nil, decreaseWindow)

for i = 1, 5 do
  key = tostring(i)
  hs.hotkey.bind('leftCmd', key, function()
    toggleGroup(i)
  end)
  hs.hotkey.bind('lefctCmd shift', key, function()
    assignGroup(i)
  end)
end

-- Terminal
hs.hotkey.bind('leftCmd', 't', function()
  hs.application.open("Terminal")
end)

-- Launchers/Plumbers
require('dmenu')
hs.hotkey.bind('leftCmd', 'd', dmenu)
hs.hotkey.bind('leftCmd shift', 'd', reload_dmenu)

require('dsearch')
hs.hotkey.bind('leftCmd', 'n', dsearch)
hs.hotkey.bind('leftCmd shift', 'n', reload_dsearch)

require('save')
hs.hotkey.bind('leftCmd', 's', save)
hs.hotkey.bind('leftCmd', 'p', plumb)
