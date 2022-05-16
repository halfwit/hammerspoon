--- === WindowManagement ===
---
--- Allow window tagging/grouping for macOS
---
--- Download: [https://github.com/halfwit/hammerspoon/raw/master/Spoons/WindowManagement.spoon.zip](https://github.com/halfwit/hammerspoon/raw/master/hammerspoon/WindowManagement.spoon.zip)


local obj={}
obj.__index = obj

--- Metadata
obj.name = "WindowManagement"
obj.version = "0.1"
obj.author = "Michael Misch <michaelmisch1985@gmail.com>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local getSetting = function(label, default) return hs.settings.get(obj.name.."."..label) or default end
local setSetting = function(label, value)   hs.settings.set(obj.name.."."..label, value); return value end

--- windowManagement.groupCount
--- Variable
--- The amount of groups/tags to assign
obj.group_count = 6

--- WindowManagement.showHints
--- Variable
--- If true, populate the titlebar with group hints
obj.show_in_menubar = false

-- Internal table to track the available windows
obj._groups = {}

-- Internal table to track menubar entries
obj._menuBar = {}

obj.autoTags = {
    ["Safari"] = 2,
    ["Visual Studio Code"] = 3,
    ["Spotify"] = 4,
}

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

--- WindowManagement:toggleGroup(group)
--- Method
--- Toggle the visibility of the given group
---
--- Parameters:
---  * group - Group ID
---
--- Returns:
---  * None
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

--- WindowManagement:assignGroup(group)
--- Method
--- Add the focused window to given group
---
--- Parameters:
---  * group - the group to assign focused window to
---
--- Returns:
---  * None
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

--- WindowManagement:start()
--- Method
--- Start the window management
function obj:start()
    obj._wf = hs.window.filter.new()
    obj.logger = hs.logger.new('WM', 'debug')
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

        if event == 'windowCreated' then
            for k, v in pairs(obj.autoTags) do
                if name == k then
                    obj.logger.i('Setting ' .. name .. ' to group ' .. k)
                    table.insert(obj._groups[v].windows, incoming)
                    obj._groups[v].state = "visible"
                    obj._updateMenuBar()
                end
            end
        end
    end

    -- We don't seem to get the events in scope otherwise
    obj._wf:subscribe({
        hs.window.filter.windowDestroyed,
        hs.window.filter.windowCreated,
    }, cb)

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

function obj:stop()
    obj._wf:unsubscribeAll()
    obj._groups = {}
    if obj.show_in_menubar then
        for i = 1, obj.group_count do
            obj._menuBar[i]:delete()
        end
    end
end

return obj