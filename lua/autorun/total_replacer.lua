

CreateConVar("tr_enable", 1, FCVAR_ARCHIVE,"Enable Total Entity Replacer?", 0, 1 )

local entityList = { -- Список с энтити для генерации консольных команд
    "item_healthkit",
    "item_healthvial",
    "item_battery",
    "item_ammo_smg1_grenade",
    -- Добавьте другие строки
}

local weaponList = { -- Список с энтити для генерации консольных команд
    "weapon_357",
    "weapon_pistol",
    "weapon_bugbait",
    "weapon_crossbow",
    "weapon_crowbar",
    "weapon_frag",
    "weapon_physcannon",
    "weapon_ar2",
    "weapon_rpg",
    "weapon_slam",
    "weapon_shotgun",
    "weapon_smg1",
    "weapon_stunstick",
    -- Добавьте другие строки
}
local vehicleList = {
    "Airboat",
    "Jeep",
    "Pod",
}

local npcList = {
    "npc_crow",
    "npc_pigeon",
    "npc_seagull",
    "npc_metropolice",
}



for _, str in pairs(entityList) do -- Создает консольные команды для ограничения спавна энтити
    CreateConVar("tr_"..str, 1, FCVAR_ARCHIVE,"Enable replacer for"..str, 0, 1 )
end

for _, str in pairs(weaponList) do -- Создает консольные команды для ограничения спавна энтити
    CreateConVar("tr_"..str, 1, FCVAR_ARCHIVE,"Enable replacer for"..str, 0, 1 )
end

for _, str in pairs(npcList) do -- Создает консольные команды для ограничения спавна энтити
    CreateConVar("tr_"..str, 1, FCVAR_ARCHIVE,"Enable replacer for"..str, 0, 1 )
end

EntityOwners_TR = EntityOwners_TR or {}
NPCOwners_TR = NPCOwners_TR or {} 
-- Глобальная переменная. Очень долго не мог додуматься, как доебаться до создателя.
 -- Без него нельзя присвоить создателя, а если без него, то спавнится сразу 2 энтити.
 -- ДА СУКА. Я доебался до него!
 -- Благодаря глобальной переменной я смог вызвать таблицу в нужном месте
hook.Add("PlayerSpawnedSENT", "SavingOwnerEntity", function(ply,ent) -- Тот самый хук который берет создателя при спавне энтити из спавнменю
    EntityOwners_TR[ent] = ply
end)
hook.Add("PlayerSpawnedNPC", "SavingOwnerNPC", function(ply,ent) -- Тот самый хук который берет создателя при спавне энтити из спавнменю
    NPCOwners_TR[ent] = ply
end)

hook.Add( "WeaponEquip", "WeaponReplaced", function( weapon, ply )
    if GetConVar("tr_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена
    if not table.HasValue(weaponList, weapon:GetClass()) then return end -- Нужно чтобы код не выполнялся если нет нужного энтити
    ------------------------ Общее
    local allWeapons = list.Get("Weapon") -- Получает весь список энтити из спавнменю которое есть в игре (И даже недоступные для спавна)
    local allRandomWeapons = {} -- Списко для Всех случайных оружий
    for k, v in pairs(allWeapons) do
        if v.Spawnable then
            table.insert(allRandomWeapons, k)
        end
    end
    -- Функция нужна для определия, есть ли из списка weaponList то, что заспавнилось
    local function CheckedWeapon_TR(searched_weapon) 
        local nameEnts = weapon:GetClass()
        local targetString = nameEnts

        -- Флаг для отслеживания, была ли найдена нужная строка
        -- Перебор списка строк и поиск нужной строки
        for _, str in pairs(weaponList) do
            if str == targetString then
                searched_weapon = targetString
                return searched_weapon
            end
        end
    end

    ------ Функиции для чтения с разных таблиц из папки data
    local function ReadItemsFile_TR_weapon(weapon, ply)
        local content = file.Read("total_weapon_replacer/"..weapon:GetClass().. ".txt", "DATA")
        if content then
            return util.JSONToTable(content) or {}
        else
            return {}
        end
    end
    if CheckedWeapon_TR() and GetConVar("tr_"..weapon:GetClass()):GetBool() == true then
        -- Без таймера хрен заработает
        timer.Simple(0.0001, function()
            if IsValid(weapon) and CheckedWeapon_TR(searched_weapon) then
                while true do
                    ---- Перебор, преобразование строк в нужный формат
                    local randomWeapon_table = allRandomWeapons[math.random(#allRandomWeapons)] 
                    local list_weapon = ReadItemsFile_TR_weapon(weapon)
                    local current_weapon = list_weapon[math.random(#list_weapon)] or randomWeapon_table
                    ---- Обработка строки: запись выглядит примерно так: "sent_ball:100". sent_ball - имя энтити
                    ---- и 100 - шанс выпадения. Двоиточие разделяет. Но без обработки она как одна строка.
                    ---- Дальше идет разделение с условием. Результаты в name_weapon и chance_weapon. Если только имя 
                    ---- То просто имя будет и все
                    local dataString = current_weapon
                    local parts = string.Explode(":", dataString)
                    local name_weapon = string.Trim(parts[1])
                    local startIndex, endIndex = string.find(dataString, ":")
                    local chance_weapon = 100
                    if startIndex then
                        chance_weapon = tonumber(string.Trim(parts[2])) -- Преобразование строки в число
                    end
                    ---- Конец


                    ------------------- Шанс
                    local chance = math.random(1, 100)
                    if chance <= chance_weapon then
                        local newWeapon = name_weapon
                        ply:StripWeapon(CheckedWeapon_TR())
                        ply:Give(newWeapon)
                        break
                    else
                        -- В противном случае, продолжаем выполнение цикла
                    end

                end
            end
        end)
    end
end)

hook.Add("OnEntityCreated", "ReplacingNPC", function(ent)
    if GetConVar("tr_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена
    if not table.HasValue(npcList, ent:GetClass()) then return end -- Нужно чтобы код не выполнялся если нет нужного энтити
            ------------------------ Общее
    local allNPC = list.Get("NPC") -- Получает весь список энтити из спавнменю которое есть в игре (И даже недоступные для спавна)
    local allRandomNPC = {} -- Списко для Всех случайных оружий
    for k, v in pairs(allNPC) do
        table.insert(allRandomNPC, k)
    end
        -- Функция нужна для определия, есть ли из списка npcList то, что заспавнилось
        local function CheckedNPC_TR(searched_npc) 
            local nameEnts = ent:GetClass()
            local targetString = nameEnts
    
            -- Флаг для отслеживания, была ли найдена нужная строка
            local stringFound = false
            -- Перебор списка строк и поиск нужной строки
            for _, str in pairs(npcList) do
                if str == targetString then
                    stringFound = true
                    searched_npc = targetString
                    return searched_npc
                end
            end
        end
    
    ------ Функиции для чтения с разных таблиц из папки data
    local function ReadItemsFile_TR_npc(ent, ply)
        local content = file.Read("total_npc_replacer/"..ent:GetClass().. ".txt", "DATA")
        if content then
            return util.JSONToTable(content) or {}
        else
            return {}
        end
    end

    -- Функция замены энтити при спавне, а также выдача прав с возможностью удаления с помощью Z если было заспавнено через спавнменю
    local function ReplacingNPC_TR(ent)
        if ent:IsNPC() and IsValid(ent) and CheckedNPC_TR(searched_npc) then -- Ничто кроме NPC
            -- Без таймера хрен заработает
            timer.Simple(0.01, function()
                if IsValid(ent) and CheckedNPC_TR(searched_npc) and not ent:GetOwner():IsPlayer() and not ent:GetOwner():IsNPC() then
                    while true do
                        ---- Перебор, преобразование строк в нужный формат
                        local randomNPC_table = allRandomNPC[math.random(#allRandomNPC)] 
                        local list_npc = ReadItemsFile_TR_npc(ent)
                        local current_npc = list_npc[math.random(#list_npc)] or randomNPC_table
                        ---- Обработка строки: запись выглядит примерно так: "sent_ball:100". sent_ball - имя энтити
                        ---- и 100 - шанс выпадения. Двоиточие разделяет. Но без обработки она как одна строка.
                        ---- Дальше идет разделение с условием. Результаты в name_npc и chance_npc. Если только имя 
                        ---- То просто имя будет и все
                        local dataString = current_npc
                        local parts = string.Explode(":", dataString)
                        local name_npc = string.Trim(parts[1])
                        local startIndex, endIndex = string.find(dataString, ":")
                        local chance_npc = 100
                        if startIndex then
                            chance_npc = tonumber(string.Trim(parts[2])) -- Преобразование строки в число
                        end
                        ---- Конец


                        ------------------- Шанс
                        local chance = math.random(1, 100)
                        if chance <= chance_npc then
                            local newNPC = ents.Create(name_npc)
                            local owner = NPCOwners_TR[ent]

                            newNPC:SetPos(ent:GetPos())
                            newNPC:SetAngles(ent:GetAngles())
                            newNPC:Spawn()
                            newNPC:Activate()
                            newNPC:Give()
                            newNPC:SetOwner(owner)

                            local nameEnts = newNPC:GetClass() -- Преобразование в название энтити
                            local undoName = "Replaced NPC: "..nameEnts -- Удаляемое имя и конкретное название энтити
                            print(undoName)
                            undo.Create(undoName) -- Все для работы с Undo и соответсвенно с Z клавишей
                            undo.AddEntity(newNPC) -- Все для работы с Undo и соответсвенно с Z клавишей
                            undo.SetPlayer(owner) -- Присваивание игроку предмет
                            undo.Finish() -- Наконец можно удалить этот энтити. Не зря ебался с этой хуйней
                            ent:Remove() -- удаляем энтити
                            break
                        else
                            -- В противном случае, продолжаем выполнение цикла
                        end
                    end
                end
            end)
        end
    end
    -- Проверка того, что энтити есть в списке Заменяемых а также разрешено ли заменять его
        if CheckedNPC_TR() and GetConVar("tr_"..ent:GetClass()):GetBool() == true then
            ReplacingNPC_TR(ent)
        end
end)

hook.Add("OnEntityCreated", "ReplacingEntity", function(ent) -- При создании энтити тотально проверяет а также заполняет таблицы со всеми энтити(пока только из вкладки Энтити)
    if GetConVar("tr_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена
    if not table.HasValue(entityList, ent:GetClass()) then return end -- Нужно чтобы код не выполнялся если нет нужного энтити
            ------------------------ Общее
    local allSpawnableEntities = list.Get("SpawnableEntities") -- Получает весь список энтити из спавнменю которое есть в игре (И даже недоступные для спавна)
    local allRandomEntities = {} -- Списко для Всех случайных оружий
    for k, v in pairs(allSpawnableEntities) do
        table.insert(allRandomEntities, k)
    end
        -- Функция нужна для определия, есть ли из списка entityList то, что заспавнилось
        local function CheckedEntity_TR(searched_entity) 
            local nameEnts = ent:GetClass()
            local targetString = nameEnts
    
            -- Флаг для отслеживания, была ли найдена нужная строка
            local stringFound = false
            -- Перебор списка строк и поиск нужной строки
            for _, str in pairs(entityList) do
                if str == targetString then
                    stringFound = true
                    searched_entity = targetString
                    return searched_entity
                end
            end
        end
    
    ------ Функиции для чтения с разных таблиц из папки data
    local function ReadItemsFile_TR_entity(ent, ply)
        local content = file.Read("total_entity_replacer/"..ent:GetClass().. ".txt", "DATA")
        if content then
            return util.JSONToTable(content) or {}
        else
            return {}
        end
    end

    -- Функция замены энтити при спавне, а также выдача прав с возможностью удаления с помощью Z если было заспавнено через спавнменю
    local function ReplacingEntity_TR(ent)
        -- Проверка, является ли энтити транспортом
        -- if ent:IsVehicle() then
        --     print("This entity is a vehicle.")
        -- end

        -- -- Проверка, является ли энтити оружием
        -- if ent:IsWeapon() then
        --     print("This entity is a weapon.")
        -- end

        -- Проверка, является ли энтити НПС
        
        if not ent:IsNPC() and not ent:IsWeapon() and not ent:IsVehicle() then -- Ничто кроме из вкладки entity 
            -- Без таймера хрен заработает
            timer.Simple(0.0001, function()
                if IsValid(ent) and CheckedEntity_TR(searched_entity) and not ent:GetOwner():IsPlayer() and not ent:GetOwner():IsNPC() then
                    while true do
                        ---- Перебор, преобразование строк в нужный формат
                        local randomEntity_table = allRandomEntities[math.random(#allRandomEntities)] 
                        local list_entity = ReadItemsFile_TR_entity(ent)
                        local current_entity = list_entity[math.random(#list_entity)] or randomEntity_table
                        ---- Обработка строки: запись выглядит примерно так: "sent_ball:100". sent_ball - имя энтити
                        ---- и 100 - шанс выпадения. Двоиточие разделяет. Но без обработки она как одна строка.
                        ---- Дальше идет разделение с условием. Результаты в name_entity и chance_entity. Если только имя 
                        ---- То просто имя будет и все
                        local dataString = current_entity
                        local parts = string.Explode(":", dataString)
                        local name_entity = string.Trim(parts[1])
                        local startIndex, endIndex = string.find(dataString, ":")
                        local chance_entity = 100
                        if startIndex then
                            chance_entity = tonumber(string.Trim(parts[2])) -- Преобразование строки в число
                        end
                        ---- Конец


                        ------------------- Шанс
                        local chance = math.random(1, 100)
                        if chance <= chance_entity then
                            local newEntity = ents.Create(name_entity)
                            local owner = EntityOwners_TR[ent]

                            newEntity:SetPos(ent:GetPos())
                            newEntity:SetAngles(ent:GetAngles())
                            newEntity:Spawn()
                            newEntity:Activate()
                            newEntity:SetOwner(owner)

                            local nameEnts = newEntity:GetClass() -- Преобразование в название энтити
                            local undoName = "Replaced Entity: "..nameEnts -- Удаляемое имя и конкретное название энтити
                            undo.Create(undoName) -- Все для работы с Undo и соответсвенно с Z клавишей
                            undo.AddEntity(newEntity) -- Все для работы с Undo и соответсвенно с Z клавишей
                            undo.SetPlayer(owner) -- Присваивание игроку предмет
                            undo.Finish() -- Наконец можно удалить этот энтити. Не зря ебался с этой хуйней
                            ent:Remove() -- удаляем энтити
                            break
                        else
                            -- В противном случае, продолжаем выполнение цикла
                        end
                    end
                end
            end)
        end
    end
    -- Проверка того, что энтити есть в списке Заменяемых а также разрешено ли заменять его
        if CheckedEntity_TR() and GetConVar("tr_"..ent:GetClass()):GetBool() == true then
            ReplacingEntity_TR(ent)
        end
end)

