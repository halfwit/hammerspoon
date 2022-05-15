-----------------------------------------------------
-- requires https://github.com/chipsenkbeil/choose --
-- requires https://github.com/halfwit/demun       --
-----------------------------------------------------

-- Stash command paths for future
local dctl = hs.execute('which dctl', true):gsub("%s+", " ")
local choose = hs.execute('which choose', true):gsub("%s+", " ")

-- Write entries to demun for exec tag
hs.execute('whence -pm \'*\' | dctl -t exec add', true)

-- Loop through each item in the system profiler, and add to list
local applist = io.popen('/usr/sbin/system_profiler SPApplicationsDataType | sed -n "s|^    \\([A-Z].*\\):|\\1|p"')
local cmdin = io.popen(dctl .. ' -t exec add ', 'w')

for line in applist:lines() do
  cmdin:write(line .. '\n')
end

-- clean up
applist:close()
cmdin:close()

-- Add hotkey binding to start dmenu
function dmenu()
  local result = hs.execute(dctl .. ' -t exec list | ' .. choose .. ' -s 16')
  if (string.len(result) >= 1) then
    -- If the first char is a path, open in term else open in open
    if result:sub(1, 1) == "/" then
      hs.osascript.applescript('tell app \"Terminal\" to do script \"' .. result .. '\"')
    else
      hs.application.open(result)
    end
  end
end
