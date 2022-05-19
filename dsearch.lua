-----------------------------------------------------------------
-- requires https://github.com/chipsenkbeil/choose             --
-- requires https://gituhb.com/halfwit/demun                   --
-- requires https://9fans.github.io/plan9port                  --
-- More information:                                           --
--   https://halfwit.github.io/searching.html                  --
-----------------------------------------------------------------

----------------------------------------------------
-- *** Please set this to match your setup ****** --
-- Directory of your work, relative to your $HOME --
-- (Very large folders will be very slow)         --
----------------------------------------------------
local WORKDIR = '/Work/personal'

-- Stash command paths for future, scrub out newlines
local dctl = hs.execute('which dctl', true):gsub("%s+", " ")
local choose = hs.execute('which choose', true):gsub("%s+", " ")
local plumb = hs.execute('which plumb', true):gsub("%s+", " ")

-- Write commands to a dctl
local loader = io.popen(dctl .. ' -t search add', 'w')
local finder = io.popen('/usr/bin/find ' .. os.getenv("HOME") .. WORKDIR .. ' -type f -not -path "*/node_modules*" -not -path "*/\\.git*" | /usr/bin/sed "s|/Users/halfwit/|~/|"')
loader:write('!yt\n')
loader:write('!g\n')
loader:write('!s\n')
loader:write('!w\n')
-- Any other commands here
for line in finder:lines() do
    loader:write(line .. '\n')
end

-- Clean up
loader:flush()
loader:close()
finder:close()

function _load()
    entries = {}
    local loader = io.popen(dctl .. ' -t search list')
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

-- Run plumber eventually
function _plumb(selection)
    if(selection) then
        local runner = io.popen(plumb .. ' -', 'w')
        runner:write(selection.text)
        runner:flush()
        runner:close()
    end
end

-- Set up our chooser
local chooser = hs.chooser.new(_plumb)
chooser:choices(_load)

function dsearch()
    chooser:query(nil)
    chooser:show()
end