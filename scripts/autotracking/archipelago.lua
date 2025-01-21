-- this is an example/default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via their ids
-- it will also keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might
-- if you run into issues when touching A LOT of items/locations here, see the comment about Tracker.AllowDeferredLogicUpdate in autotracking.lua
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/card_id_mapping.lua")

CUR_INDEX = -1
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}
REMOVED_CHALLENGES = {}

-- resets an item to its initial state
function resetItem(item_code, item_type)
	local obj = Tracker:FindObjectForCode(item_code)
	if obj then
		item_type = item_type or obj.Type
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("resetItem: resetting item %s of type %s", item_code, item_type))
		end
		if item_type == "toggle" or item_type == "toggle_badged" then
			obj.Active = false
		elseif item_type == "progressive" or item_type == "progressive_toggle" then
			obj.CurrentStage = 0
			obj.Active = false
		elseif item_type == "consumable" then
			obj.AcquiredCount = 0
		elseif item_type == "custom" then
			obj:reset()
		elseif item_type == "static" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("resetItem: tried to reset static item %s", item_code))
		elseif item_type == "composite_toggle" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format(
				"resetItem: tried to reset composite_toggle item %s but composite_toggle cannot be accessed via lua." ..
				"Please use the respective left/right toggle item codes instead.", item_code))
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("resetItem: unknown item type %s for code %s", item_type, item_code))
		end
	elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("resetItem: could not find item object for code %s", item_code))
	end
end

-- advances the state of an item
function incrementItem(item_code, item_type, multiplier)
	local obj = Tracker:FindObjectForCode(item_code)
	if obj then
		item_type = item_type or obj.Type
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("incrementItem: code: %s, type %s", item_code, item_type))
		end
		if item_type == "toggle" or item_type == "toggle_badged" then
			obj.Active = true
		elseif item_type == "progressive" or item_type == "progressive_toggle" then
			if obj.Active then
				obj.CurrentStage = obj.CurrentStage + 1
			else
				obj.Active = true
			end
		elseif item_type == "consumable" then
			obj.AcquiredCount = obj.AcquiredCount + obj.Increment * multiplier
		elseif item_type == "custom" then
			-- your code for your custom lua items goes here
		elseif item_type == "static" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("incrementItem: tried to increment static item %s", item_code))
		elseif item_type == "composite_toggle" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format(
				"incrementItem: tried to increment composite_toggle item %s but composite_toggle cannot be access via lua." ..
				"Please use the respective left/right toggle item codes instead.", item_code))
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("incrementItem: unknown item type %s for code %s", item_type, item_code))
		end
	elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("incrementItem: could not find object for code %s", item_code))
	end
end

-- apply everything needed from slot_data, called from onClear
function apply_slot_data(slot_data)
	-- print(dump_table(slot_data))
	-- put any code here that slot_data should affect (toggling setting items for example)
	for key, value in pairs(slot_data) do
		if key == "final_campaign_boss_campaign_opponents" then
			Tracker:FindObjectForCode("finalcampaign").AcquiredCount = value
		elseif key == "final_campaign_boss_challenges" then
			Tracker:FindObjectForCode("finalchallenge").AcquiredCount = value
		elseif key == "fourth_tier_5_campaign_boss_campaign_opponents" then
			Tracker:FindObjectForCode("t5c4campaign").AcquiredCount = value
		elseif key == "fourth_tier_5_campaign_boss_challenges" then
			Tracker:FindObjectForCode("t5c4challenge").AcquiredCount = value
		elseif key == "third_tier_5_campaign_boss_campaign_opponents" then
			Tracker:FindObjectForCode("t5c3campaign").AcquiredCount = value
		elseif key == "third_tier_5_campaign_boss_challenges" then
			Tracker:FindObjectForCode("t5c3challenge").AcquiredCount = value
		elseif key == "number_of_challenges" then
			Tracker:FindObjectForCode("challenges").AcquiredCount = value
		elseif key == "removed challenges" then
			REMOVED_CHALLENGES = slot_data["removed challenges"]
		elseif key == "progression_cards" then
			--ScriptHost:RunScriptAsync("scripts/autotracking/progression_cards.lua", {
			--	["progression_cards"] = slot_data["progression_cards"],
			--	["progression_cards_in_start"] = slot_data["progression_cards_in_start"],
			--	["CARD_AMOUNT"] = CARD_AMOUNT,
			--	["dump_table"] = dump_table,
			--	["find_card_by_code"] = find_card_by_code,
			--	["tableHasKey"] = tableHasKey,
			--	["find_card"] = find_card
			--})
			progression_card_slot_data(slot_data)
		end
	end
end

function apply_progression_cards(slot_data, bonus, card_number, additional_key)
	local lower_bonus = bonus:lower():gsub(" ", ""):gsub("'",""):gsub(",","")
	if tableHasKey(slot_data["progression_cards"], additional_key) then
		for _, card_id in ipairs(slot_data["progression_cards"][additional_key]) do
			local card = find_card_by_code(lower_bonus..card_number)
			local item = Tracker:FindObjectForCode(lower_bonus..card_number)
			if card == nil then
				print("ERROR: not enough slots for '"..bonus.."' Index: "..card_number)
			else
				card:setCId(card_id)
				item.Name = CARD_ID[card_id]
				card_number = card_number + 1
			end
		end
	end
	return card_number
end

function progression_card_slot_data(args)
	print("Running Slot Data")
	for bonus, data in pairs(CARD_AMOUNT) do
		local card_number = 1
		local lower_bonus = bonus:lower():gsub(" ", ""):gsub("'",""):gsub(",","")
		card_number = apply_progression_cards(args, bonus, card_number, bonus)
		for _, additional_key in ipairs(data[2]) do
			card_number = apply_progression_cards(args, bonus, card_number, additional_key)
		end
		while card_number <= data[1] do
			local card = find_card_by_code(lower_bonus..card_number)
			if card == nil then
				print("ERROR: not enough slots for '"..lower_bonus.."' Index: "..card_number)
			else
				card:setCId(0)
			end
			card_number = card_number + 1
		end
		Archipelago:StatusUpdate(Archipelago.ClientStatus.PLAYING)
	end
	if tableHasKey(args, "progression_cards_in_start") then
    	for _, card_id in ipairs(args["progression_cards_in_start"]) do
        	for _, card in ipairs(find_card(card_id)) do
				card:setActive(true)
				card:addInPack("start", true)
    	   	end
		end
    end
end

-- called right after an AP slot is connected
function onClear(slot_data)
	-- use bulk update to pause logic updates until we are done resetting all items/locations
	Tracker.BulkUpdate = true	
	-- print(dump_table(slot_data))
	PLAYER_NUMBER = Archipelago.PlayerNumber or -1
	TEAM_NUMBER = Archipelago.TeamNumber or 0
	CUR_INDEX = -1
	-- reset locations
	for _, mapping_entry in pairs(LOCATION_MAPPING) do
		for _, location_table in ipairs(mapping_entry) do
			if location_table then
				local location_code = location_table[1]
				if location_code then
					if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
						print(string.format("onClear: clearing location %s", location_code))
					end
					if location_code:sub(1, 1) == "@" then
						local obj = Tracker:FindObjectForCode(location_code)
						if obj then
							obj.AvailableChestCount = obj.ChestCount
						elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
							print(string.format("onClear: could not find location object for code %s", location_code))
						end
					else
						-- reset hosted item
						local item_type = location_table[2]
						resetItem(location_code, item_type)
					end
				elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
					print(string.format("onClear: skipping location_table with no location_code"))
				end
			elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onClear: skipping empty location_table"))
			end
		end
	end
	-- reset items
	for _, mapping_entry in pairs(ITEM_MAPPING) do
		for _, item_table in ipairs(mapping_entry) do
			if item_table then
				local item_code = item_table[1]
				local item_type = item_table[2]
				if item_code then
					resetItem(item_code, item_type)
				elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
					print(string.format("onClear: skipping item_table with no item_code"))
				end
			elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onClear: skipping empty item_table"))
			end
		end
	end
	for _, card in ipairs(card_items) do
		card:reset()
	end
	apply_slot_data(slot_data)
	LOCAL_ITEMS = {}
	GLOBAL_ITEMS = {}
	COLLECTION_ID = "ygo06_collection_"..TEAM_NUMBER.."_"..PLAYER_NUMBER
	beaten_co = {}
	beaten_cha = {}
	Archipelago:SetNotify({COLLECTION_ID})
	Archipelago:Get({COLLECTION_ID})
	COLLECTED_IN_BOOSTER = slot_data["progression_cards_in_booster"]
	updateCollection({})
	Tracker.BulkUpdate = false
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
	end
	if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
		return
	end
	if index <= CUR_INDEX then
		return
	end
	local is_local = player_number == Archipelago.PlayerNumber
	CUR_INDEX = index;
	local mapping_entry = ITEM_MAPPING[item_id]
	if not mapping_entry then
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onItem: could not find item mapping for id %s", item_id))
		end
		return
	end
	for _, item_table in pairs(mapping_entry) do
		if item_table then
			local item_code = item_table[1]
			local item_type = item_table[2]
			local multiplier = item_table[3] or 1
			if item_code then
				incrementItem(item_code, item_type, multiplier)
				-- keep track which items we touch are local and which are global
				if is_local then
					if LOCAL_ITEMS[item_code] then
						LOCAL_ITEMS[item_code] = LOCAL_ITEMS[item_code] + 1
					else
						LOCAL_ITEMS[item_code] = 1
					end
				else
					if GLOBAL_ITEMS[item_code] then
						GLOBAL_ITEMS[item_code] = GLOBAL_ITEMS[item_code] + 1
					else
						GLOBAL_ITEMS[item_code] = 1
					end
				end
			elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onClear: skipping item_table with no item_code"))
			end
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onClear: skipping empty item_table"))
		end
	end
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("local items: %s", dump_table(LOCAL_ITEMS)))
		print(string.format("global items: %s", dump_table(GLOBAL_ITEMS)))
	end
	-- track local items via snes interface
	if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
		-- add snes interface functions for local item tracking here
	end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
	local value = LOCATION_MAPPING[location_id]
	if not value then
	  if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("onLocation: could not find location mapping for id %s", location_id))
	  end
	  return
	end
	for _, code in pairs(value) do
	  local object = Tracker:FindObjectForCode(code)
	  if object then
		if code:sub(1, 1) == "@" then
		  object.AvailableChestCount = object.AvailableChestCount - 1
		else
		  object.Active = true
		end
	  elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		  print(string.format("onLocation: could not find object for code %s", code))
	  end
	end
  end

function updateCollection(collection_data)
	print("Collection_Data: ")
	if type(collection_data) ~= 'table' then
		print(collection_data)
		return
	end
	print(dump_table(collection_data))
	for card_id, amount in pairs(collection_data) do
		for _, card in ipairs(find_card(tonumber(card_id))) do
			card:setActive(amount > 0)
		end
	end
end

function onNotify(key, value, old_value)
	print("onNotify "..key)
	if value ~= old_value then
		if key == COLLECTION_ID then
			updateCollection(value)
		end
	end
end

function onNotifyLaunch(key, value)
	print("onNotifyLaunch "..key)
	if key == COLLECTION_ID then
		updateCollection(value)
	end
end

-- called when a locations is scouted
function onScout(location_id, location_name, item_id, item_name, item_player)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
			item_player))
	end
	-- not implemented yet :(
end

-- called when a bounce message is received
function onBounce(json)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onBounce: %s", dump_table(json)))
	end
	-- your code goes here
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
	Archipelago:AddItemHandler("item handler", onItem)
end
if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
	Archipelago:AddLocationHandler("location handler", onLocation)
end
-- Archipelago:AddScoutHandler("scout handler", onScout)
-- Archipelago:AddBouncedHandler("bounce handler", onBounce)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)