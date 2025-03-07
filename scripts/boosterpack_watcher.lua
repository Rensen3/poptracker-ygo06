ScriptHost:LoadScript("scripts/booster_pack_contents.lua")
 
 boosterpacks = {
  "legendofb.e.w.d.",
  "metalraiders",
  "pharaoh'sservant",
  "pharaonicguardian",
  "spellruler",
  "labyrinthofnightmare",
  "legacyofdarkness",
  "magician'sforce",
  "darkcrisis",
  "invasionofchaos",
  "ancientsanctuary",
  "souloftheduelist",
  "riseofdestiny",
  "flamingeternity",
  "thelostmillenium",
  "cyberneticrevolution",
  "elementalenergy",
  "shadowofinfinity",
  "gamegiftcollection",
  "specialgiftcollection",
  "fairycollection",
  "dragoncollection",
  "warriorcollectiona",
  "warriorcollectionb",
  "fiendcollectiona",
  "fiendcollectionb",
  "machinecollectiona",
  "machinecollectionb",
  "spellcastercollectiona",
  "spellcastercollectionb",
  "zombiecollection",
  "specialmonstersa",
  "specialmonstersb",
  "reversecollection",
  "lprecoverycollection",
  "specialsummoncollectiona",
  "specialsummoncollectionb",
  "specialsummoncollectionc",
  "equipmentcollection",
  "continuousspell/trapa",
  "continuousspell/trapb",
  "quick/countercollection",
  "directdamagecollection",
  "directattackcollection",
  "monsterdestroycollection"
 }

 booster_last_status = {}


 function initialize_watch_items()
  for _, pack in ipairs(boosterpacks) do
    ScriptHost:AddWatchForCode(pack, pack, watch_pack2)
  end
end

function watch_pack(code)
  local active = Tracker:FindObjectForCode(code).Active
  local card = find_card(1384) --finalcountdown
  card:setActive(active)
end

function watch_pack2(code)
  local active = Tracker:FindObjectForCode(code).Active
  if booster_last_status[code] == nil or booster_last_status[code] ~= active then
    booster_last_status[code] = active
  else
    return
  end
  if CURRENT_BOOSTERE_PACK_CONTENTS[code] ~= nil then
    for _, content_card in ipairs(CURRENT_BOOSTERE_PACK_CONTENTS[code]) do
      local cards = find_card(content_card)
      if cards ~= nil then
        for _, card in ipairs(cards) do
          card:addInPack(code, active)
        end
      end
    end
  end
end