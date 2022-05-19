-----------------------------------------------------
-- requires https://github.com/halfwit/demun       --
-----------------------------------------------------

-- Stash command paths for future
local dctl = hs.execute('which dctl', true):gsub("%s+", " ")
local choose = hs.execute('which choose', true):gsub("%s+", " ")

-- Loop through each item in the system profiler, and add to list
local cmdin = io.popen(dctl .. ' -t exec add ', 'w')
local applist = io.popen('/usr/sbin/system_profiler SPApplicationsDataType | sed -n "s|^    \\([A-Z].*\\):|\\1|p"')
for line in applist:lines() do
  cmdin:write(line .. '\n')
end

local binlist = io.popen('/bin/zsh -c "whence -pm \'*\'"')
for line in binlist:lines() do
  cmdin:write(line .. '\n')
end

-- clean up
cmdin:flush()
cmdin:close()
binlist:close()
applist:close()

function _load()
  entries = {}
  local loader = io.popen(dctl .. ' -t exec list')
  for line in loader:lines() do
      table.insert(entries, {
          ["text"] = line,
          ["subText"] = nil,
          ["uuid"] = nil,
      })
  end

  loader:close()
  return entries
end

function _plumb(selection)
  if(selection) then
    if selection.text:sub(1, 1) == "/" then
      hs.osascript.applescript('tell app \"Terminal\" to do script \"' .. selection.text .. '\"')
    else
      hs.application.open(selection.text)
    end
  end
end

-- Set up our chooser
local chooser = hs.chooser.new(_plumb)
chooser:choices(_load)

function dmenu()
  chooser:query(nil)
  chooser:show()
end