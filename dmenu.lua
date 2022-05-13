-----------------------------------------------------
-- requires https://github.com/chipsenkbeil/choose --
-- requires https://github.com/halfwit/demun       --
-----------------------------------------------------

-- Stash command paths for future
local dctl = hs.execute('which dctl', true):gsub("%s+", " ")
local choose = hs.execute('which choose', true):gsub("%s+", " ")

-- Write entries to demun for exec tag
hs.execute('whence -pm \'*\' | dctl -t exec add', true)

-- Add hotkey binding to start dmenu
function dmenu()
  local result = hs.execute(dctl .. ' -t exec list | ' .. choose .. ' -s 16')
  if (string.len(result) >= 1) then
    hs.osascript.applescript('tell app \"Terminal\" to do script \"' .. result .. '\"')
  end
end