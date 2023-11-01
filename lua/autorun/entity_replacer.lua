

CreateConVar("ter_enable", 1, FCVAR_ARCHIVE,"Enable Total Weapons Replacer?", 0, 1 )

local entityList = {
    "item_healthkit",
    "item_healthvial",
    "item_battery",
    "item_ammo_smg1_grenade",
    -- Добавьте другие строки
}

for _, str in pairs(entityList) do
    CreateConVar("ter_"..str, 1, FCVAR_ARCHIVE,"Enable replacer for"..str, 0, 1 )
end

------------------------ Общее
local allSpawnableEntities = list.Get("SpawnableEntities") -- Получает весь список оружия которое есть в игре (И даже недоступные для спавна)
local allRandomEntities = {}
--------------------- Заполнение списка Рандомизатора оружия (Начало)
for k, v in pairs(allSpawnableEntities) do
    table.insert(allRandomEntities, k)
end



-- Замена оружие прям по всей карте
hook.Add("PlayerSpawnedSENT", "PlayerReplacingEntity", function(ply,ent)
    if GetConVar("ter_enable"):GetBool() == false then return end
    if not table.HasValue(entityList, ent:GetClass()) then return end -- Нужно чтобы код не выполнялся если нет нужного энтити
------ Функиции для чтения с разных таблиц
    local function ReadItemsFile_TER(ply, ent)
        local spawned_entity = ent:GetClass()
        local content = file.Read("total_entity_replacer/" .. spawned_entity .. ".txt", "DATA")
        if content then
            return util.JSONToTable(content) or {}
        else
            return {}
        end
    end


    local function CheckedEntity_TER(searched_entity)
        local nameEnts = ent:GetClass()
        -- Создайте большой список строк

        -- Строка, которую вы ищете
        local targetString = nameEnts

        -- Флаг для отслеживания, была ли найдена нужная строка
        local stringFound = false

        -- Перебор списка строк и поиск нужной строки
        for _, str in pairs(entityList) do
            if str == targetString then
                -- Если найдена нужная строка, устанавливаем флаг и выходим из цикла
                stringFound = true
                searched_entity = targetString
                return searched_entity
            end
        end

    end


    local function ReplacingEntity_TER(ent)
        timer.Simple(0.001, function()
            local randomEntity_table = allRandomEntities[math.random(#allRandomEntities)]
            local list_entity = ReadItemsFile_TER(ply, ent)
            local current_entity = list_entity[math.random(#list_entity)]
            if IsValid(ent) and CheckedEntity_TER(searched_entity) then
                local newEntity = ents.Create(current_entity or randomEntity_table) 
                newEntity:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newEntity:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newEntity:Spawn() -- спавним новое оружие
                newEntity:SetOwner(ply) -- Устанавливает создателя энтити из-за того, что заменяется энтити без создателя и без него нельзя удалить Z клавишей или gmod_undo
    
                -- Присваиваем сущности действие отмены (Undo)
                local nameEnts = newEntity:GetClass() -- Название энтити
                local undoName = "Replaced Entity: "..nameEnts -- Удаляемое имя и конкретное название энтити
                undo.Create(undoName) -- Все для работы с Undo и соответсвенно с Z клавишей
                undo.AddEntity(newEntity) -- Все для работы с Undo и соответсвенно с Z клавишей
                undo.SetPlayer(ply) -- Присваивание игроку предмет
                undo.Finish() -- Наконец можно удалить этот энтити. Не зря ебался с этой хуйней
                ent:Remove() -- удаляем энтити
            end
        end)
    end
    --------------------- Заполнение списка Рандомизатора оружия (Конец)

    if CheckedEntity_TER() and GetConVar("ter_"..ent:GetClass()):GetBool() == true and ent:GetOwner(ply) then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        ReplacingEntity_TER(ent)
    end
end)


hook.Add("OnEntityCreated", "AlternativeReplacingEntity", function(ent)
    if GetConVar("ter_enable"):GetBool() == false then return end
    if not table.HasValue(entityList, ent:GetClass()) then return end -- Нужно чтобы код не выполнялся если нет нужного энтити
        local function CheckedEntity_TER(searched_entity)
            local nameEnts = ent:GetClass()
            -- Создайте большой список строк
    
            -- Строка, которую вы ищете
            local targetString = nameEnts
    
            -- Флаг для отслеживания, была ли найдена нужная строка
            local stringFound = false
    
            -- Перебор списка строк и поиск нужной строки
            for _, str in pairs(entityList) do
                if str == targetString then
                    -- Если найдена нужная строка, устанавливаем флаг и выходим из цикла
                    stringFound = true
                    searched_entity = targetString
                    return searched_entity
                end
            end
    
        end
    
        
    ------ Функиции для чтения с разных таблиц
    local function ReadItemsFile_TER_entity(ply, ent)
        local readed = "item_healthvial"
        local content = file.Read("total_entity_replacer/"..readed.. ".txt", "DATA")
        if content then
            return util.JSONToTable(content) or {}
        else
            return {}
        end
    end

    local function ReplacingEntity_TER(ent)
        timer.Simple(0.001, function()
            local randomEntity_table = allRandomEntities[math.random(#allRandomEntities)]
            local list_entity = ReadItemsFile_TER_entity(ent)
            local current_entity = list_entity[math.random(#list_entity)]
            if IsValid(ent) and CheckedEntity_TER(searched_entity) then
                local newEntity = ents.Create(current_entity or randomEntity_table) 
                newEntity:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newEntity:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newEntity:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем энтити
            end
        end)
    end
    --------------------- Заполнение списка Рандомизатора оружия (Конец)
    if CheckedEntity_TER() and GetConVar("ter_"..ent:GetClass()):GetBool() == false and ent:GetOwner() == NULL then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        ReplacingEntity_TER(ent)
    end
end)

