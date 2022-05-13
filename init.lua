-------------------
-- configuration --
-------------------
hs.window.animationDuration = 0

-------------
-- daemons --
-------------
local demun = hs.execute('which demun', true):gsub("%s+", " ")
os.execute('/usr/bin/pkill demun')
os.execute(demun .. ' &')

--------------
-- Keybinds --
--------------

-- Close window - overrides copy
hs.hotkey.bind('leftCmd', 'c', function()
  local window = hs.window.frontmostWindow()
  window:close()
end)

-- Terminal
hs.hotkey.bind('leftCmd', 't', function()
  hs.execute('/usr/bin/open -a Terminal')
end)

require('dmenu')
hs.hotkey.bind('leftCmd', 'd', dmenu)

-- clipmenu
require('clipmenu')
hs.hotkey.bind('leftCmd', 'v', clipmenu)

-- Dsearch
require('dsearch')
hs.hotkey.bind('leftCmd', 'n', dsearch) 

-- Save
require('save')
hs.hotkey.bind('leftCmd', 's', save)