hs.loadSpoon('TextClipboardHistory')

-- TODO: Remove need for textclipboardhistory
-- Configurations
spoon.TextClipboardHistory.show_in_menubar = false
spoon.TextClipboardHistory.frequency = 1.8
spoon.TextClipboardHistory.paste_on_select = false
spoon.TextClipboardHistory:start()

function clipmenu()
  spoon.TextClipboardHistory:showClipboard()
end