hs.loadSpoon('WindowManagement')

spoon.WindowManagement.group_count = 6
spoon.WindowManagement.show_in_menubar = true
spoon.WindowManagement:start()

function toggleGroup(gid)
    spoon.WindowManagement:toggleGroup(gid)
end

function assignGroup(gid)
    spoon.WindowManagement:assignGroup(gid)
end
