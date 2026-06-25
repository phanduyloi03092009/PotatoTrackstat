-- ============================================================
-- BLOX FRUITS ITEM CHECKER - Gửi thông tin tài khoản lên Discord
-- Copy paste toàn bộ script này vào executor và chạy
-- ============================================================

local WEBHOOK_URL = "https://discordapp.com/api/webhooks/1510042682284839032/8pRd3JMcs7DQFAdDaqzWbGgRb865UtS7iGCdmqlYZroM-DQh1i4mbKX-n2E4z94DcTqw"

-- Hàm gửi HTTP request (tương thích nhiều executor)
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
if not httpRequest then
    warn("[ItemChecker] Executor không hỗ trợ HTTP request!")
    return
end

local plr = game.Players.LocalPlayer

-- ============================================================
-- LẤY LEVEL
-- ============================================================
local function getLevel()
    local paths = {
        plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Level"),
        plr.leaderstats and plr.leaderstats:FindFirstChild("Level"),
        plr.leaderstats and plr.leaderstats:FindFirstChild("Lv"),
        plr:FindFirstChild("Level"),
    }
    for _, obj in ipairs(paths) do
        if obj then
            local val = obj.Value
            if val and tonumber(val) then return tonumber(val) end
        end
    end
    return 0
end

-- ============================================================
-- LẤY BELI
-- ============================================================
local function getBeli()
    local paths = {
        plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Beli"),
        plr.leaderstats and plr.leaderstats:FindFirstChild("Beli"),
        plr:FindFirstChild("Beli"),
    }
    for _, obj in ipairs(paths) do
        if obj then
            local val = obj.Value
            if val and tonumber(val) then return tonumber(val) end
        end
    end
    return 0
end

-- ============================================================
-- LẤY FRAGMENTS
-- ============================================================
local function getFragments()
    local paths = {
        plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Fragments"),
        plr.leaderstats and plr.leaderstats:FindFirstChild("Fragments"),
        plr:FindFirstChild("Fragments"),
    }
    for _, obj in ipairs(paths) do
        if obj then
            local val = obj.Value
            if val and tonumber(val) then return tonumber(val) end
        end
    end
    return 0
end

-- ============================================================
-- DANH SÁCH ITEM ĐÃ BIẾT
-- ============================================================
local KnownFruits = {
    "Bomb","Spike","Chop","Spring","Rocket","Spin","Flame","Ice","Sand","Dark",
    "Diamond","Light","Rubber","Barrier","Ghost","Magma","Quake","Buddha","Love",
    "Spider","Sound","Phoenix","Portal","Rumble","Paw","Gravity","Dough","Shadow",
    "Venom","Control","Spirit","Dragon","Leopard","Kitsune","T-Rex","Mammoth",
    "Gas","Blizzard","Human","Falcon","Smoke","String","Revive","Bird"
}

local KnownSwords = {
    "Cutlass","Katana","Iron Mace","Dual Katana","Triple Katana","Pipe",
    "Soul Cane","Bisento","Pole","Shark Blade","Long Sword","Saber",
    "Wando","Sandai Kitetsu","Yama","Tushita","Canvander","Twin Hooks",
    "Gravity Cane","Dark Blade","Hallow Scythe","Spikey Trident",
    "Cursed Dual Katana","True Triple Katana","Rengoku","Midnight Blade",
    "Buddy Sword","Fox Lamp","Skull Guitar","Soul Guitar","Trident",
    "Shark Anchor","Dragon Trident","Shisui","Saddi","Warden Sword"
}

local KnownGuns = {
    "Slingshot","Musket","Flintlock","Refined Flintlock","Bazooka","Cannon",
    "Kabucha","Acidum Rifle","Serpent Bow","Dragon Cannon",
    "Dual Flintlock","Super Blunderbuss","Bizarre Rifle"
}

-- ============================================================
-- QUÉT INVENTORY
-- ============================================================
local function scanItems()
    local fruits = {}
    local swords = {}
    local guns = {}
    local others = {}

    local sources = {}

    -- Character (equipped)
    local char = plr.Character
    if char then
        for _, child in pairs(char:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(sources, child.Name)
            end
        end
    end

    -- Backpack
    local bp = plr:FindFirstChildOfClass("Backpack")
    if bp then
        for _, child in pairs(bp:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(sources, child.Name)
            end
        end
    end

    for _, itemName in ipairs(sources) do
        local isFruit, isSword, isGun = false, false, false
        local lowerName = itemName:lower()

        for _, f in ipairs(KnownFruits) do
            if lowerName:find(f:lower(), 1, true) then
                isFruit = true
                break
            end
        end

        if not isFruit then
            for _, s in ipairs(KnownSwords) do
                if lowerName:find(s:lower(), 1, true) then
                    isSword = true
                    break
                end
            end
        end

        if not isFruit and not isSword then
            for _, g in ipairs(KnownGuns) do
                if lowerName:find(g:lower(), 1, true) then
                    isGun = true
                    break
                end
            end
        end

        if isFruit then
            table.insert(fruits, itemName)
        elseif isSword then
            table.insert(swords, itemName)
        elseif isGun then
            table.insert(guns, itemName)
        else
            table.insert(others, itemName)
        end
    end

    return fruits, swords, guns, others
end

-- ============================================================
-- GỬI LÊN WEBHOOK
-- ============================================================
local function sendToWebhook()
    local playerName = plr.Name
    local displayName = plr.DisplayName
    local level = getLevel()
    local beli = getBeli()
    local fragments = getFragments()
    local fruits, swords, guns, others = scanItems()

    local fruitsStr = #fruits > 0 and table.concat(fruits, "\n") or "Không có"
    local swordsStr = #swords > 0 and table.concat(swords, "\n") or "Không có"
    local gunsStr = #guns > 0 and table.concat(guns, "\n") or "Không có"
    local othersStr = #others > 0 and table.concat(others, "\n") or "Không có"

    local payload = game:GetService("HttpService"):JSONEncode({
        username = "ItemChecker Bot",
        content = "",
        embeds = {
            {
                title = "📊 Báo cáo tài khoản Blox Fruits",
                color = 3447003,
                fields = {
                    {name = "👤 Tài khoản", value = displayName .. " (@" .. playerName .. ")", inline = true},
                    {name = "⚡ Level", value = tostring(level), inline = true},
                    {name = "💰 Beli", value = tostring(beli), inline = true},
                    {name = "💎 Fragments", value = tostring(fragments), inline = true},
                    {name = "🍎 Fruits (" .. #fruits .. ")", value = fruitsStr, inline = false},
                    {name = "⚔️ Swords (" .. #swords .. ")", value = swordsStr, inline = false},
                    {name = "🔫 Guns (" .. #guns .. ")", value = gunsStr, inline = false},
                    {name = "📦 Khác (" .. #others .. ")", value = othersStr, inline = false},
                },
                footer = {
                    text = "ItemChecker | " .. os.date("%d/%m/%Y %H:%M:%S")
                }
            }
        }
    })

    local success, err = pcall(function()
        httpRequest({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payload
        })
    end)

    if success then
        print("[ItemChecker] ✅ Đã gửi thông tin tài khoản lên Discord!")
        print("[ItemChecker] Player: " .. playerName)
        print("[ItemChecker] Level: " .. level)
        print("[ItemChecker] Beli: " .. beli)
        print("[ItemChecker] Fragments: " .. fragments)
        print("[ItemChecker] Fruits: " .. #fruits)
        print("[ItemChecker] Swords: " .. #swords)
        print("[ItemChecker] Guns: " .. #guns)
    else
        warn("[ItemChecker] ❌ Lỗi gửi webhook: " .. tostring(err))
    end
end

-- ============================================================
-- CHẠY
-- ============================================================
print("[ItemChecker] Đang quét tài khoản...")
sendToWebhook()