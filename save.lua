-----------------------------------------------------
-- requires https://github.com/chipsenkbeil/choose --
-- requires https://9fans.github.io.plan9port      --
-- More information:                               --
--   https://halfwit.github.io/searching.html      --
-----------------------------------------------------


-- Stash our plumb binary location
local plumb = hs.execute('which plumb', true):gsub("%s+", " ")

function save()
    -- Stash the old entry
    local old = hs.pasteboard.getContents()
    local application = hs.application.frontmostApplication()

    -- Grab the current selected text, set to pasteboard
    -- My system uses ctrl+c/ctrl+v for copy and paste
    -- Those using defaults should use the following instead
    --hs.eventtap.keyStroke({"cmd"}, "c", 0, application)
    hs.eventtap.keyStroke({"ctrl"}, "c", 0, application)
    hs.pasteboard.callbackWhenChanged(2, function(state)
        if state then
            -- Give the clipboard time to propagate
            hs.timer.doAfter(1, function()
                local line = hs.pasteboard.getContents()
                -- Assumes the plumber has matches for src is save
                hs.execute('echo ' .. line .. ' | ' .. plumb .. ' -s save -')
                -- Clear out our new clip contents
                if hs.spoons.isLoaded('TextClipboardHistory') then
                    spoon.TextClipboardHistory:clearLastItem()                
                end
                hs.pasteboard.setContents(old)
            end)
        end
    end)
end
