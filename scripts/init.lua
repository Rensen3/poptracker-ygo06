-- entry point for all lua code of the pack
-- more info on the lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
ENABLE_DEBUG_LOG = true
-- get current variant
local variant = Tracker.ActiveVariantUID
-- check variant info
IS_ITEMS_ONLY = variant:find("itemsonly")

print("-- Example Tracker --")
print("Loaded variant: ", variant)
if ENABLE_DEBUG_LOG then
    print("Debug logging is enabled!")
end

-- Utility Script for helper functions etc.
ScriptHost:LoadScript("scripts/utils.lua")

-- Logic
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Custom Items
ScriptHost:LoadScript("scripts/custom_items/class.lua")
ScriptHost:LoadScript("scripts/custom_items/yugioh_card_wrapper.lua")
ScriptHost:LoadScript("scripts/custom_items/yugioh_card.lua")
ScriptHost:LoadScript("scripts/create_cards.lua")

create_cards()

-- Items
Tracker:AddItems("items/boosterpacks.jsonc")
Tracker:AddItems("items/banlists.jsonc")
Tracker:AddItems("items/campaign_opponents.jsonc")
Tracker:AddItems("items/challenges.jsonc")
-- Tracker:AddItems("items/cards.jsonc")

-- Settings
Tracker:AddItems("items/settings.jsonc")

if not IS_ITEMS_ONLY then -- <--- use variant info to optimize loading
    -- Maps
    Tracker:AddMaps("maps/maps.jsonc")
    -- Locations
    Tracker:AddLocations("locations/collect_locations.jsonc")
    Tracker:AddLocations("locations/campaign_locations.jsonc")
    Tracker:AddLocations("locations/campaign_bonuses_locations.jsonc")
    Tracker:AddLocations("locations/challenges.jsonc")
end

-- Layout
Tracker:AddLayouts("layouts/boosterpacks.jsonc")
Tracker:AddLayouts("layouts/banlists.jsonc")
Tracker:AddLayouts("layouts/campaign_opponents.jsonc")
Tracker:AddLayouts("layouts/settings.jsonc")
Tracker:AddLayouts("layouts/tracker.jsonc")
Tracker:AddLayouts("layouts/broadcast.jsonc")
-- Tracker:AddLayouts("layouts/card_collection.jsonc")
Tracker:AddLayouts("layouts/collect_cards.jsonc")

-- AutoTracking for Poptracker
if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
end
ScriptHost:LoadScript("scripts/autotracking/card_amount.lua")
ScriptHost:LoadScript("scripts/boosterpack_watcher.lua")
ScriptHost:LoadScript("scripts/goal_watcher.lua")

initialize_watch_items()
initialize_campaign_watch_items()
