YuGiOhCard = class(CustomItemYuGiOhCard)

function YuGiOhCard:init(name, code, Cid)
    self:createItem(name)
    self.code = code
    self.Active = false
    self.state = 0
    self.loop = true
    self.Cid = Cid
    self.AcquiredCount = 0
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

function YuGiOhCard:increment()
    local target = self.AcquiredCount + 1
    if target > self.max_quantity then
        target = 0
    end
    self:changeAcquiredCount(target)
end

function YuGiOhCard:decrement()
    local target = self.AcquiredCount - 1
    if target < 0 then
        target = self.max_quantity
    end
    self:changeAcquiredCount(target)
end

function YuGiOhCard:setActive(active)
    self:setProperty("active",active)
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

function YuGiOhCard:changeAcquiredCount(count)
    self:setProperty("AcquiredCount", count)
end

function YuGiOhCard:onLeftClick()
    if not self.Active then
        self:setActive(true)
        for _, card in ipairs(find_card(self.Cid)) do
            card:setActive(true)
        end
    else
        self:increment()
    end
end

function YuGiOhCard:onRightClick()
    self:setActive(not self.Active)
    for _, card in ipairs(find_card(self.Cid)) do
        card:setActive(self.Active)
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
    saveData["AcquiredCount"] = self.AcquiredCount
    return saveData
end

function YuGiOhCard:load(data)
    if data["active"] ~= nil then
        self:setProperty("active",data["active"])
    end
    if data["AcquiredCount"] ~= nil then
        self:setProperty("AcquiredCount",data["AcquiredCount"])
    end
    return true
end

function YuGiOhCard:propertyChanged(key, value)
    print(string.format("Yugioh card key %s with value %s",key,value))
    if key == "active" then
        self.Active = value
        self:Icon()
    end
    if key == "AcquiredCount" then
        self.AcquiredCount = value
    end
    if key == "CId" then
        self.Cid = value
        self.Icon()
    end
end

function YuGiOhCard:reset()
    self:propertyChanged("active", false)
    self:propertyChanged("AcquiredCount", 0)
    self.in_pack = {}
end
