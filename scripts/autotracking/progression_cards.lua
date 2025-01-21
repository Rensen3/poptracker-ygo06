function dump_table(o, depth)
    return arg:dump_table(o ,depth)
end

function find_card_by_code(code)
    return arg:find_card_by_code(code)
end

function tableHasKey(table, element)
    return arg:tableHasKey(table, element)
end

function find_card(cid)
    return arg:find_card(cid)
end

CARD_AMOUNT = arg["CARD_AMOUNT"]
progression_cards_in_start = arg["progression_cards_in_start"]
progression_cards = arg["progression_cards"]

function apply_progression_cards(bonus, card_number, additional_key)
	local lower_bonus = bonus:lower():gsub(" ", ""):gsub("'","")
	if tableHasKey(rogression_cards, additional_key) then
		for _, card_id in ipairs(progression_cards[additional_key]) do
			local card = find_card_by_code(lower_bonus..card_number)
			--local item = Tracker:FindObjectForCode(lower_bonus..card_number)
			if card == nil then
				print("ERROR: not enough slots for '"..bonus.."' Index: "..card_number)
			else
				card:setCId(card_id)
				--item.Name = CARD_ID[card_id]
				card_number = card_number + 1
			end
		end
	end
	return card_number
end

print(arg["dump_table"](arg))
for bonus, data in pairs(CARD_AMOUNT) do
    local card_number = 1
    local lower_bonus = bonus:lower():gsub(" ", ""):gsub("'",""):gsub(",","")
    card_number = apply_progression_cards(bonus, card_number, bonus)
    for _, additional_key in ipairs(data[2]) do
        card_number = apply_progression_cards(bonus, card_number, additional_key)
    end
    while card_number <= data[1] do
        local card = find_card_by_code(lower_bonus..card_number)
        if card == nil then
            print("ERROR: not enough slots for '"..bonus.."' Index: "..card_number)
        else
            card:setCId(0)
        end
        card_number = card_number + 1
    end
end
if progression_cards_in_start ~= nil then
    for _, card_id in ipairs(progression_cards_in_start) do
        for _, card in ipairs(find_card(card_id)) do
            card:setActive(true)
            card:addInPack("start", true)
        end
    end
end