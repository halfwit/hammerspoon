-- Stash windows in a table, refer to table to show/hide windows
-- Window filter watches for creation/deletion, to keep our windows object correct

local obj={}
obj.__index = obj

-- Metadata
obj.name = "WindowManagement"
obj.version = "0.1"

local getSetting = function(label, default) return hs.settings.get(obj.name.."."..label) or default end
local setSetting = function(label, value)   hs.settings.set(obj.name.."."..label, value); return value end

-- windowManagement.groupCount
-- Variable
-- The amount of groups/tags to assign
obj.group_count = 6

-- WindowManagement.showHints
-- Variable
-- If true, populate the titlebar with group hints
obj.show_in_menubar = false

-- Internal table to track the available windows
obj._groups = {}

-- Internal table to track menubar entries
obj._menuBar = {}

local _groupEmptyText = hs.styledtext.new("⊖", { 
    size = 16
})

local _groupHiddenText = hs.styledtext.new("⌽", {
    size = 16
})

local _groupVisibleText = hs.styledtext.new("◉", {
    size = 16
})

function obj:_updateMenuBar()
    if not obj.show_in_menubar then
        return
    end

    for i, menu in ipairs(obj._menuBar) do
        if #obj._groups[i].windows < 1 then
            menu:setTitle(_groupEmptyText)
        elseif obj._groups[i].state == "hidden" then
            menu:setTitle(_groupHiddenText)
        else
            menu:setTitle(_groupVisibleText)
        end
    end
end

-- WindowManagement:toggleGroup(group)
-- Method
-- Toggle the visibility of the given group
--
-- Parameters:
--  * group - Group ID
--
-- Returns:
--  * None
function obj:toggleGroup(group)
    -- Toggle the state of the given group
    if obj._groups[group].state == "visible" then
        obj._groups[group].state = "hidden"
        for i, win in ipairs(obj._groups[group].windows) do
            win:minimize()
        end
    else
        obj._groups[group].state = "visible"
        for i, win in ipairs(obj._groups[group].windows) do
            win:unminimize()
        end
    end
    obj._updateMenuBar()
end

-- WindowManagement:assignGroup(group)
-- Method
-- Add the focused window to given group
--
-- Parameters:
--  * group - the group to assign focused window to
--
-- Returns:
--  * None
function obj:assignGroup(group)
    window = hs.window.frontmostWindow()
    
    -- Check if window exists in other groups and remove
    for i, group in ipairs(obj._groups) do
        for j, win in ipairs(group.windows) do
            if win:id() == window:id() then
                table.remove(obj._groups[i].windows, j)
            end
        end
    end

    table.insert(obj._groups[group].windows, window)
    -- Subsequent toggles will hide the new window, and not bring up any others in group
    -- this is expected behaviour
    obj._groups[group].state = "visible"
    obj._updateMenuBar()
end

-- WindowManagement:start()
-- Method
-- Start the window management
function obj:start()
    obj._wf = hs.window.filter.new()
    local cb = function(incoming, name, event)
        if event == 'windowDestroyed' then
            for i, group in ipairs(obj._groups) do
                for j, win in ipairs(group.windows) do
                    if win:id() == incoming:id() then
                        table.remove(obj._groups[i].windows, j)
                        obj._updateMenuBar()
                    end
                end
            end
        end
    end

    -- We don't seem to get the events in scope otherwise
    obj._wf:subscribe(hs.window.filter.windowDestroyed, cb)

    -- Initialize the groups table that we update
    for i = 1, obj.group_count do
        table.insert(obj._groups, i, {
            state="hidden",
            windows={},
        })
        if obj.show_in_menubar then
            obj._menuBar[obj.group_count + 1 - i] = hs.menubar.new()
        end
    end
    obj._updateMenuBar()
end

return obj