-------------------
-- configuration --
-------------------
hs.window.animationDuration = 0.1

-------------
-- daemons --
-------------
--local demun = hs.execute('which demun', true):gsub("%s+", " ")
--os.execute('/usr/bin/pkill demun')
--os.execute(demun .. ' &')

--------------
-- Keybinds --
--------------

-- Close window - overrides copy
hs.hotkey.bind('leftCmd', 'c', function()
  local window = hs.window.frontmostWindow()
  window:close()
end)

-- Window management
require('wm')
hs.hotkey.bind('leftCmd', 'l', hs.window.filter.focusEast)
hs.hotkey.bind('leftCmd', 'h', hs.window.filter.focusWest)
hs.hotkey.bind('leftCmd', 'j', hs.window.filter.focusSouth)
hs.hotkey.bind('leftCmd', 'k', hs.window.filter.focusNorth)
for i = 1, 6 do
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
  hs.execute('/usr/bin/open -a Terminal')
end)

--require('dmenu')
--hs.hotkey.bind('leftCmd', 'd', dmenu)

-- clipmenu
--require('clipmenu')
--hs.hotkey.bind('leftCmd', 'v', clipmenu)

-- Dsearch
--require('dsearch')
--hs.hotkey.bind('leftCmd', 'n', dsearch) 

-- Save
--require('save')
--hs.hotkey.bind('leftCmd', 's', save)