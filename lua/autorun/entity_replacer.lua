
------ Функиции для чтения с разных таблиц
local function ReadItemsFile_pistol(ply)
    table_weapon = "weapon_pistol"
    local content = file.Read("total_entity_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

CreateConVar("twr_enable", 1, FCVAR_ARCHIVE,"Enable Total Weapons Replacer?", 0, 1 )
CreateConVar("twr_alternative_replace", 0, FCVAR_ARCHIVE,"Enable alternative methon replacing for Total Weapons Replacer?", 0, 1 )
CreateConVar("twr_pistol", 1, FCVAR_ARCHIVE,"Enable replacer for pistol", 0, 1 )


hook.Add( "WeaponEquip", "WeaponEquipExample", function( weapon, ply )
    if GetConVar("twr_enable"):GetBool() == false then return end
    timer.Simple( 0, function()
        
        ------------------------ Общее
        local allWeapons = list.Get("Weapon") -- Получает весь список оружия которое есть в игре (И даже недоступные для спавна)
        local allRandomWeapons = {}
        local Chance = math.random(0.1, 100)
        --------------------- Заполнение списка Рандомизатора оружия (Начало)
        for k, v in pairs(allWeapons) do
            if v.Spawnable then -- Если оружие можно заспавнить с Q-Menu, то оно заполняется в таблицу
                table.insert(allRandomWeapons, k)
            end
        end
        --------------------- Заполнение списка Рандомизатора оружия (Конец)

        local randomWeapon_table = allRandomWeapons[math.random(#allRandomWeapons)]
        ------------------------------------------------------------------------- Начало кода для пистолета
        local list_weapons_pistol = ReadItemsFile_pistol(ply)
        local weapons_for_pistols = list_weapons_pistol[math.random(#list_weapons_pistol)]
        if ply:HasWeapon("weapon_pistol") and GetConVar("twr_pistol"):GetBool() == true then
            ply:StripWeapon("weapon_pistol")
            ply:Give(weapons_for_pistols or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для пистолета 
	end )
end )

-- Замена оружие прям по всей карте
hook.Add("OnEntityCreated", "AlternativeReplacingWeapon", function(ent)
    if GetConVar("twr_alternative_replace"):GetBool() == false then return end
    if GetConVar("twr_enable"):GetBool() == false then return end
    ------------------------ Общее
    local allWeapons = list.Get("Weapon") -- Получает весь список оружия которое есть в игре (И даже недоступные для спавна)
    local allRandomWeapons = {}
    --------------------- Заполнение списка Рандомизатора оружия (Начало)
    for k, v in pairs(allWeapons) do
        if v.Spawnable then -- Если оружие можно заспавнить с Q-Menu, то оно заполняется в таблицу
            table.insert(allRandomWeapons, k)
        end
    end
    --------------------- Заполнение списка Рандомизатора оружия (Конец)
    
    local randomWeapon_table = allRandomWeapons[math.random(#allRandomWeapons)]

    if ent:GetClass() == "weapon_pistol" and GetConVar("twr_pistol"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_pistol = ReadItemsFile_pistol(ply)
            local weapons_for_pistols = list_weapons_pistol[math.random(#list_weapons_pistol)]
            if IsValid(ent) and ent:GetClass() == "weapon_pistol" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponPistol = ents.Create(weapons_for_pistols or randomWeapon_table) 
                newWeaponPistol:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponPistol:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponPistol:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end
end)
----Замена при падении оружия с NPC 
hook.Add("OnNPCKilled", "ReplaceDroppedWeapon", function(npc, attacker, inflictor)
    if GetConVar("twr_alternative_replace"):GetBool() == false then return end
    if GetConVar("twr_enable"):GetBool() == false then return end
    -- Ожидаем небольшую задержку, чтобы дать NPC упасть и выпустить оружие
    timer.Simple(0.01, function()
        -- Ищем ближайший пистолет вокруг точки смерти NPC
        local droppedWeapons = ents.FindInSphere(npc:GetPos(), 45)

        for _, weapon in ipairs(droppedWeapons) do
            if IsValid(weapon) and weapon:GetClass() == "weapon_pistol"  then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_pistol")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end
        end
    end)
end)
