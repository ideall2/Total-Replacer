

CreateConVar("ter_enable", 1, FCVAR_ARCHIVE,"Enable Total Entity Replacer?", 0, 1 )

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
    -- Добавьте другие строки
}



for _, str in pairs(entityList) do -- Создает консольные команды для ограничения спавна энтити
    CreateConVar("ter_"..str, 1, FCVAR_ARCHIVE,"Enable replacer for"..str, 0, 1 )
end


EntityOwners_TER = EntityOwners_TER or {} 
-- Глобальная переменная. Очень долго не мог додуматься, как доебаться до создателя.
 -- Без него нельзя присвоить создателя, а если без него, то спавнится сразу 2 энтити.
 -- ДА СУКА. Я доебался до него!
 -- Благодаря глобальной переменной я смог вызвать таблицу в нужном месте
hook.Add("PlayerSpawnedSENT", "SavingOwnerEntity", function(ply,ent) -- Тот самый хук который берет создателя при спавне энтити из спавнменю
    EntityOwners_TER[ent] = ply
end)

hook.Add("OnEntityCreated", "ReplacingEntity", function(ent) -- При создании энтити тотально проверяет а также заполняет таблицы со всеми энтити(пока только из вкладки Энтити)
    if GetConVar("ter_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена
    if not table.HasValue(entityList, ent:GetClass()) then return end -- Нужно чтобы код не выполнялся если нет нужного энтити
            ------------------------ Общее
    local allSpawnableEntities = list.Get("SpawnableEntities") -- Получает весь список энтити из спавнменю которое есть в игре (И даже недоступные для спавна)
    local allRandomEntities = {} -- Списко для Всех случайных оружий
    for k, v in pairs(allSpawnableEntities) do
        table.insert(allRandomEntities, k)
    end
        
        -- Функция нужна для определия, есть ли из списка entityList то, что заспавнилось
        local function CheckedEntity_TER(searched_entity) 
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
    local function ReadItemsFile_TER_entity(ent, ply)
        local content = file.Read("total_entity_replacer/"..ent:GetClass().. ".txt", "DATA")
        if content then
            return util.JSONToTable(content) or {}
        else
            return {}
        end
    end

    -- Функция замены энтити при спавне, а также выдача прав с возможностью удаления с помощью Z если было заспавнено через спавнменю
    local function ReplacingEntity_TER(ent)
        -- Проверка, является ли энтити транспортом
        if ent:IsVehicle() then
            print("This entity is a vehicle.")
        end

        -- Проверка, является ли энтити оружием
        if ent:IsWeapon() then
            print("This entity is a weapon.")
        end

        -- Проверка, является ли энтити НПС
        if ent:IsNPC() then
            print("This entity is an NPC.")
        end
        -- Без таймера хрен заработает
        
        timer.Simple(0.001, function() 
            local randomEntity_table = allRandomEntities[math.random(#allRandomEntities)] 
            local list_entity = ReadItemsFile_TER_entity(ent)
            local current_entity = list_entity[math.random(#list_entity)] or randomEntity_table
            -- Ваша строка данных
            if IsValid(ent) and CheckedEntity_TER(searched_entity) then
                -- Разбиваем строку по запятой и удаляем начальные и конечные пробелы
                
                local dataString = current_entity
                local parts = string.Explode(":", dataString)
                local name_entity = string.Trim(parts[1])
                local startIndex, endIndex = string.find(dataString, ":")
                local chance_entity
                if startIndex then
                    chance_entity = string.Trim(parts[2])  
                end
                print(name_entity)
                print(chance_entity)

                local newEntity = ents.Create(name_entity)
                local owner = EntityOwners_TER[ent]

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
            end
        end)
    end
    -- Проверка того, что энтити есть в списке Заменяемых а также разрешено ли заменять его
    local chance_to_create_ent = math.random(0, 100)
    if chance_to_create_ent >= 1 then
        if CheckedEntity_TER() and GetConVar("ter_"..ent:GetClass()):GetBool() == true then
            ReplacingEntity_TER(ent)
        end
    end
end)

