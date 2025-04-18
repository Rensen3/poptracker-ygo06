YuGiOhCard = class(CustomItemYuGiOhCard)

function YuGiOhCard:init(name, code, Cid)
    self:createItem(name)
    self.name = name
    self.code = code
    self.Active = false
    self.state = 0
    self.loop = true
    self.Cid = Cid
    self.max_quantity = 3
    self.in_pack = {}
    self:Icon()
end

function YuGiOhCard:Icon()
    self.ItemInstance.Icon = ImageReference:FromPackRelativePath("/images/cards/c"..self.Cid..".jpg")
    if self.Active then
        self.ItemInstance.IconMods = ""
    else
        self.ItemInstance.IconMods = "@disabled"
    end
end

function YuGiOhCard:setActive(active)
    if self.Active ~= active then
        self:propertyChanged("active", active)
    end
end

function YuGiOhCard:getActive()
    return self.Active
end

function YuGiOhCard:getCId()
    return self.Cid
end

function YuGiOhCard:setCId(Cid)
    self.Cid = Cid
    self:Icon()
end

function YuGiOhCard:getInPack()
    return self.in_pack
end

function YuGiOhCard:addInPack(key, value)
    self.in_pack[key] = value
end

function YuGiOhCard:setInPack(value)
    self.in_pack = value
end

function YuGiOhCard:getName()
    return self.name
end

function YuGiOhCard:getCode()
    return self.code
end

function YuGiOhCard:onLeftClick()
    print("Invoke Leftclick on: "..self.Cid)
    print(dump_table(self.in_pack))
    Tracker.BulkUpdate = true
    for pack, content in pairs(CURRENT_BOOSTER_PACK_CONTENTS) do
        local packItem = Tracker:FindObjectForCode(pack)
        if packItem ~= nil then
            if tableContains(content, self.Cid) then
                packItem:SetOverlay("<--")
            else
                packItem:SetOverlay("")
            end
        else
            print(pack.." not found")
        end
    end
    Tracker.BulkUpdate = false
    forceUpdate()
end

function YuGiOhCard:onRightClick()
    print("Invoke Rightclick on: "..self.Cid)
    self:setActive(not self.Active)
    for _, card in ipairs(find_card(self.Cid)) do
        card:setActive(self.Active)
    end
end

function YuGiOhCard:onMiddleClick()
    print("Invoke Middleclick on: "..self.Cid)
    for _, pack in ipairs(CURRENT_BOOSTER_PACK_CONTENTS) do
        local packItem = Tracker:FindObjectForCode(pack)
        if tableContains(pack, self.Cid) then
            packItem:SetOverlay("<--")
        else
            packItem:SetOverlay("")
        end
    end
end


function YuGiOhCard:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function YuGiOhCard:providesCode(code)
    if code == self.code then
        return self.Active or self.Cid == 0
    end
    return 0
end


function YuGiOhCard:save()
    local saveData = {}
    saveData["active"] = self.Active
    saveData["Cid"] = self.Cid
    return saveData
end

function YuGiOhCard:load(data)
    if data["active"] ~= nil then
        self:propertyChanged("active",data["active"])
    end
    if data["Cid"] ~= nil then
        self:propertyChanged("Cid",data["Cid"])
    end
    return true
end

function YuGiOhCard:propertyChanged(key, value)
    -- print(string.format("Yugioh card key %s with value %s",key,value))
    if key == "active" then
        self.Active = value
        self:Icon()
    end
    if key == "CId" then
        self.Cid = value
        self.Icon()
    end
end

function YuGiOhCard:reset()
    self.in_pack = {}
    self:propertyChanged("active", false)
end
