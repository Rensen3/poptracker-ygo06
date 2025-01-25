-- from: https://gist.github.com/Mysteryem/0b5fdfdafa528201b50418c0ed03c4b1
function forceUpdate()
    ---- The pack has a json-defined toggle item whose only purpose is to be toggled on/off to force logic to update.
    local update = Tracker:FindObjectForCode("update")
    update.Active = not update.Active
end

function onClearHandler(slot_data)
    print("BulkUpdate onClearHandler: "..tostring(Tracker.BulkUpdate))
    -- Pause running logic rules.
    ---- From PopTracker documentation: "bool .BulkUpdate: can be set to true from Lua to pause running logic rules."
    Tracker.BulkUpdate = true
    -- Use a protected call so that tracker updates always get enabled again, even if an error occurred.
    ---- The `pcall` function is sort of like lua's equivalent to 'try-except' in Python, it runs the function with the
    ---- specified arguments and catches any errors while the function is running. Returning `true` plus any return
    ---- values, or `false` plus the error message. https://www.lua.org/pil/8.4.html
    local ok, err = pcall(onClear, slot_data)
    -- Enable tracker updates again.
    if ok then
        -- Defer re-enabling tracker updates until the next frame, which doesn't happen until all received items/cleared
        -- locations from AP have been processed.
        ---- onItem and onLocation have not been called at all yet, but those functions can be called many times and may
        ---- change logic. For better performance, it would be ideal if the logic rules remain paused until all items and
        ---- locations are processed, which is what we will do.
        
        ---- PopTracker allows us to add FrameHandlers, functions that are called every frame.
        ---- The next frame does not occur until after all items and locations have been processed, so the next frame can
        ---- be used to unpause running logic rules.
        local handlerName = "AP onClearHandler"
        local function frameCallback()
            print("Remove frame handler")
            ---- The FrameHandler (this function) does not need to be run more than once, so the first thing it does is
            ---- remove itself from PopTracker's current FrameHandlers, so that it will not be run again on the next
            ---- frame.
            ScriptHost:RemoveOnFrameHandler(handlerName)
            ---- Unpause running logic rules so that when a user clicks on an item, logic will update as normal.
            Tracker.BulkUpdate = false
            ---- Because logic rules were paused while onClear was called and while all the items and locations were
            ---- processed, the logic needs to be updated. To do this, I have a "toggle" type JsonItem defined in the
            ---- pack and the `forceUpdate()` function toggles this item on/off (`item.Active = not item.Active`) in
            ---- order to force the logic to update.
            forceUpdate()
        end
        ---- Finally the FrameHandler is added, so will be run every frame, starting from the next frame.
        ScriptHost:AddOnFrameHandler(handlerName, frameCallback)
    else
        ---- This functions as the 'except'/'catch' block of a try-except/try-catch depending on your usual programming
        ---- language's terminology.
        ---- Running logic rules is unpaused to try to prevent the tracker from getting into a weird state where no logic
        ---- updates occur because sometimes the error that occurred could be minimal or recoverable, so it might be
        ---- better to keep the tracker mostly functioning normally rather than being completely useless because logic no
        ---- longer updates.
        Tracker.BulkUpdate = false
        ---- Standard printing to the console.
        print("Error: onClear failed:")
        print(err)
    end
end

function onNotifyLaunchHandler(key, value, old_value)
    print("BulkUpdate onNotifyLaunchHandler: "..tostring(Tracker.BulkUpdate))
    Tracker.BulkUpdate = true
    local ok, err = pcall(onNotifyLaunch, key, value, old_value)
    if ok then
        local handlerName = "AP onNotifyLaunchHandler"
        local function frameCallback()
            print("Remove frame handler")
            ScriptHost:RemoveOnFrameHandler(handlerName)
            Tracker.BulkUpdate = false
            forceUpdate()
        end
        ScriptHost:AddOnFrameHandler(handlerName, frameCallback)
    else
        Tracker.BulkUpdate = false
        print("Error: onNotifyLaunch failed:")
        print(err)
    end
end

function onNotifyHandler(key, value)
    print("BulkUpdate onNotifyHandler: "..tostring(Tracker.BulkUpdate))
    Tracker.BulkUpdate = true
    local ok, err = pcall(onNotify, key, value)
    if ok then
        local handlerName = "AP onNotifyHandler"
        local function frameCallback()
            print("Remove frame handler")
            ScriptHost:RemoveOnFrameHandler(handlerName)
            Tracker.BulkUpdate = false
            forceUpdate()
        end
        ScriptHost:AddOnFrameHandler(handlerName, frameCallback)
    else
        Tracker.BulkUpdate = false
        print("Error: onNotify failed:")
        print(err)
    end
end