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


-- Load the menu with all the entries we wish to view
hs.execute('echo !yt | ' .. dctl .. ' -t search add')
hs.execute('echo !g | ' .. dctl .. ' -t search add')
hs.execute('echo !s | ' .. dctl .. ' -t search add')
hs.execute('echo !w | ' .. dctl .. ' -t search add')
-- You can't escape your fate, but you can escape a command! What a nightmare.
hs.execute('/usr/bin/find ' .. os.getenv("HOME") .. WORKDIR .. ' -type f -not -path "*/node_modules*" -not -path "*/\\.git*" | /usr/bin/sed "s|/Users/halfwit/|~/|" | ' .. dctl .. ' -t search add')

function dsearch()
    hs.execute(dctl .. ' -t search list | ' .. choose .. ' -s 16 | ' .. plumb .. ' -')
end