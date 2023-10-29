
------ Функиции для чтения с разных таблиц
local function ReadItemsFile_pistol(ply)
    table_weapon = "weapon_pistol"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_smg1(ply)
    table_weapon = "weapon_smg1"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_ar2(ply)
    table_weapon = "weapon_ar2"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_shotgun(ply)
    table_weapon = "weapon_shotgun"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_crowbar(ply)
    table_weapon = "weapon_crowbar"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_revolver(ply)
    table_weapon = "weapon_357"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_physcannon(ply)
    table_weapon = "weapon_physcannon"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_crossbow(ply)
    table_weapon = "weapon_crossbow"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_frag(ply)
    table_weapon = "weapon_frag"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_rpg(ply)
    table_weapon = "weapon_rpg"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_slam(ply)
    table_weapon = "weapon_slam"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_stunstick(ply)
    table_weapon = "weapon_stunstick"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

local function ReadItemsFile_bugbait(ply)
    table_weapon = "weapon_bugbait"
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end

CreateConVar("twr_enable", 1, FCVAR_ARCHIVE,"Enable Total Weapons Replacer?", 0, 1 )
CreateConVar("twr_alternative_replace", 0, FCVAR_ARCHIVE,"Enable alternative methon replacing for Total Weapons Replacer?", 0, 1 )
CreateConVar("twr_pistol", 1, FCVAR_ARCHIVE,"Enable replacer for pistol", 0, 1 )
CreateConVar("twr_smg1", 1, FCVAR_ARCHIVE,"Enable replacer for smg1?", 0, 1 )
CreateConVar("twr_ar2", 1, FCVAR_ARCHIVE,"Enable replacer for AR2?", 0, 1 )
CreateConVar("twr_shotgun", 1, FCVAR_ARCHIVE,"Enable replacer for shotgun?", 0, 1 )
CreateConVar("twr_crowbar", 1, FCVAR_ARCHIVE,"Enable replacer for crowbar?", 0, 1 )
CreateConVar("twr_crossbow", 1, FCVAR_ARCHIVE,"Enable replacer for crossbow?", 0, 1 )
CreateConVar("twr_physcannon", 1, FCVAR_ARCHIVE,"Enable replacer for physcannon?", 0, 1 )
CreateConVar("twr_frag", 1, FCVAR_ARCHIVE,"Enable replacer for frag grenade?", 0, 1 )
CreateConVar("twr_rpg", 1, FCVAR_ARCHIVE,"Enable replacer for RPG?", 0, 1 )
CreateConVar("twr_slam", 1, FCVAR_ARCHIVE,"Enable replacer for SLAM?", 0, 1 )
CreateConVar("twr_revolver", 1, FCVAR_ARCHIVE,"Enable replacer for revolver?", 0, 1 )
CreateConVar("twr_stunstick", 1, FCVAR_ARCHIVE,"Enable replacer for stunstick?", 0, 1 )
CreateConVar("twr_bugbait", 1, FCVAR_ARCHIVE,"Enable replacer for bugbait?", 0, 1 )


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



        ------------------------------------------------------------------------- Начало кода для SMG1  
        local list_weapons_smg1 = ReadItemsFile_smg1(ply)
        local weapons_for_smg1 = list_weapons_smg1[math.random(#list_weapons_smg1)]
        if ply:HasWeapon("weapon_smg1") and GetConVar("twr_smg1"):GetBool() == true then
            ply:StripWeapon("weapon_smg1")
            ply:Give(weapons_for_smg1 or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для SMG1



        ------------------------------------------------------------------------- Начало кода для AR2 
        local list_weapons_ar2 = ReadItemsFile_ar2(ply)
        local weapons_for_ar2 = list_weapons_ar2[math.random(#list_weapons_ar2)]
        if ply:HasWeapon("weapon_ar2") and GetConVar("twr_ar2"):GetBool() == true then
            ply:StripWeapon("weapon_ar2")
            ply:Give(weapons_for_ar2 or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для AR2



        ------------------------------------------------------------------------- Начало кода для дробовика
        local list_weapons_shotgun = ReadItemsFile_shotgun(ply)
        local weapons_for_shotgun = list_weapons_shotgun[math.random(#list_weapons_shotgun)]
        if ply:HasWeapon("weapon_shotgun") and GetConVar("twr_shotgun"):GetBool() == true then
            ply:StripWeapon("weapon_shotgun")
            ply:Give(weapons_for_shotgun or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для дробовика



        ------------------------------------------------------------------------- Начало кода для монтировки
        local list_weapons_crowbar = ReadItemsFile_crowbar(ply)
        local weapons_for_crowbar = list_weapons_crowbar[math.random(#list_weapons_crowbar)]
        if ply:HasWeapon("weapon_crowbar") and GetConVar("twr_crowbar"):GetBool() == true then
            ply:StripWeapon("weapon_crowbar")
            ply:Give(weapons_for_crowbar or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для монтировки
        


        ------------------------------------------------------------------------- Начало кода для револьвера
        local list_weapons_revolver = ReadItemsFile_revolver(ply)
        local weapons_for_revolver = list_weapons_revolver[math.random(#list_weapons_revolver)]
        if ply:HasWeapon("weapon_357") and GetConVar("twr_revolver"):GetBool() == true then
            ply:StripWeapon("weapon_357")
            ply:Give(weapons_for_revolver or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для револьвера
        


        ------------------------------------------------------------------------- Начало кода для гравипушки
        local list_weapons_physcannon = ReadItemsFile_physcannon(ply)
        local weapons_for_physcannon = list_weapons_physcannon[math.random(#list_weapons_physcannon)]
        if ply:HasWeapon("weapon_physcannon") and GetConVar("twr_physcannon"):GetBool() == true then
            ply:StripWeapon("weapon_physcannon")
            ply:Give(weapons_for_physcannon or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для гравипушки

        ------------------------------------------------------------------------- Начало кода для арбалета
        local list_weapons_crossbow = ReadItemsFile_crossbow(ply)
        local weapons_for_crossbow = list_weapons_crossbow[math.random(#list_weapons_crossbow)]        if ply:HasWeapon("weapon_crossbow") and GetConVar("twr_crossbow"):GetBool() == true then
            ply:StripWeapon("weapon_crossbow")
            ply:Give(weapons_for_crossbow or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для арбалета
        


        ------------------------------------------------------------------------- Начало кода для RPG
        local list_weapons_rpg = ReadItemsFile_rpg(ply)
        local weapons_for_rpg = list_weapons_rpg[math.random(#list_weapons_rpg)]
        if ply:HasWeapon("weapon_rpg") and GetConVar("twr_rpg"):GetBool() == true then
            ply:StripWeapon("weapon_rpg")
            ply:Give(weapons_for_rpg or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для RPG



        ------------------------------------------------------------------------- Начало кода для гранат
        local list_weapons_frag = ReadItemsFile_frag(ply)
        local weapons_for_frag = list_weapons_frag[math.random(#list_weapons_frag)]
        if ply:HasWeapon("weapon_frag") and GetConVar("twr_frag"):GetBool() == true then
            ply:StripWeapon("weapon_frag")
            ply:Give(weapons_for_frag or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для гранат


        ------------------------------------------------------------------------- Начало кода для SLAM
        local list_weapons_slam = ReadItemsFile_slam(ply)
        local weapons_for_slam = list_weapons_slam[math.random(#list_weapons_slam)]
        if ply:HasWeapon("weapon_slam") and GetConVar("twr_slam"):GetBool() == true then
            ply:StripWeapon("weapon_slam")
            ply:Give(weapons_for_slam or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для SLAM        
       
        
        ------------------------------------------------------------------------- Начало кода для электродубинки
        local list_weapons_stunstick = ReadItemsFile_stunstick(ply)
        local weapons_for_stunstick = list_weapons_stunstick[math.random(#list_weapons_stunstick)]
        if ply:HasWeapon("weapon_stunstick") and GetConVar("twr_stunstick"):GetBool() == true then
            ply:StripWeapon("weapon_stunstick")
            ply:Give(weapons_for_stunstick or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для электродубинки
        

        ------------------------------------------------------------------------- Начало кода для муравьиной приманки
        local list_weapons_bugbait = ReadItemsFile_bugbait(ply)
        local weapons_for_bugbait = list_weapons_bugbait[math.random(#list_weapons_bugbait)]
        if ply:HasWeapon("weapon_bugbait") and GetConVar("twr_bugbait"):GetBool() == true then
            ply:StripWeapon("weapon_bugbait")
            ply:Give(weapons_for_bugbait or randomWeapon_table)
        end
        ------------------------------------------------------------------------- Конец кода для муравьиной приманки
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

    if ent:GetClass() == "weapon_smg1" and GetConVar("twr_smg1"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_smg1 = ReadItemsFile_smg1(ply)
            local weapons_for_smg1s = list_weapons_smg1[math.random(#list_weapons_smg1)]
            if IsValid(ent) and ent:GetClass() == "weapon_smg1" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponSMG1 = ents.Create(weapons_for_smg1s or randomWeapon_table) 
                newWeaponSMG1:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponSMG1:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponSMG1:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end

    if ent:GetClass() == "weapon_ar2" and GetConVar("twr_ar2"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_ar2 = ReadItemsFile_ar2(ply)
            local weapons_for_ar2s = list_weapons_ar2[math.random(#list_weapons_ar2)]
            if IsValid(ent) and ent:GetClass() == "weapon_ar2" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponAR2 = ents.Create(weapons_for_ar2s or randomWeapon_table) 
                newWeaponAR2:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponAR2:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponAR2:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end

    if ent:GetClass() == "weapon_shotgun" and GetConVar("twr_shotgun"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_shotgun = ReadItemsFile_shotgun(ply)
            local weapons_for_shotguns = list_weapons_shotgun[math.random(#list_weapons_shotgun)]
            if IsValid(ent) and ent:GetClass() == "weapon_shotgun" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponShotgun = ents.Create(weapons_for_shotguns or randomWeapon_table) 
                newWeaponShotgun:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponShotgun:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponShotgun:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end

    if ent:GetClass() == "weapon_crowbar" and GetConVar("twr_crowbar"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_crowbar = ReadItemsFile_crowbar(ply)
            local weapons_for_crowbars = list_weapons_crowbar[math.random(#list_weapons_crowbar)]
            if IsValid(ent) and ent:GetClass() == "weapon_crowbar" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponCrowbar = ents.Create(weapons_for_crowbars or randomWeapon_table) 
                newWeaponCrowbar:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponCrowbar:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponCrowbar:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end

    if ent:GetClass() == "weapon_357" and GetConVar("twr_revolver"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_revolver = ReadItemsFile_revolver(ply)
            local weapons_for_revolvers = list_weapons_revolver[math.random(#list_weapons_revolver)]
            if IsValid(ent) and ent:GetClass() == "weapon_357" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeapon357 = ents.Create(weapons_for_revolvers or randomWeapon_table) 
                newWeapon357:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeapon357:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeapon357:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end

    if ent:GetClass() == "weapon_physcannon" and GetConVar("twr_physcannon"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_physcannon = ReadItemsFile_physcannon(ply)
            local weapons_for_physcannons = list_weapons_physcannon[math.random(#list_weapons_physcannon)]
            if IsValid(ent) and ent:GetClass() == "weapon_physcannon" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponPhyscannon = ents.Create(weapons_for_physcannons or randomWeapon_table) 
                newWeaponPhyscannon:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponPhyscannon:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponPhyscannon:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end

    if ent:GetClass() == "weapon_crossbow" and GetConVar("twr_crossbow"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_crossbow = ReadItemsFile_crossbow(ply)
            local weapons_for_crossbows = list_weapons_crossbow[math.random(#list_weapons_crossbow)]
            if IsValid(ent) and ent:GetClass() == "weapon_crossbow" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponCrossbow = ents.Create(weapons_for_crossbows or randomWeapon_table) 
                newWeaponCrossbow:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponCrossbow:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponCrossbow:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end

    if ent:GetClass() == "weapon_rpg" and GetConVar("twr_rpg"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_rpg = ReadItemsFile_rpg(ply)
            local weapons_for_rpgs = list_weapons_rpg[math.random(#list_weapons_rpg)]
            if IsValid(ent) and ent:GetClass() == "weapon_rpg" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponRPG = ents.Create(weapons_for_rpgs or randomWeapon_table) 
                newWeaponRPG:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponRPG:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponRPG:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end

    if ent:GetClass() == "weapon_frag" and GetConVar("twr_frag"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_frag = ReadItemsFile_frag(ply)
            local weapons_for_frags = list_weapons_frag[math.random(#list_weapons_frag)]
            if IsValid(ent) and ent:GetClass() == "weapon_frag" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponFrag = ents.Create(weapons_for_frags or randomWeapon_table) 
                newWeaponFrag:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponFrag:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponFrag:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end

    if ent:GetClass() == "weapon_slam" and GetConVar("twr_slam"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_slam = ReadItemsFile_slam(ply)
            local weapons_for_slams = list_weapons_slam[math.random(#list_weapons_slam)]
            if IsValid(ent) and ent:GetClass() == "weapon_slam" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponSLAM = ents.Create(weapons_for_slams or randomWeapon_table) 
                newWeaponSLAM:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponSLAM:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponSLAM:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end

    if ent:GetClass() == "weapon_stunstick" and GetConVar("twr_stunstick"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_stunstick = ReadItemsFile_stunstick(ply)
            local weapons_for_stunsticks = list_weapons_stunstick[math.random(#list_weapons_stunstick)]
            if IsValid(ent) and ent:GetClass() == "weapon_stunstick" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponStunstick = ents.Create(weapons_for_stunsticks or randomWeapon_table) 
                newWeaponStunstick:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponStunstick:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponStunstick:Spawn() -- спавним новое оружие

                ent:Remove() -- удаляем пистолет
            end
        end)
    end

    if ent:GetClass() == "weapon_bugbait" and GetConVar("twr_bugbait"):GetBool() == true then
        -- Ожидаем немного, чтобы убедиться, что оружие полностью создано и инициализировано
        timer.Simple(0.05, function()
            local list_weapons_bugbait = ReadItemsFile_bugbait(ply)
            local weapons_for_bugbaits = list_weapons_bugbait[math.random(#list_weapons_bugbait)]
            if IsValid(ent) and ent:GetClass() == "weapon_bugbait" and not ent:GetOwner():IsNPC() and not (IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer()) then
                local newWeaponbugbait = ents.Create(weapons_for_bugbaits or randomWeapon_table) 
                newWeaponbugbait:SetPos(ent:GetPos()) -- устанавливаем позицию нового оружия
                newWeaponbugbait:SetAngles(ent:GetAngles()) -- устанавливаем угол нового оружия
                newWeaponbugbait:Spawn() -- спавним новое оружие

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

            if IsValid(weapon) and weapon:GetClass() == "weapon_smg1" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_smg1")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end

            if IsValid(weapon) and weapon:GetClass() == "weapon_ar2" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_ar2")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end

            if IsValid(weapon) and weapon:GetClass() == "weapon_shotgun" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_shotgun")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end

            if IsValid(weapon) and weapon:GetClass() == "weapon_crowbar" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_crowbar")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end

            if IsValid(weapon) and weapon:GetClass() == "weapon_357" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_357")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end

            if IsValid(weapon) and weapon:GetClass() == "weapon_physcannon" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_physcannon")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end

            if IsValid(weapon) and weapon:GetClass() == "weapon_crossbow" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_physcannon")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end

            if IsValid(weapon) and weapon:GetClass() == "weapon_rpg" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_rpg")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end

            if IsValid(weapon) and weapon:GetClass() == "weapon_frag" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_frag")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end

            if IsValid(weapon) and weapon:GetClass() == "weapon_slam" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_slam")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end

            if IsValid(weapon) and weapon:GetClass() == "weapon_stunstick" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_stunstick")
                weapon_droped:SetPos(weapon:GetPos())
                weapon_droped:SetAngles(weapon:GetAngles())
                weapon_droped:Spawn()
                -- Удаляем пистолет
                weapon:Remove()
                break -- Прерываем цикл после замены, чтобы избежать замены нескольких пистолетов (если их было несколько)
            end

            if IsValid(weapon) and weapon:GetClass() == "weapon_bugbait" then
                -- Создаем новое оружие (базуку)
                local weapon_droped = ents.Create("weapon_bugbait")
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
