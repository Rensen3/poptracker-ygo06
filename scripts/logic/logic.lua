-- put logic functions here using the Lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
-- don't be afraid to use custom logic functions. it will make many things a lot easier to maintain, for example by adding logging.
-- to see how this function gets called, check: locations/locations.json
-- example:
function has_more_then_n_consumable(n)
    local count = Tracker:ProviderCountForCode('consumable')
    local val = (count > tonumber(n))
    if ENABLE_DEBUG_LOG then
        print(string.format("called has_more_then_n_consumable: count: %s, n: %s, val: %s", count, n, val))
    end
    if val then
        return 1 -- 1 => access is in logic
    end
    return 0 -- 0 => no access
end

function card_rule(code)
    local card = find_card_by_code(code)
    if card ~= nil then
        for pack, pack_active in pairs(card:getInPack()) do
            local packItem = Tracker:FindObjectForCode(pack)
            if pack_active or (packItem ~=nil and packItem.Active) then
                return 1
            end
        end
    end
    return 0
end

function has_at_least_n_tier_t_beaten(t, n)
    local i = 5
    local beaten = 0
    while i > 0 do
        local item = Tracker:FindObjectForCode("campaigntier"..t.."column"..i)
        if item ~= nil and item.Active then 
            beaten = beaten + 1
        end
        i = i - 1
    end
    if beaten >= tonumber(n) then
        return 1
    end
    return 0
end

function has_at_least_n_beaten(n)
    local beaten = 0
    local t = 5
    while t > 0 do
        local i = 5
        while i > 0 do
            local item = Tracker:FindObjectForCode("campaigntier"..t.."column"..i)
            if item ~= nil and item.Active then 
                beaten = beaten + 1
            end
            i = i - 1
        end
        t = t - 1
    end
    if beaten >= tonumber(n) then
        return 1
    end
    return 0
end

function card_visibility(cardcode)
    return find_card_by_code(cardcode):getCId() ~= 0
end

challenge_alias = {
    ["TD37 Uria Lord of Searing Flames"] = "TD37 Uria, Lord of Searing Flames",
    ["TD38 Hamon Lord of Striking Thunder"] = "TD38 Hamon, Lord of Striking Thunder",
    ["TD39 Raviel Lord of Phantasms"] = "TD39 Raviel, Lord of Phantasms"
}

function challenge_visibility(challenge)
    if tableContains(challenge_alias, challenge) then
        challenge = challenge_alias[challenge]
    end
    return not tableContains(REMOVED_CHALLENGES, challenge)
end

function difficulty_level(level)
    level = tonumber(level)
    return level >= Difficulty_Beaters and level >= Difficulty_Monster_Removal and level >= Difficulty_Backrow_Removal
end