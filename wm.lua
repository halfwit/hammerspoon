hs.loadSpoon('WindowManagement')

spoon.WindowManagement.group_count = 5
spoon.WindowManagement.show_in_menubar = true
spoon.WindowManagement.autoTags = {
    ["Messages"] = 5,
    ["Element"] = 5,
    ["Mail"] = 4,
    ["Safari"] = 2,
    ["Google Chrome"] = 2,
    ["Code"] = 3,
    ["Spotify"] = 4,
    ["Terminal"] = 1,
    ["Kindle"] = 4,
}
spoon.WindowManagement:start()

function toggleGroup(gid)
    spoon.WindowManagement:toggleGroup(gid)
end

function assignGroup(gid)
    spoon.WindowManagement:assignGroup(gid)
end

function increaseWindow()
    local window = hs.window.frontmostWindow()
    local size = window:size()
    size.w = size.w + 10
    window:setSize(size)
end

function decreaseWindow()
    local window = hs.window.frontmostWindow()
    local size = window:size()
    size.w = size.w - 10
    window:setSize(size)
end
