
------ Функиции для чтения с разных таблиц
local function ReadItemsFile_pistol(ply)
    table_weapon = "item_healthvial"
    local content = file.Read("total_entity_replacer/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

CreateConVar("ter_enable", 1, FCVAR_ARCHIVE,"Enable Total Weapons Replacer?", 0, 1 )
CreateConVar("ter_alternative_replace", 0, FCVAR_ARCHIVE,"Enable alternative methon replacing for Total Enable Replacer?", 0, 1 )
CreateConVar("ter_pistol", 1, FCVAR_ARCHIVE,"Enable replacer for pistol", 0, 1 )


-- Замена оружие прям по всей карте
hook.Add("PlayerSpawnedSENT", "PlayerReplacingEntity", function(ply,ent)
    if GetConVar("ter_alternative_replace"):GetBool() == false then return end
    if GetConVar("ter_enable"):GetBool() == false then return end
    ------------------------ Общее
    local allWeapons = list.Get("SpawnableEntities") -- Получает весь список оружия которое есть в игре (И даже недоступные для спавна)
    local allRandomWeapons = {}
    --------------------- Заполнение списка Рандомизатора оружия (Начало)
    for k, v in pairs(allWeapons) do
        table.insert(allRandomWeapons, k)
    end
    --------------------- Заполнение списка Рандомизатора оружия (Конец)
    local randomWeapon_table = allRandomWeapons[math.random(#allRandomWeapons)]
    if ent:GetClass() == "item_healthvial" and GetConVar("ter_pistol"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.001, function()
            local list_weapons_pistol = ReadItemsFile_pistol(ply)
            local weapons_for_pistols = list_weapons_pistol[math.random(#list_weapons_pistol)]
            if IsValid(ent) and ent:GetClass() == "item_healthvial" then
                local newWeaponPistol = ents.Create(weapons_for_pistols or randomWeapon_table) 
                newWeaponPistol:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponPistol:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponPistol:Spawn() -- спавним новое оружие
                newWeaponPistol:SetOwner(ply) -- Устанавливает создателя энтити из-за того, что заменяется энтити без создателя и без него нельзя удалить Z клавишей или gmod_undo

                -- Присваиваем сущности действие отмены (Undo)
                
                local nameEnts = newWeaponPistol:GetClass() -- Название энтити
                local undoName = "Replaced Entity: "..nameEnts -- Удаляемое имя и конкретное название энтити
                undo.Create(undoName) -- Все для работы с Undo и соответсвенно с Z клавишей
                undo.AddEntity(newWeaponPistol) -- Все для работы с Undo и соответсвенно с Z клавишей
                undo.SetPlayer(ply) -- Присваивание игроку предмет
                undo.Finish() -- Наконец можно удалить этот энтити. Не зря ебался с этой хуйней
                ent:Remove() -- удаляем энтити
            end
        end)
    end


end)
