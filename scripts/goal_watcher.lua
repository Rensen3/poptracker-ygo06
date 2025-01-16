CAMPAIGN_OPPONENTS = {
    "campaigntier1column1",
    "campaigntier1column2",
    "campaigntier1column3",
    "campaigntier1column4",
    "campaigntier1column5",
    "campaigntier2column1",
    "campaigntier2column2",
    "campaigntier2column3",
    "campaigntier2column4",
    "campaigntier2column5",
    "campaigntier3column1",
    "campaigntier3column2",
    "campaigntier3column3",
    "campaigntier3column4",
    "campaigntier3column5",
    "campaigntier4column1",
    "campaigntier4column2",
    "campaigntier4column3",
    "campaigntier4column4",
    "campaigntier4column5",
    "campaigntier5column1",
    "campaigntier5column2",
    "campaigntier5column3",
    "campaigntier5column4",
    "campaigntier5column5",
    "t5c3campaign",
    "t5c4campaign",
    "finalcampaign"
}

beaten_co = {

}

function initialize_campaign_watch_items()
    for _, co in ipairs(CAMPAIGN_OPPONENTS) do
      ScriptHost:AddWatchForCode(co, co, watch_co)
    end
end

function watch_co(co)
    if co ~= "finalcampaign" and co ~="t5c4campaign" and co ~= "t5c3campaign" then
        local item = Tracker:FindObjectForCode(co)
        local wasBeaten = tableContains(beaten_co, co)
        if wasBeaten and not item.Active then
            removeFromArray(beaten_co, co)
        elseif not wasBeaten and item.Active then
            table.insert(beaten_co, co)
        end
    end
    local column3 = Tracker:ProviderCountForCode("t5c3campaign")
    local column4 = Tracker:ProviderCountForCode("t5c4campaign")
    local final = Tracker:ProviderCountForCode("finalcampaign")
    local itemCol3 = Tracker:FindObjectForCode("campaigntier5column3")
    local itemCol4 = Tracker:FindObjectForCode("campaigntier5column4")
    local itemFinal = Tracker:FindObjectForCode("campaigntier5column5")
    local co_beaten = #beaten_co

    itemCol3.Active = column3 <= co_beaten - bool_to_number[itemCol3.Active]
    itemCol4.Active = column4 <= co_beaten - bool_to_number[itemCol4.Active]
    itemFinal.Active = final <= co_beaten - bool_to_number[itemFinal.Active]

end

