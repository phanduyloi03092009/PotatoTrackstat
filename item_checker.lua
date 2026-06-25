-- ============================================================
-- ITEM CHECKER MODULE - Blox Fruits
-- ============================================================

local ItemChecker = {}

-- ============================================================
-- CATEGORIES
-- ============================================================
ItemChecker.Categories = {
    Fruits = {
        "Bomb-Bomb","Spike-Spike","Chop-Chop","Spring-Spring","Rocket-Rocket",
        "Spin-Spin","Fire-Fire","Quake-Quake","Human-Human","Buddha-Buddha",
        "Spider-Spider","Sound-Sound","Phoenix-Phoenix","Portal-Portal",
        "Rumble-Rumble","Magma-Magma","Light-Light","Dark-Dark","Shadow-Shadow",
        "Venom-Venom","Control-Control","Dragon-Dragon","Leopard-Leopard",
        "Mammoth-Mammoth","T-Rex-T-Rex","Dough-Dough","Kitsune-Kitsune",
        "Gas-Gas","Ice-Ice","Blizzard-Blizzard","Gravity-Gravity","Love-Love",
        "Rubber-Rubber","Bird: Phoenix","Kilo-Kilo","Smoke-Smoke","Diamond-Diamond",
        "Revive-Revive","Ghost-Ghost","Barrier-Barrier","Flame-Flame","Falcon-Falcon",
        "String-String","Paw-Paw"
    },
    Swords = {
        "Cutlass","Katana","Iron Mace","Dual Katana","Triple Katana","Pipe",
        "Soul Cane","Bisento","Pole 1st Form","Pole 2nd Form","Shark Blade",
        "Long Sword","Saber","Wando","Sandai Kitetsu","Yama","Tushita",
        "Canvander","Twin Hooks","Gravity Cane","Dark Blade","Dark Blade V2",
        "Dark Blade V3","Hallow Scythe","Spikey Trident","Cursed Dual Katana",
        "True Triple Katana","Rengoku","Midnight Blade","Buddy Sword","Fox Lamp",
        "Skull Guitar","Soul Guitar","Trident","Shark Anchor","Dragon Trident"
    },
    Guns = {
        "Slingshot","Musket","Flintlock","Refined Flintlock","Bazooka","Cannon",
        "Kabucha","Acidum Rifle","Serpent Bow","Dark Fragment","Dragon Cannon",
        "Dual Flintlock","Super Blunderbuss"
    },
    Accessories = {
        "Black Cape","Swordsman Hat","Pink Coat","Tomoe Ring","Leather Cap",
        "Marine Cap","Kernel Glasses","Choppa Hat","Gentleman Top Hat",
        "Swan Glasses","Pilot Helmet","Valkyrie Helm","Pale Scarf","Bandanna",
        "Warrior Helmet","Royal Helmet","Dragon Helm"
    },
    FightingStyles = {
        "Combat","Black Leg","Electro","Fishman Karate","Dragon Claw",
        "Superhuman","Death Step","Sharkman Karate","Electric Claw","Godhuman",
        "Sanguine Art"
    },
    Materials = {
        -- Common drops
        "Leather","Scrap Metal","Magma Ore","Dragon Scale","Fish Tail",
        "Shark Tooth","Electric Wing","Mystic Droplet","Fool's Gold",
        "Gunpowder","Meteor Ore","Uranium","Rainbow Essence",
        -- Rare drops
        "Dark Fragment","Conjured Cocoa","Vampire Fang","Elf Hat",
        "Demonic Wisp","Horns of God","Bones","Relic",
        "Saber Essence","Fist of Darkness",
        -- Sea beast drops
        "Mutant Tooth","Slayer Skin","Dark Eternal Shard",
        -- Flower / alchemy
        "Flower","God's Chalice",
        -- Misc craft
        "Egg","Cannonball","Chest","Gold","Money","Robux",
        "Microchip","Spider Web","Diable Jambe","Beast Hunter"
    },
}

-- ============================================================
-- LEVEL
-- ============================================================
function ItemChecker.GetLevel()
    local ok, level = pcall(function()
        local plr = game.Players.LocalPlayer
        -- Check common level stat paths in Blox Fruits
        local paths = {
            plr.leaderstats and plr.leaderstats:FindFirstChild("Level"),
            plr:FindFirstChild("Level"),
            plr:FindFirstChild("Data") and plr:FindFirstChild("Data"):FindFirstChild("Level"),
            plr.leaderstats and plr.leaderstats:FindFirstChild("Lv"),
        }
        for _, obj in ipairs(paths) do
            if obj and obj.Value then return obj.Value end
        end
        return 0
    end)
    if ok then
        print("[ItemChecker] Level: " .. tostring(level))
        return level
    end
    print("[ItemChecker] Could not read level")
    return 0
end

-- ============================================================
-- INVENTORY
-- ============================================================
function ItemChecker.CategorizeItem(name)
    for cat, items in pairs(ItemChecker.Categories) do
        for _, v in ipairs(items) do
            if v == name then return cat end
        end
    end
    return "Unknown"
end

function ItemChecker.ScanAll()
    local all = {}
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if char then
        for _, t in pairs(char:GetChildren()) do
            if t:IsA("Tool") then
                table.insert(all, {
                    Name = t.Name,
                    Category = ItemChecker.CategorizeItem(t.Name),
                    Source = "Equipped"
                })
            end
        end
    end
    local bp = plr:FindFirstChildOfClass("Backpack")
    if bp then
        for _, t in pairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                table.insert(all, {
                    Name = t.Name,
                    Category = ItemChecker.CategorizeItem(t.Name),
                    Source = "Backpack"
                })
            end
        end
    end
    return all
end

function ItemChecker.PrintInventory()
    local items = ItemChecker.ScanAll()
    print("\n========== INVENTORY ==========")
    print("Level: " .. tostring(ItemChecker.GetLevel()))
    print("Total: " .. #items .. " items")
    local cats = {}
    for _, item in ipairs(items) do
        if not cats[item.Category] then cats[item.Category] = {} end
        table.insert(cats[item.Category], item)
    end
    for cat, list in pairs(cats) do
        print("  [" .. cat .. "]")
        for _, i in ipairs(list) do
            print("    - " .. i.Name .. " (" .. i.Source .. ")")
        end
    end
    print("================================")
    return items
end

-- ============================================================
-- HAS
-- ============================================================
function ItemChecker.HasItem(search)
    local items = ItemChecker.ScanAll()
    search = search:lower()
    local found = {}
    for _, item in ipairs(items) do
        if item.Name:lower():find(search, 1, true) then
            table.insert(found, item)
        end
    end
    if #found > 0 then
        print("[Has] FOUND: " .. search)
        for _, i in ipairs(found) do
            print("  + " .. i.Name .. " [" .. i.Category .. "] (" .. i.Source .. ")")
        end
    else
        print("[Has] NOT FOUND: " .. search)
    end
    return #found > 0, found
end

function ItemChecker.HasFruit(name)
    local items = ItemChecker.ScanAll()
    name = name:lower()
    for _, i in ipairs(items) do
        if i.Category == "Fruits" and i.Name:lower():find(name, 1, true) then
            print("[Has] Fruit: " .. i.Name)
            return true, i
        end
    end
    print("[Has] Fruit not found: " .. name)
    return false, nil
end

function ItemChecker.HasSword(name)
    local items = ItemChecker.ScanAll()
    name = name:lower()
    for _, i in ipairs(items) do
        if i.Category == "Swords" and i.Name:lower():find(name, 1, true) then
            print("[Has] Sword: " .. i.Name)
            return true, i
        end
    end
    print("[Has] Sword not found: " .. name)
    return false, nil
end

-- Check if ALL items in a list are owned
function ItemChecker.HasAll(list)
    local missing = {}
    for _, name in ipairs(list) do
        local ok = ItemChecker.HasItem(name)
        if not ok then table.insert(missing, name) end
    end
    if #missing == 0 then
        print("[Has] All items present")
        return true, {}
    else
        print("[Has] Missing " .. #missing .. " items:")
        for _, n in ipairs(missing) do print("  - " .. n) end
        return false, missing
    end
end

-- ============================================================
-- MATERIALS
-- ============================================================
function ItemChecker.ScanMaterials()
    local items = ItemChecker.ScanAll()
    local mats = {}
    for _, i in ipairs(items) do
        if i.Category == "Materials" then
            table.insert(mats, i)
        end
    end
    return mats
end

function ItemChecker.ListMaterials()
    local mats = ItemChecker.ScanMaterials()
    print("\n=== MATERIALS ===")
    if #mats == 0 then
        print("  No materials found")
    else
        for idx, m in ipairs(mats) do
            print("  " .. idx .. ". " .. m.Name .. " (" .. m.Source .. ")")
        end
    end
    print("  Total: " .. #mats)
    print("=================")
    return mats
end

function ItemChecker.HasMaterial(name)
    local mats = ItemChecker.ScanMaterials()
    name = name:lower()
    for _, m in ipairs(mats) do
        if m.Name:lower():find(name, 1, true) then
            print("[Materials] FOUND: " .. m.Name)
            return true, m
        end
    end
    print("[Materials] NOT FOUND: " .. name)
    return false, nil
end

-- Check materials required for a craft recipe
function ItemChecker.CheckRecipe(recipeName, required)
    print("\n[Recipe] Checking: " .. recipeName)
    local missing = {}
    for _, mat in ipairs(required) do
        local ok = ItemChecker.HasMaterial(mat)
        if not ok then table.insert(missing, mat) end
    end
    if #missing == 0 then
        print("[Recipe] READY to craft: " .. recipeName)
        return true, {}
    else
        print("[Recipe] MISSING for " .. recipeName .. ":")
        for _, n in ipairs(missing) do print("  - " .. n) end
        return false, missing
    end
end

-- Built-in recipes for common Blox Fruits upgrades
ItemChecker.Recipes = {
    Superhuman = {"Leather","Scrap Metal","Fish Tail","Magma Ore","Electric Wing"},
    Godhuman = {"Fish Tail","Mystic Droplet","Magma Ore","Electric Wing","Dragon Scale"},
    SanguineArt = {"Demon Horns","Demonic Wisp","Dragon Scale","Vampire Fang","Elf Hat"},
    TrueTripleKatana = {"Saber","Triple Katana","Dual Katana"},
    CursedDualKatana = {"Dark Blade","Triple Katana","Fist of Darkness"},
    Tushita = {"Leather","Magma Ore","Fish Tail","Fool's Gold","Mystic Droplet"},
    Yama = {"Leather","Scrap Metal","Dragon Scale","Demonic Wisp"},
    SoulGuitar = {"Leather","Scrap Metal","Microchip","Conjured Cocoa","Demonic Wisp"},
    HallowScythe = {"Bones","Relic","Leather"},
}

function ItemChecker.CheckAllRecipes()
    print("\n======= RECIPE STATUS =======")
    for name, mats in pairs(ItemChecker.Recipes) do
        local ok, miss = ItemChecker.CheckRecipe(name, mats)
        if ok then
            print("  [READY] " .. name)
        else
            print("  [MISS " .. #miss .. "] " .. name)
        end
    end
    print("==============================")
end

-- ============================================================
-- RARE ITEMS CHECK
-- ============================================================
function ItemChecker.CheckRareItems()
    local items = ItemChecker.ScanAll()
    local rare = {
        "Dark Blade","Cursed Dual Katana","True Triple Katana","Hallow Scythe",
        "Soul Guitar","Yama","Tushita","Rengoku","Dragon-Dragon","Leopard-Leopard",
        "Dough-Dough","Kitsune-Kitsune","Venom-Venom","Control-Control",
        "Buddha-Buddha","Phoenix-Phoenix","Superhuman","Godhuman","Sanguine Art",
        "Shark Anchor","Fox Lamp"
    }
    local found, miss = {}, {}
    for _, r in ipairs(rare) do
        local ok = false
        for _, i in ipairs(items) do
            if i.Name:lower() == r:lower() then
                table.insert(found, i) ok = true break
            end
        end
        if not ok then table.insert(miss, r) end
    end
    print("\n=== RARE ITEMS ===")
    print("OWNED: " .. #found)
    for _, i in ipairs(found) do print("  + " .. i.Name) end
    print("MISSING: " .. #miss)
    for _, n in ipairs(miss) do print("  - " .. n) end
    print("==================")
end

-- ============================================================
-- MONITOR
-- ============================================================
function ItemChecker.MonitorItems(interval)
    interval = interval or 3
    _G.ItemMonitorEnabled = true
    local prev = {}
    for _, i in ipairs(ItemChecker.ScanAll()) do prev[i.Name] = true end
    print("[Monitor] Started (every " .. interval .. "s)")
    spawn(function()
        while _G.ItemMonitorEnabled do
            task.wait(interval)
            for _, i in ipairs(ItemChecker.ScanAll()) do
                if not prev[i.Name] then
                    print("[Monitor] NEW ITEM: " .. i.Name .. " [" .. i.Category .. "]")
                    prev[i.Name] = true
                end
            end
        end
        print("[Monitor] Stopped")
    end)
end

-- ============================================================
-- QUICK SUMMARY
-- ============================================================
function ItemChecker.GetStats()
    local plr = game.Players.LocalPlayer
    local stats = {
        PlayerName = plr.Name,
        Level = ItemChecker.GetLevel(),
        Beli = (plr.leaderstats and plr.leaderstats:FindFirstChild("Beli") and plr.leaderstats.Beli.Value) or 0,
        Fragments = (plr.leaderstats and plr.leaderstats:FindFirstChild("Fragments") and plr.leaderstats.Fragments.Value) or 0,
        Fruits = {},
        Swords = {},
        Guns = {}
    }
    local items = ItemChecker.ScanAll()
    for _, i in ipairs(items) do
        if i.Category == "Fruits" then
            table.insert(stats.Fruits, i.Name)
        elseif i.Category == "Swords" then
            table.insert(stats.Swords, i.Name)
        elseif i.Category == "Guns" then
            table.insert(stats.Guns, i.Name)
        end
    end
    return stats
end

function ItemChecker.Summary()
    local s = ItemChecker.GetStats()
    print("\n====== SUMMARY ======")
    print("Level    : " .. s.Level)
    print("Beli     : " .. s.Beli)
    print("Frags    : " .. s.Fragments)
    print("Fruits   : " .. #s.Fruits)
    for _, f in ipairs(s.Fruits) do print("  - " .. f) end
    print("=====================")
end

-- Expose global
_G.ItemChecker = ItemChecker

-- Auto Initialize / Run on Load
pcall(function()
    print("[ItemChecker] Loading module...")
    ItemChecker.Summary()
    ItemChecker.CheckAllRecipes()
end)

return ItemChecker
