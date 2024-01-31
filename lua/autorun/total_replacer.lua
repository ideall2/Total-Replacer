local currentMap_TR = game.GetMap()
local function CreateFoldersTR()
    if not file.Exists("total_vehicle_replacer", "DATA") then
        file.CreateDir("total_vehicle_replacer")
        file.CreateDir("total_vehicle_replacer/presets/")
    end

    if not file.Exists("total_entity_replacer", "DATA") then
        file.CreateDir("total_entity_replacer")
        file.CreateDir("total_entity_replacer/presets/")
    end

    if not file.Exists("total_npc_replacer", "DATA") then
        file.CreateDir("total_npc_replacer")
        file.CreateDir("total_npc_replacer/presets/")
    end

    if not file.Exists("total_npcmodels_replacer", "DATA") then
        file.CreateDir("total_npcmodels_replacer")
        file.CreateDir("total_npcmodels_replacer/presets/")
    end

    if not file.Exists("total_npcweapons_replacer", "DATA") then
        file.CreateDir("total_npcweapons_replacer")
        file.CreateDir("total_npcweapons_replacer/presets/")
    end

    if not file.Exists("total_weapon_replacer", "DATA") then
        file.CreateDir("total_weapon_replacer")
        file.CreateDir("total_weapon_replacer/presets/")
    end
end
CreateFoldersTR()

CreateConVar("tr_enable", 1, FCVAR_ARCHIVE,"Enable Total Replacer?", 0, 1 )

CreateConVar("tr_enable_randomize_weapons", 0, FCVAR_ARCHIVE,"Enable Randomizer for empty Weapons?", 0, 1 )
CreateConVar("tr_enable_randomize_entities", 0, FCVAR_ARCHIVE,"Enable Randomizer for empty Entities?", 0, 1 )
CreateConVar("tr_enable_randomize_npc_weapons", 0, FCVAR_ARCHIVE,"Enable Randomizer for empty NPCs weapons?", 0, 1 )

CreateConVar("tr_weapon_enable", 1, FCVAR_ARCHIVE,"Enable Total Replacer for Weapons?", 0, 1 )
CreateConVar("tr_weapon_alternative_enable", 0, FCVAR_ARCHIVE,"Enable Alternative Total Replacer for Weapons?", 0, 1 )
CreateConVar("tr_npc_enable", 1, FCVAR_ARCHIVE,"Enable Total Replacer for NPCs?", 0, 1 )
CreateConVar("tr_npc_models_enable", 1, FCVAR_ARCHIVE,"Enable Total Replacer for NPCs Models?", 0, 1 )
CreateConVar("tr_npc_weapons_enable", 1, FCVAR_ARCHIVE,"Enable Total Replacer for NPCs weapons?", 0, 1 )
CreateConVar("tr_entity_enable", 1, FCVAR_ARCHIVE,"Enable Total Replacer for Entities?", 0, 1 )
CreateConVar("tr_vehicle_enable", 1, FCVAR_ARCHIVE,"Enable Total Replacer for Vehicles?", 0, 1 )

CreateConVar("tr_weapon_give_ammo_mult", 1, FCVAR_ARCHIVE,"How much ammo should be given to a weapon if you pick up a weapon that is already in your inventory?", 0, 10 )

CreateConVar("tr_npc_off_collision_enable", 1, FCVAR_ARCHIVE,"Disable collision for NPC after spawn?", 0, 1 )
CreateConVar("tr_npc_off_collision_time", 5, FCVAR_ARCHIVE,"Timer for returning collision", 0, 30 )

CreateConVar("tr_presets_specific_maps_enable", 0, FCVAR_ARCHIVE,"Enable Specific Map Presets?", 0, 1 )
CreateConVar("tr_presets_specific_maps_enable_npc", 0, FCVAR_ARCHIVE,"Enable Specific Map Presets for NPCs?", 0, 1 )
CreateConVar("tr_presets_specific_maps_enable_weapon", 0, FCVAR_ARCHIVE,"Enable Specific Map Presets for Weapons?", 0, 1 )
CreateConVar("tr_presets_specific_maps_enable_npc_weapon", 0, FCVAR_ARCHIVE,"Enable Specific Map Presets for NPC's weapons?", 0, 1 )
CreateConVar("tr_presets_specific_maps_enable_entity", 0, FCVAR_ARCHIVE,"Enable Specific Map Presets for Entities?", 0, 1 )
CreateConVar("tr_presets_specific_maps_enable_vehicle", 0, FCVAR_ARCHIVE,"Enable Specific Map Presets for Vehicles?", 0, 1 )



function LoadPresetsStartingMapTR(name_dir_tr, name_preset, map_name)
    local files, _ = file.Find(name_dir_tr.. "/presets/" .. name_preset.." _-_ "..map_name.."/*.txt", "DATA")

    for _, filename in ipairs(files) do
        local content = file.Read(name_dir_tr.. "/presets/".. name_preset .." _-_ "..map_name.."/" .. filename, "DATA")
        file.Write(name_dir_tr.."/" .. filename, content)
    end
    -- print("Карта есть. Загружаю")
end

function ReplacePresetsStartingMapTR(name_dir_tr)
    local files, folders = file.Find(name_dir_tr .."/presets".."/*", "DATA")

    for _, folder in ipairs(folders) do
        local parts = string.Explode(" _-_ ", folder)
        local name_preset = string.Trim(parts[1])
        local name_map = string.Trim(parts[2])
        if file.Exists(name_dir_tr.. "/presets/" .. name_preset.." _-_ "..currentMap_TR, "DATA") then
            LoadPresetsStartingMapTR(name_dir_tr, name_preset, name_map)
            break
        else
            return false
        end
    end
end
if GetConVar("tr_presets_specific_maps_enable"):GetBool() == true then
    if GetConVar("tr_presets_specific_maps_enable_npc"):GetBool() == true then
        ReplacePresetsStartingMapTR("total_npc_replacer")
    end
    if GetConVar("tr_presets_specific_maps_enable_weapon"):GetBool() == true then
        ReplacePresetsStartingMapTR("total_weapon_replacer")
    end
    if GetConVar("tr_presets_specific_maps_enable_entity"):GetBool() == true then
        ReplacePresetsStartingMapTR("total_entity_replacer")
    end
    if GetConVar("tr_presets_specific_maps_enable_npc_weapon"):GetBool() == true then
        ReplacePresetsStartingMapTR("total_npcweapons_replacer")
    end
    if GetConVar("tr_presets_specific_maps_enable_vehicle"):GetBool() == true then
        ReplacePresetsStartingMapTR("total_vehicle_replacer")
    end
end

local entityList = { -- Список с энтити для генерации консольных команд
    "item_healthkit",
    "item_healthvial",
    "item_battery",
    "item_ammo_smg1_grenade",
    "item_ammo_357",
    "item_ammo_357_large",
    "item_ammo_ar2",
    "item_ammo_ar2_large",
    "item_ammo_ar2_altfire",
    "combine_mine",
    "item_ammo_crossbow",
    "item_healthcharger",
    "grenade_helicopter",
    "item_suit",
    "item_ammo_pistol",
    "item_ammo_pistol_large",
    "item_rpg_round",
    "item_box_buckshot",
    "item_ammo_smg1",
    "item_ammo_smg1_large",
    "item_suitcharger",
    "prop_thumper",
    "npc_grenade_frag",
    "weapon_striderbuster"
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
    "weapon_annabelle",
    "weapon_alyxgun"
}
local vehicleList = {
    "Jeep",
    "Airboat",
    "Pod",
    "Jalopy"
}
local npcList = { -- Список НПС для генерации консольных команд
    "npc_crow",
    "npc_pigeon",
    "npc_seagull",
    "npc_metropolice",
    "npc_combine_s",
    "CombineElite",
    "npc_monk",
    "npc_clawscanner",
    "npc_combine_camera",
    "npc_combinedropship",
    "npc_combinegunship",
    "npc_cscanner",
    "npc_helicopter",
    "npc_manhack",
    "npc_rollermine",
    "npc_strider",
    "npc_turret_ceiling",
    "npc_turret_floor",
    "CombinePrison",
    "PrisonShotgunner",
    "ShotgunSoldier",
    "npc_alyx",
    "npc_barney",
    "npc_breen",
    "npc_citizen",
    "npc_dog",
    "npc_eli",
    "npc_gman",
    "npc_kleiner",
    "npc_mossman",
    "npc_vortigaunt",
    "npc_odessa",
    "Rebel",
    "Medic",
    "Refugee",
    "VortigauntSlave",
    "npc_antlion",
    "npc_antlionguard",
    "npc_fastzombie",
    "npc_fastzombie_torso",
    "npc_headcrab",
    "npc_headcrab_black",
    "npc_headcrab_fast",
    "npc_poisonzombie",
    "npc_zombie",
    "npc_zombie_torso",
    "npc_hunter",
    "VortigauntUriah",
    "npc_antlion_worker",
    "npc_antlionguardian",
    "npc_zombine",
}
local rebels_models = { -- Модели НПС
    "models/humans/group03/female_01.mdl",
    "models/humans/group03/female_02.mdl",
    "models/humans/group03/female_03.mdl",
    "models/humans/group03/female_04.mdl",
    "models/humans/group03/female_06.mdl",
    "models/humans/group03/female_07.mdl",
    "models/humans/group03/male_01.mdl",
    "models/humans/group03/male_02.mdl",
    "models/humans/group03/male_03.mdl",
    "models/humans/group03/male_04.mdl",
    "models/humans/group03/male_06.mdl",
    "models/humans/group03/male_07.mdl",
    "models/humans/group03/male_08.mdl",
    "models/humans/group03/male_09.mdl",
}

local refugee_models = { -- Модели НПС
    "models/humans/group02/female_01.mdl",
    "models/humans/group02/female_02.mdl",
    "models/humans/group02/female_03.mdl",
    "models/humans/group02/female_04.mdl",
    "models/humans/group02/female_06.mdl",
    "models/humans/group02/female_07.mdl",
    "models/humans/group02/male_01.mdl",
    "models/humans/group02/male_02.mdl",
    "models/humans/group02/male_03.mdl",
    "models/humans/group02/male_04.mdl",
    "models/humans/group02/male_06.mdl",
    "models/humans/group02/male_07.mdl",
    "models/humans/group02/male_08.mdl",
    "models/humans/group02/male_09.mdl",
}
local medic_models = { -- Модели НПС
    "models/humans/group03m/female_01.mdl",
    "models/humans/group03m/female_02.mdl",
    "models/humans/group03m/female_03.mdl",
    "models/humans/group03m/female_04.mdl",
    "models/humans/group03m/female_06.mdl",
    "models/humans/group03m/female_07.mdl",
    "models/humans/group03m/male_01.mdl",
    "models/humans/group03m/male_02.mdl",
    "models/humans/group03m/male_03.mdl",
    "models/humans/group03m/male_04.mdl",
    "models/humans/group03m/male_06.mdl",
    "models/humans/group03m/male_07.mdl",
    "models/humans/group03m/male_08.mdl",
    "models/humans/group03m/male_09.mdl",
}
local citizen_models = { -- Модели НПС
    "models/humans/group01/female_01.mdl",
    "models/humans/group01/female_02.mdl",
    "models/humans/group01/female_03.mdl",
    "models/humans/group01/female_04.mdl",
    "models/humans/group01/female_06.mdl",
    "models/humans/group01/female_07.mdl",
    "models/humans/group01/male_01.mdl",
    "models/humans/group01/male_02.mdl",
    "models/humans/group01/male_03.mdl",
    "models/humans/group01/male_04.mdl",
    "models/humans/group01/male_06.mdl",
    "models/humans/group01/male_07.mdl",
    "models/humans/group01/male_08.mdl",
    "models/humans/group01/male_09.mdl",
}
local standartWeaponNPC = {
    "weapon_pistol",
    "weapon_357",
    "weapon_smg1",
    "weapon_ar2",
    "weapon_shotgun",
    "weapon_crossbow",
    "weapon_crowbar",
    "weapon_stunstick",
    "weapon_rpg",
}

for _, str in pairs(entityList) do -- Создает консольные команды для ограничения спавна энтити
    CreateConVar("tr_"..str, 1, FCVAR_ARCHIVE,"Enable replacer for "..str, 0, 1 )
end

for _, str in pairs(weaponList) do -- Создает консольные команды для ограничения спавна энтити
    CreateConVar("tr_"..str, 1, FCVAR_ARCHIVE,"Enable replacer for "..str, 0, 1 )
end

for _, str in pairs(weaponList) do -- Создает консольные команды для ограничения спавна энтити
    CreateConVar("tr_npc_weapon_"..str, 1, FCVAR_ARCHIVE,"Enable replacer for randomzation NPC Weapons: "..str, 0, 1 )
end

for _, str in pairs(npcList) do -- Создает консольные команды для ограничения спавна энтити
    CreateConVar("tr_"..str, 1, FCVAR_ARCHIVE,"Enable replacer for "..str, 0, 1 )
end

for _, str in pairs(vehicleList) do -- Создает консольные команды для ограничения спавна энтити
    CreateConVar("tr_"..str, 1, FCVAR_ARCHIVE,"Enable replacer for "..str, 0, 1 )
end

EntityOwners_TR = EntityOwners_TR or {}
NPCOwners_TR = NPCOwners_TR or {}
VEHICLEOwners_TR = VEHICLEOwners_TR or {} 
WeaponOwners_TR = WeaponOwners_TR or {} 

hook.Add("PlayerSpawnedSENT", "SavingOwnerEntity", function(ply,ent) -- Тот самый хук который берет создателя при спавне энтити из спавнменю
    EntityOwners_TR[ent] = ply
end)
hook.Add("PlayerSpawnedSWEP", "SavingOwnerWeapon", function(ply,ent) -- Тот самый хук который берет создателя при спавне энтити из спавнменю
    WeaponOwners_TR[ent] = ply
end)
hook.Add("PlayerSpawnedNPC", "SavingOwnerNPC", function(ply,ent) -- Тот самый хук который берет создателя при спавне энтити из спавнменю
    NPCOwners_TR[ent] = ply
end)
hook.Add("PlayerSpawnedVehicle", "SavingOwnerVehicle", function(ply,ent) -- Тот самый хук который берет создателя при спавне энтити из спавнменю
    VEHICLEOwners_TR[ent] = ply
end)

NPC_NameOld_TR = NULL
NPC_NameWeapon_TR = NULL
NPC_NameWeapon_from_Player_TR = NULL
hook.Add("PlayerSpawnNPC", "GetInfoNPC", function(ply,npc_type,weapon)
    NPC_NameOld_TR = npc_type
    NPC_NameWeapon_TR = weapon
    NPC_NameWeapon_from_Player_TR = GetConVar("gmod_npcweapon"):GetString()
    -- print(NPC_NameWeapon_from_Player_TR)
end)

local allWeapons = list.Get("Weapon") -- Получает весь список энтити из спавнменю которое есть в игре (И даже недоступные для спавна)
local allRandomWeapons = {} -- Списко для Всех случайных оружий(отфильрованный)

if SERVER then -- Пусть сначала инициализируются оружия, так как код на добавление списка оружия запускается первее чем будут активны энтити
    hook.Add("Initialize", "ShowWeaponList", function()
        allWeapons = list.Get("Weapon")
        for k, v in pairs(allWeapons) do
            if v.Spawnable then
                table.insert(allRandomWeapons, k)
            end
        end
    end)
end

local allNPCWeapons = list.Get("NPCUsableWeapons") -- Получает весь список энтити из спавнменю которое есть в игре (И даже недоступные для спавна)
local allNPCWeapons_Random = {} -- Списко для Всех случайных оружий
local allNPC = list.Get("NPC") -- Получает весь список энтити из спавнменю которое есть в игре (И даже недоступные для спавна)

local allSpawnableEntities = list.Get("SpawnableEntities") -- Получает весь список энтити из спавнменю которое есть в игре (И даже недоступные для спавна)
local allRandomEntities = {} -- Списко для Всех случайных оружий
local allVEHICLE = list.Get("Vehicles") -- Получает весь список энтити из спавнменю которое есть в игре (И даже недоступные для спавна)

timer.Simple(0.6, function() -- Требуется время на загрузку всех или большинства энтити
    allNPC = list.Get("NPC")
    allNPCWeapons = list.Get("NPCUsableWeapons")
    allSpawnableEntities = list.Get("SpawnableEntities")
    allVEHICLE = list.Get("Vehicles")
end)

if SERVER then -- Пусть сначала инициализируются энтити и все остальное, так как код на добавление списка запускается первее чем будут активны энтити
    hook.Add("Initialize", "ShowLists", function()
        allNPC = list.Get("NPC")
        allNPCWeapons = list.Get("NPCUsableWeapons")
        allSpawnableEntities = list.Get("SpawnableEntities")
        for k, v in pairs(allSpawnableEntities) do
            table.insert(allRandomEntities, k)
        end
        allVEHICLE = list.Get("Vehicles") -- Получает весь список энтити из спавнменю которое есть в игре (И даже недоступные для спавна)
        for key, value in pairs(allNPC) do
            local Class_npc = value["Class"]
        end
        
        for k, v in pairs(allNPCWeapons) do
            local weaponClass = v.class
            table.insert(allNPCWeapons_Random, weaponClass)
        end
    end)
end


-- Replace Weapons
hook.Add( "WeaponEquip", "WeaponReplaced", function( weapon, ply )
    -- local ammoType = weapon:GetMaxClip1()
    -- print(ammoType)
    if GetConVar("tr_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена
    if GetConVar("tr_weapon_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена
    if GetConVar("tr_weapon_alternative_enable"):GetBool() == true then return end 
    if not table.HasValue(weaponList, weapon:GetClass()) then return end -- Нужно чтобы код не выполнялся если нет нужного энтити
    ------------------------ Общее

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
                    local current_weapon = list_weapon[math.random(#list_weapon)]

                    if current_weapon == nil and GetConVar("tr_enable_randomize_weapons"):GetBool() == true then
                        current_weapon = randomWeapon_table
                    end
                    local dataString = current_weapon
                    if dataString == nil then
                        dataString = "clear:100"
                    end
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
                        if newWeapon != "clear" then
                            local newWeapon_info = ents.Create(name_weapon)
                            local ammoClip = newWeapon_info:GetMaxClip1()
                            ammoClip = ammoClip * GetConVar("tr_weapon_give_ammo_mult"):GetInt()
                            local ammoType = newWeapon_info:GetPrimaryAmmoType()
                            local ammoType_ready = game.GetAmmoName(ammoType)
                            ply:StripWeapon(CheckedWeapon_TR())
                            if ply:HasWeapon(newWeapon) then
                                ply:GiveAmmo(ammoClip, ammoType_ready)
                            end
                            ply:Give(newWeapon)
                        end
                        break
                    else
                        -- В противном случае, продолжаем выполнение цикла
                    end
                end
            end
        end)
    end
end)

hook.Add("EntityTakeDamage", "TR_WhenNPCDieAlternative", function(target, dmginfo)
    if GetConVar("tr_enable"):GetBool() == false then return end
    if GetConVar("tr_weapon_enable"):GetBool() == false then return end 
    if GetConVar("tr_weapon_alternative_enable"):GetBool() == false then return end 
    
    if IsValid(target) and target:IsNPC() then
        if target:Health() - dmginfo:GetDamage() <= 0 then
            if not table.HasValue(weaponList, target:GetActiveWeapon():GetClass()) then return end -- Нужно чтобы код не выполнялся если нет нужного энтити
            
            local npc_droped_weapon = target:GetActiveWeapon()
            local function CheckedWeapon_TR(searched_weapon) 
                local nameEnts = target:GetActiveWeapon():GetClass()
                local targetString = nameEnts
            
                -- Флаг для отслеживания, была ли найдена нужная строка
                local stringFound = false
                -- Перебор списка строк и поиск нужной строки
                for _, str in pairs(weaponList) do
                    if str == targetString then
                        stringFound = true
                        searched_weapon = targetString
                        return searched_weapon
                    end
                end
            end
        
            ------ Функиции для чтения с разных таблиц из папки data
            local function ReadItemsFile_TR_weapon(target, ply)
                local content = file.Read("total_weapon_replacer/"..npc_droped_weapon:GetClass().. ".txt", "DATA")
                if content then
                    return util.JSONToTable(content) or {}
                else
                    return {}
                end
            end

            while true do
                ---- Перебор, преобразование строк в нужный формат
                local randomWeapon_table = allRandomWeapons[math.random(#allRandomWeapons)] 
                local list_weapon = ReadItemsFile_TR_weapon(npc_droped_weapon)
                local current_weapon = list_weapon[math.random(#list_weapon)]
                if current_weapon == nil and GetConVar("tr_enable_randomize_weapons"):GetBool() == true then
                    current_weapon = randomWeapon_table
                end
                ---- Обработка строки: запись выглядит примерно так: "sent_ball:100". sent_ball - имя энтити
                ---- и 100 - шанс выпадения. Двоиточие разделяет. Но без обработки она как одна строка.
                ---- Дальше идет разделение с условием. Результаты в name_weapon и chance_weapon. Если только имя 
                ---- То просто имя будет и все
                local dataString = current_weapon
                if dataString == nil then
                    dataString = "clear:100"
                end
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
                    if name_weapon != "clear" then
                        local newWeapon = ents.Create(name_weapon)
                        local owner = WeaponOwners_TR[npc_droped_weapon]
                        newWeapon:SetPos(npc_droped_weapon:GetPos())
                        newWeapon:SetAngles(npc_droped_weapon:GetAngles())
                        newWeapon:Spawn()
                        newWeapon:Activate()
                        -- newWeapon:SetOwner(owner)
                        npc_droped_weapon:Remove() -- удаляем энтити
                        
                        local nameEnts = newWeapon:GetClass() -- Преобразование в название энтити
                        local undoName = "Replaced Weapon: "..nameEnts -- Удаляемое имя и конкретное название энтити
                        undo.Create(undoName) -- Все для работы с Undo и соответсвенно с Z клавишей
                        undo.AddEntity(newWeapon) -- Все для работы с Undo и соответсвенно с Z клавишей
                        undo.SetPlayer(owner) -- Присваивание игроку предмет
                        undo.Finish() -- Наконец можно удалить этот энтити. Не зря ебался с этой хуйней
                    end
                    break
                else
                    -- В противном случае, продолжаем выполнение цикла
                end
            end
            -- print(target:GetActiveWeapon():GetClass())
        end
    end
    
end)
hook.Add("OnEntityCreated", "ReplacingWeaponAlternative", function(ent) -- При создании энтити тотально проверяет а также заполняет таблицы со всеми энтити(пока только из вкладки Энтити)
    if GetConVar("tr_enable"):GetBool() == false then return end
    if GetConVar("tr_weapon_enable"):GetBool() == false then return end 
    if GetConVar("tr_weapon_alternative_enable"):GetBool() == false then return end 
    
    if not table.HasValue(weaponList, ent:GetClass()) then return end -- Нужно чтобы код не выполнялся если нет нужного энтити
            ------------------------ Общее
        -- Функция нужна для определия, есть ли из списка weaponList то, что заспавнилось
        local function CheckedWeapon_TR(searched_weapon) 
            local nameEnts = ent:GetClass()
            local targetString = nameEnts
    
            -- Флаг для отслеживания, была ли найдена нужная строка
            local stringFound = false
            -- Перебор списка строк и поиск нужной строки
            for _, str in pairs(weaponList) do
                if str == targetString then
                    stringFound = true
                    searched_weapon = targetString
                    return searched_weapon
                end
            end
        end
    
    ------ Функиции для чтения с разных таблиц из папки data
    local function ReadItemsFile_TR_weapon(ent, ply)
        local content = file.Read("total_weapon_replacer/"..ent:GetClass().. ".txt", "DATA")
        if content then
            return util.JSONToTable(content) or {}
        else
            return {}
        end
    end

    -- Функция замены энтити при спавне, а также выдача прав с возможностью удаления с помощью Z если было заспавнено через спавнменю
    local function ReplacingWeapon_TR(ent)
        if ent:IsWeapon() then -- Ничто кроме из вкладки weapon 
            -- Без таймера хрен заработает
            timer.Simple(0.0001, function()
                if IsValid(ent) and CheckedWeapon_TR(searched_weapon) then
                    local owner_NPC = ent:GetOwner()
                    if not owner_NPC:IsNPC() then
                        while true do
                            ---- Перебор, преобразование строк в нужный формат
                            local randomWeapon_table = allRandomWeapons[math.random(#allRandomWeapons)] 
                            local list_weapon = ReadItemsFile_TR_weapon(ent)
                            local current_weapon = list_weapon[math.random(#list_weapon)]
                            if current_weapon == nil and GetConVar("tr_enable_randomize_weapons"):GetBool() == true then
                                current_weapon = randomWeapon_table
                            end
                            ---- Обработка строки: запись выглядит примерно так: "sent_ball:100". sent_ball - имя энтити
                            ---- и 100 - шанс выпадения. Двоиточие разделяет. Но без обработки она как одна строка.
                            ---- Дальше идет разделение с условием. Результаты в name_weapon и chance_weapon. Если только имя 
                            ---- То просто имя будет и все
                            local dataString = current_weapon
                            if dataString == nil then
                                dataString = "clear:100"
                            end
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
                                if name_weapon != "clear" then
                                    local newWeapon = ents.Create(name_weapon)
                                    local owner = WeaponOwners_TR[ent]
                                    newWeapon:SetPos(ent:GetPos())
                                    newWeapon:SetAngles(ent:GetAngles())
                                    newWeapon:Spawn()
                                    newWeapon:Activate()
                                    -- newWeapon:SetOwner(owner)
                                    ent:Remove() -- удаляем энтити
                                    
                                    local nameEnts = newWeapon:GetClass() -- Преобразование в название энтити
                                    local undoName = "Replaced Weapon: "..nameEnts -- Удаляемое имя и конкретное название энтити
                                    undo.Create(undoName) -- Все для работы с Undo и соответсвенно с Z клавишей
                                    undo.AddEntity(newWeapon) -- Все для работы с Undo и соответсвенно с Z клавишей
                                    undo.SetPlayer(owner) -- Присваивание игроку предмет
                                    undo.Finish() -- Наконец можно удалить этот энтити. Не зря ебался с этой хуйней
                                end
                                break
                            else
                                -- В противном случае, продолжаем выполнение цикла
                            end
                        end
                    end
                end
            end)
        end
    end
    -- Проверка того, что энтити есть в списке Заменяемых а также разрешено ли заменять его
        if CheckedWeapon_TR() and GetConVar("tr_"..ent:GetClass()):GetBool() == true then
            ReplacingWeapon_TR(ent)
        end
end)

hook.Add("OnEntityCreated", "ReplacingNPCWeapons", function(ent)
    if GetConVar("tr_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена       
    if GetConVar("tr_npc_weapons_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена
    -- if not table.HasValue(weaponList, ent:GetActiveWeapon()) then return end -- Нужно чтобы код не выполнялся если нет нужного энтити
    
    local function ReadItemsFile_TR_npcweapon(npc_hold_weapon)
        local content = file.Read("total_npcweapons_replacer/"..npc_hold_weapon.. ".txt", "DATA")
        if content then
            return util.JSONToTable(content) or {}
        else
            return {}
        end
    end

    local function ReplacingNPC_TR()
        timer.Simple(0.011, function()
            if ent:IsNPC() and IsValid(ent) then -- Ничто кроме NPC
            local weapon_NPC_active = ent:GetActiveWeapon()
            local weapon_NPC_active_class = ""
            if weapon_NPC_active != NULL then
                weapon_NPC_active_class = ent:GetActiveWeapon():GetClass()
                -- print(weapon_NPC_active_class)
            end
            while true do
                local ContentNPC_weapon = ReadItemsFile_TR_npcweapon(weapon_NPC_active_class)
                local ContentNPC_weapon_Choosed = ContentNPC_weapon[math.random(#ContentNPC_weapon)]
                
                    -- print(ContentNPC_weapon_Choosed)
                    local npc_pattern = "([^:]+):([^:]+)"
                    local weapon_npc, chance_npc_str = nil, nil
                    if ContentNPC_weapon_Choosed != nil then
                        weapon_npc, chance_npc_str  = string.match(ContentNPC_weapon_Choosed, npc_pattern)
                    end
                    -- print(ContentNPC_weapon_Choosed)
                    if SERVER then
                        if weapon_npc == nil and GetConVar("tr_enable_randomize_npc_weapons"):GetBool() == true then
                            ContentNPC_weapon_Choosed = allNPCWeapons_Random[math.random(#allNPCWeapons_Random)]
                            -- print(ContentNPC_weapon_Choosed)
                        end
                    end
                    local chance = math.random(1, 100)
                    local chance_npc = 100
                    if chance_npc_str != nil then
                        chance_npc = tonumber(chance_npc_str)
                    end
                    if chance <= chance_npc then
                        -- print(weapon_npc)
                        if SERVER and weapon_NPC_active != NULL and ContentNPC_weapon_Choosed != nil and weapon_npc != nil and GetConVar("tr_npc_weapon_"..weapon_NPC_active_class):GetBool() == true then
                            weapon_NPC_active:Remove()
                            ent:Give(weapon_npc)
                        end
                        break
                    else

                    end
                    -- И тем самым не завис GMOD
                end
            end
        end)
    end
    ReplacingNPC_TR()
end)


local function ReadItemsFile_TR_anything(ANY_NameOld_TR, ANY_NameFolder_TR)
    local content = file.Read("total_"..ANY_NameFolder_TR.."_replacer/"..ANY_NameOld_TR.. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
end


hook.Add("OnEntityCreated", "ReplacingModelNPC", function(ent)
    if CLIENT then return end
    if GetConVar("tr_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена       
    if GetConVar("tr_npc_models_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена
    
    local function ReplacingModelNPC(ent)
        if ent:IsNPC() and IsValid(ent) then -- Ничто кроме NPC
            timer.Simple(0.1, function()
                local current_model_NPC = ent:GetModel()
                local current_model_NPC_ready = string.gsub(current_model_NPC, "/", "_")
                
                local conVarName = "tr_npc_model_" .. current_model_NPC_ready .. ".txt"
                local conVar = GetConVar(conVarName)

                -- Проверяем, существует ли консольная переменная
                if conVar ~= nil then
                    -- Проверяем значение консольной переменной
                    if conVar:GetBool() == false then
                        return
                    end
                else
                end

                -- if GetConVar("tr_npc_model_"..current_model_NPC_ready..".txt"):GetBool() == false then return end
                local list_NPCModel = ReadItemsFile_TR_anything(current_model_NPC_ready, "npcmodels")
                if table.IsEmpty(list_NPCModel) then return end

                if IsValid(ent) and not ent:GetOwner():IsPlayer() and not ent:GetOwner():IsNPC() and ent:GetNW2Bool("IsReplacedModel") != true then
                    while true do
                        ---- Перебор, преобразование строк в нужный формат
                        -- print(current_model_NPC_ready)
                        local choosed_NPCModel = list_NPCModel[math.random(#list_NPCModel)]

                        local dataString = choosed_NPCModel
                        if dataString == nil then
                            dataString = "clear:100"
                        end

                        local chance_NPCModel = 100
                        local npcmodels_pattern = "([^:]+):([^:]+):([^:]+)"
                        local name_NPCModel, chance_NPCModel, skin_NPCModel = nil, nil, nil
                        if choosed_NPCModel != nil then
                            name_NPCModel, chance_NPCModel, skin_NPCModel = string.match(choosed_NPCModel, npcmodels_pattern)
                        end
                        if chance_NPCModel != nil then 
                            chance_NPCModel = tonumber(chance_NPCModel)
                        end
                        ------------------- Шанс
                        local chance = math.random(1, 100)
                        if chance <= chance_NPCModel then
                            if name_NPCModel != "clear" then
                                ent:SetModel(name_NPCModel)
                            end
                            ent:SetNW2Bool("IsReplacedModel", true)
                            break
                        else
                            -- В противном случае, продолжаем выполнение цикла
                        end
                    end
                end
            end)
        end
    end
    ReplacingModelNPC(ent)
end)


hook.Add("OnEntityCreated", "ReplacingNPC", function(ent)
    if CLIENT then return end
    if GetConVar("tr_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена       
    if GetConVar("tr_npc_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена 
    ------ Функиции для чтения с разных таблиц из папки data
    local function ReadItemsFile_TR_npc(NPC_NameOld_TR, ply)
        local content = file.Read("total_npc_replacer/"..NPC_NameOld_TR.. ".txt", "DATA")
        if content then
            return util.JSONToTable(content) or {}
        else
            return {}
        end
    end

    -- Функция замены энтити при спавне, а также выдача прав с возможностью удаления с помощью Z если было заспавнено через спавнменю
    local function ReplacingNPC_TR(ent)
        if ent:IsNPC() and IsValid(ent) then -- Ничто кроме NPC
            -- Без таймера хрен заработает
            timer.Simple(0.1, function()
                if IsValid(ent) and not ent:GetOwner():IsPlayer() and not ent:GetOwner():IsNPC() and ent:GetNW2Bool("IsReplaced") != true then
                    local Name_NPC_Spawnmenu = NULL
                    local namehummer = ent:GetName()
                        if ent:GetClass() == "npc_citizen" then
                            for _, v in pairs(rebels_models) do
                                local Model_name_NPC = ent:GetModel()
                                 if Model_name_NPC == v then
                                    ent:SetNW2String("Spawnmenu_name", "Rebel")
                                    break
                                 end
                             end

                             for _, v in pairs(citizen_models) do
                                local Model_name_NPC = ent:GetModel()
                                 if Model_name_NPC == v then
                                    ent:SetNW2String("Spawnmenu_name", "npc_citizen")
                                    break
                                 end
                             end

                             for _, v in pairs(refugee_models) do
                                local Model_name_NPC = ent:GetModel()
                                 if Model_name_NPC == v then
                                    ent:SetNW2String("Spawnmenu_name", "Refugee")
                                    break
                                 end
                             end
                             for _, v in pairs(medic_models) do
                                local Model_name_NPC = ent:GetModel()
                                 if Model_name_NPC == v then
                                    ent:SetNW2String("Spawnmenu_name", "Medic")
                                    break
                                 end
                             end
                             if ent:GetModel() == "models/odessa.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_odessa")
                             end
                        end

                        if ent:GetClass() == "npc_vortigaunt" then
                            local Model_name_NPC = ent:GetModel()
                            -- print(Model_name_NPC)
                            if Model_name_NPC == "models/vortigaunt_slave.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "VortigauntSlave")
                            end
                            if Model_name_NPC == "models/vortigaunt.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_vortigaunt")
                            end
                        end
                        if ent:GetClass() == "npc_combine_s" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/combine_super_soldier.mdl" then
                               ent:SetNW2String("Spawnmenu_name", "CombineElite")
                            end
                            if Model_name_NPC == "models/combine_soldier_prisonguard.mdl" and ent:GetSkin() == 0 then
                                ent:SetNW2String("Spawnmenu_name", "CombinePrison")
                            end
                            if Model_name_NPC == "models/combine_soldier_prisonguard.mdl" and ent:GetSkin() == 1 then
                                ent:SetNW2String("Spawnmenu_name", "PrisonShotgunner")
                            end
                            if Model_name_NPC == "models/combine_soldier.mdl" and ent:GetSkin() == 1 then
                                ent:SetNW2String("Spawnmenu_name", "ShotgunSoldier")
                            end
                            if Model_name_NPC == "models/combine_soldier.mdl" and ent:GetSkin() == 0 then
                                ent:SetNW2String("Spawnmenu_name", "npc_combine_s")
                            end
                        end
                        if ent:GetClass() == "npc_headcrab" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/headcrabclassic.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_headcrab")
                            end
                        end
                        if ent:GetClass() == "npc_headcrab_black" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/headcrabblack.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_headcrab_black")
                            end
                        end
                        if ent:GetClass() == "npc_headcrab_fast" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/headcrab.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_headcrab_fast")
                            end
                        end
                        if ent:GetClass() == "npc_metropolice" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/police.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_metropolice")
                            end
                        end
                        if ent:GetClass() == "npc_poisonzombie" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/zombie/poison.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_poisonzombie")
                            end
                        end
                        if ent:GetClass() == "npc_zombie" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/zombie/classic.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_zombie")
                            end
                        end
                        if ent:GetClass() == "npc_antlionguard" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/antlion_guard.mdl" and ent:GetSkin() == 0 then
                                ent:SetNW2String("Spawnmenu_name", "npc_antlionguard")
                            end
                        end
                        if ent:GetClass() == "npc_antlion" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/antlion.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_antlion")
                            end
                        end
                        if ent:GetClass() == "npc_fastzombie" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/zombie/fast.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_fastzombie")
                            end
                        end
                        if ent:GetClass() == "npc_fastzombie_torso" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/zombie/fast_torso.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_fastzombie_torso")
                            end
                        end
                        if ent:GetClass() == "npc_zombie_torso" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/zombie/classic_torso.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_zombie_torso")
                            end
                        end

                        if ent:GetClass() == "npc_alyx" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/alyx.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_alyx")
                            end
                        end
                        if ent:GetClass() == "npc_barney" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/barney.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_barney")
                            end
                        end
                        if ent:GetClass() == "npc_breen" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/breen.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_breen")
                            end
                        end
                        if ent:GetClass() == "npc_dog" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/dog.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_dog")
                            end
                        end
                        if ent:GetClass() == "npc_gman" then
                            local Model_name_NPC = ent:GetModel()
                            -- print(Model_name_NPC)
                            if Model_name_NPC == "models/gman.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_gman")
                            end
                        end
                        if ent:GetClass() == "npc_eli" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/eli.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_eli")
                            end
                        end
                        if ent:GetClass() == "npc_gman" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/gman.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_gman")
                            end
                        end
                        if ent:GetClass() == "npc_kleiner" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/kleiner.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_kleiner")
                            end
                        end
                        if ent:GetClass() == "npc_mossman" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/mossman.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_mossman")
                            end
                        end
                        if ent:GetClass() == "npc_clawscanner" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/shield_scanner.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_clawscanner")
                            end
                        end
                        if ent:GetClass() == "npc_combine_camera" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/combine_camera/combine_camera.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_combine_camera")
                            end
                        end
                        if ent:GetClass() == "npc_combinedropship" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/combine_dropship.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_combinedropship")
                            end
                        end
                        if ent:GetClass() == "npc_combinegunship" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/gunship.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_combinegunship")
                            end
                        end
                        if ent:GetClass() == "npc_cscanner" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/combine_scanner.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_cscanner")
                            end
                        end
                        if ent:GetClass() == "npc_helicopter" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/combine_helicopter.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_helicopter")
                            end
                        end
                        if ent:GetClass() == "npc_manhack" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/manhack.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_manhack")
                            end
                        end
                        if ent:GetClass() == "npc_rollermine" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/roller.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_rollermine")
                            end
                        end
                        if ent:GetClass() == "npc_stalker" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/stalker.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_stalker")
                            end
                        end
                        if ent:GetClass() == "npc_strider" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/combine_strider.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_strider")
                            end
                        end
                        if ent:GetClass() == "npc_turret_ceiling" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/combine_turrets/ceiling_turret.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_turret_ceiling")
                            end
                        end
                        if ent:GetClass() == "npc_turret_floor" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/combine_turrets/floor_turret.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_turret_floor")
                            end
                        end
                        if ent:GetClass() == "npc_crow" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/crow.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_crow")
                            end
                        end
                        if ent:GetClass() == "npc_monk" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/monk.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_monk")
                            end
                        end
                        if ent:GetClass() == "npc_pigeon" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/pigeon.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_pigeon")
                            end
                        end
                        if ent:GetClass() == "npc_seagull" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/seagull.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_seagull")
                            end
                        end

                        -- HL2 Episode 2
                        if ent:GetClass() == "npc_hunter" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/hunter.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_hunter")
                            end
                        end
                        if ent:GetClass() == "npc_antlion_grub" then
                                ent:SetNW2String("Spawnmenu_name", "npc_antlion_grub")
                        end
                        if ent:GetClass() == "npc_antlion_worker" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/antlion_worker.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_antlion_worker")
                            end
                        end
                        if ent:GetClass() == "npc_antlionguard" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/antlion_guard.mdl" and ent:GetSkin() == 1  then
                                ent:SetNW2String("Spawnmenu_name", "npc_antlionguardian")
                            end
                        end
                        if ent:GetClass() == "npc_antlion_grub" then
                            ent:SetNW2String("Spawnmenu_name", "npc_antlionguardian")
                        end

                        -- HL2 Episode 1
                        if ent:GetClass() == "npc_zombine" then
                            local Model_name_NPC = ent:GetModel()
                            if Model_name_NPC == "models/zombie/zombie_soldier.mdl" then
                                ent:SetNW2String("Spawnmenu_name", "npc_antlionguardian")
                            end
                        end
                        -- print(ent:GetNW2String("Spawnmenu_name"))
                        



                    local Name_NPC = ""
                    local Class_NPC = ""
                    local Weapons_NPC = ""
                    local keyValues_NPC = {}
                    local Model_NPC = ""
                    local SpawnFlags_NPC = ""
                    local Skin_NPC = 0
                    local OffSet_NPC = 0
                    local Spawnmenu_name_NPC = ""
                    for key, value in pairs(allNPC) do
                        if key == ent:GetNW2String("Spawnmenu_name") then
                            Spawnmenu_name_NPC = key
                            break
                        end
                    end
                    while true do
                        local ContentNPC = ReadItemsFile_TR_npc(Spawnmenu_name_NPC)
                        local ContentNPC_Choosed = ContentNPC[math.random(#ContentNPC)]

                        -- local npc_pattern = "([^:]+):([^:]+):([^:]+)"
                        -- local npc_name, chance_npc_str, weapon_npc = nil, nil, nil
                        local npc_pattern = "([^:]+):([^:]+):([^:]+):([^:]+):([^:]+):([^:]+)"
                        local npc_name, chance_npc_str, weapon_npc, health_npc, model_npc, skin_npc = nil, nil, nil, nil, nil, nil
                        if ContentNPC_Choosed != nil then
                            npc_name, chance_npc_str, weapon_npc, health_npc, model_npc, skin_npc = string.match(ContentNPC_Choosed, npc_pattern)
                        end
                        for key, value in pairs(allNPC) do
                            if key == npc_name then
                                if value.Class then
                                    Class_NPC = value.Class
                                end
                                if value.Name then
                                    Name_NPC = value.Name
                                end
                                if value.Weapons and weapon_npc == "standart" then
                                    Weapons_NPC = value.Weapons[math.random(#value.Weapons)]
                                end
                                if weapon_npc != "standart" and weapon_npc != "" then
                                    Weapons_NPC = weapon_npc
                                end
                                    if value.KeyValues then
                                        for key, value in pairs(value.KeyValues) do
                                            keyValues_NPC[key] = value
                                        end
                                    end
                                if value.Model then
                                    Model_NPC = value.Model
                                end
                                if value.SpawnFlags then
                                    SpawnFlags_NPC = value.SpawnFlags
                                end
                                if value.Offset then
                                    OffSet_NPC = value.Offset
                                end
                                if value.Skin then
                                    Skin_NPC = value.Skin
                                end
                                break
                            end
                        end
                        
                        for k, v in pairs(allNPCWeapons) do
                            local weaponClass = v.class
                        end
                        local RandNPC = allNPC[math.random(#allNPC)]
                        local RandomFromAllNPC = table.Random(allNPC)

                        local chance_npc = 100
                        if chance_npc_str != nil then
                            chance_npc = tonumber(chance_npc_str)
                        end
                        local weapon_NPC_active = ent:GetActiveWeapon()
                        local weapon_NPC_active_class = ""
                        if weapon_NPC_active != NULL then
                            weapon_NPC_active_class = ent:GetActiveWeapon():GetClass()
                        end
                        -- ------------------- Шанс
                        local chance = math.random(1, 100)
                        if chance <= chance_npc then
                            local name_NW2_NPC = ent:GetNW2String("Spawnmenu_name")
                            if Class_NPC != "" and ent:GetNW2Bool("IsReplaced") != true and table.HasValue(npcList, ent:GetNW2String("Spawnmenu_name")) and GetConVar("tr_"..name_NW2_NPC):GetBool() == true then
                                function ReplaceNPC_TR_and_Give_Weapon()
                                    local newNPC = ents.Create(Class_NPC) ---- Стандартная замена, если не было отфильтрованно
                                    local owner = NPCOwners_TR[ent]
                                    local onwer_is_player = nil
                                    local ConVar_Gmod_NPCWeapon = GetConVar("gmod_npcweapon")
                                    local ConVar_Gmod_NPCWeapon_string = nil
                                    if owner != nil then
                                        onwer_is_player = owner:IsPlayer()
                                    end
                                    if ConVar_Gmod_NPCWeapon != nil then
                                        ConVar_Gmod_NPCWeapon_string = GetConVar("gmod_npcweapon"):GetString()
                                    end
                                    newNPC:SetPos(ent:GetPos() + Vector(0, 0, 15))
                                    newNPC:SetAngles(ent:GetAngles())
                                    newNPC:SetNW2Bool("IsReplaced", true)

                                    if Name_NPC != "" then
                                        newNPC:SetName(Name_NPC)
                                    end

                                    if Weapons_NPC != "" and GetConVar("tr_npc_weapons_enable"):GetBool() == false then
                                        newNPC:Give(Weapons_NPC)
                                        if ConVar_Gmod_NPCWeapon != nil and ConVar_Gmod_NPCWeapon_string != nil and onwer_is_player == true then
                                            local Weapon_NPC_spawnmenu = GetConVar("gmod_npcweapon"):GetString()
                                            newNPC:Give(Weapon_NPC_spawnmenu)
                                        end
                                    end
                                    if Weapons_NPC != "" and GetConVar("tr_npc_weapons_enable"):GetBool() == true then
                                        if weapon_NPC_active_class != "" then
                                            newNPC:Give(weapon_NPC_active_class)
                                        end
                                    end

                                    for key, value in pairs(keyValues_NPC) do
                                        newNPC:SetKeyValue(key, value)
                                    end
                                    if namehummer != "" then
                                        newNPC:SetName(namehummer)
                                    end


                                    if Skin_NPC != "" then
                                        newNPC:SetSkin(Skin_NPC)
                                    end
                                    if SpawnFlags_NPC != "" then
                                        newNPC:SetKeyValue("spawnflags",bit.bor(SpawnFlags_NPC))
                                    end
                                    newNPC:Spawn()
                                    if GetConVar("tr_npc_off_collision_enable"):GetBool() == true then                
                                        newNPC:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                                        timer.Simple( GetConVar("tr_npc_off_collision_time"):GetFloat(), function()
                                            if IsValid(newNPC) then
                                                newNPC:SetCollisionGroup(COLLISION_GROUP_NPC)
                                            end
                                        end)
                                    end
                                    newNPC:Activate()
                                    if Model_NPC != "" then
                                        newNPC:SetModel(Model_NPC)
                                    end
                                    if model_npc != "reg" then
                                        newNPC:SetModel(model_npc)
                                    end
                                    if health_npc != "reg" then
                                        newNPC:SetHealth(health_npc)
                                    end
                                    if skin_npc != "reg" then
                                        newNPC:SetSkin(skin_npc)
                                    end

                                    local nameEnts = newNPC:GetClass() -- Преобразование в название энтити
                                    local undoName = "Replaced NPC: "..nameEnts -- Удаляемое имя и конкретное название энтити
                                    undo.Create(undoName) -- Все для работы с Undo и соответсвенно с Z клавишей
                                    undo.AddEntity(newNPC) -- Все для работы с Undo и соответсвенно с Z клавишей
                                    undo.SetPlayer(owner) -- Присваивание игроку предмет
                                    undo.Finish() -- Наконец можно удалить этот энтити. Не зря ебался с этой хуйней
                                    ent:Remove() -- удаляем энтити
                                end
                                ReplaceNPC_TR_and_Give_Weapon()
                                break
                            else
                                break -- Это нужно для того чтобы в бесконечный цикл не ушел,
                                -- И тем самым не завис GMOD
                            end
                        end
                    end
                end
            end)
            
        end
    end
    ReplacingNPC_TR(ent)
end)


hook.Add("OnEntityCreated", "ReplacingEntity", function(ent) -- При создании энтити тотально проверяет а также заполняет таблицы со всеми энтити(пока только из вкладки Энтити)
    if GetConVar("tr_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена
    if GetConVar("tr_entity_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена
    if not table.HasValue(entityList, ent:GetClass()) then return end -- Нужно чтобы код не выполнялся если нет нужного энтити
            ------------------------ Общее
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
        if not ent:IsNPC() and not ent:IsWeapon() and not ent:IsVehicle() then -- Ничто кроме из вкладки entity 
            -- Без таймера хрен заработает
            timer.Simple(0.0001, function()
                if IsValid(ent) and CheckedEntity_TR(searched_entity) and not ent:GetOwner():IsPlayer()then
                    while true do
                        ---- Перебор, преобразование строк в нужный формат
                        local randomEntity_table = allRandomEntities[math.random(#allRandomEntities)] 
                        local list_entity = ReadItemsFile_TR_entity(ent)
                        local current_entity = list_entity[math.random(#list_entity)]
                        if current_entity == nil and GetConVar("tr_enable_randomize_entities"):GetBool() == true then
                            current_entity = randomEntity_table
                        end
                        ---- Обработка строки: запись выглядит примерно так: "sent_ball:100". sent_ball - имя энтити
                        ---- и 100 - шанс выпадения. Двоиточие разделяет. Но без обработки она как одна строка.
                        ---- Дальше идет разделение с условием. Результаты в name_entity и chance_entity. Если только имя 
                        ---- То просто имя будет и все
                        local dataString = current_entity
                        if dataString == nil then
                            dataString = "clear:100"
                        end
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
                            if name_entity != "clear" then
                                local newEntity = ents.Create(name_entity)
                                local owner = EntityOwners_TR[ent]
                                newEntity:SetPos(ent:GetPos())
                                newEntity:SetAngles(ent:GetAngles())
                                newEntity:Spawn()
                                newEntity:Activate()
                                newEntity:SetOwner(owner)
                                ent:Remove() -- удаляем энтити
                                
                                local nameEnts = newEntity:GetClass() -- Преобразование в название энтити
                                local undoName = "Replaced Entity: "..nameEnts -- Удаляемое имя и конкретное название энтити
                                undo.Create(undoName) -- Все для работы с Undo и соответсвенно с Z клавишей
                                undo.AddEntity(newEntity) -- Все для работы с Undo и соответсвенно с Z клавишей
                                undo.SetPlayer(owner) -- Присваивание игроку предмет
                                undo.Finish() -- Наконец можно удалить этот энтити. Не зря ебался с этой хуйней
                            end
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

hook.Add("OnEntityCreated", "ReplacingVEHICLE", function(ent)
    if GetConVar("tr_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена       
    if GetConVar("tr_vehicle_enable"):GetBool() == false then return end -- Не врублена замена, значит не будет выполнена 
    ------ Функиции для чтения с разных таблиц из папки data
    local function ReadItemsFile_TR_vehicle(VEHICLE_NameOld_TR, ply)
        local content = file.Read("total_vehicle_replacer/"..VEHICLE_NameOld_TR.. ".txt", "DATA")
        if content then
            return util.JSONToTable(content) or {}
        else
            return {}
        end
    end
    -- Функция замены энтити при спавне, а также выдача прав с возможностью удаления с помощью Z если было заспавнено через спавнменю
    local function ReplacingVEHICLE_TR(ent)
        if ent:IsVehicle() and IsValid(ent) then -- Ничто кроме VEHICLE
            -- Без таймера хрен заработает
            timer.Simple(0.01, function()
                if IsValid(ent) and not ent:GetOwner():IsPlayer() and not ent:GetOwner():IsVehicle() and ent:GetNW2Bool("IsReplaced") != true then
                    local Model_name_Vehicle = ent:GetModel()
                    -- print(ent:GetClass())
                    if Model_name_Vehicle == "models/buggy.mdl" and ent:GetClass() == "prop_vehicle_jeep" then
                        -- print("Buggy")
                        ent:SetNW2String("Spawnmenu_name", "Jeep")
                    end
                    if Model_name_Vehicle == "models/airboat.mdl" and ent:GetClass() == "prop_vehicle_airboat" then
                        ent:SetNW2String("Spawnmenu_name", "Airboat")
                    end
                    -- print(ent:GetModel())
                    if Model_name_Vehicle == "models/vehicle.mdl" and ent:GetClass() == "prop_vehicle_jeep" then
                        ent:SetNW2String("Spawnmenu_name", "Jalopy")
                    end
                    local Name_VEHICLE = ""
                    local Class_VEHICLE = ""
                    local keyValues_VEHICLE = {}
                    local Model_VEHICLE = ""
                    local SpawnFlags_VEHICLE = ""
                    local Skin_VEHICLE = 0
                    local OffSet_VEHICLE = 0
                    local Spawnmenu_name_VEHICLE = ""
                    for key, value in pairs(allVEHICLE) do
                        if key == ent:GetNW2String("Spawnmenu_name") then
                            Spawnmenu_name_VEHICLE = key
                            break
                        end
                    end

                    while true do
                        local ContentVEHICLE = ReadItemsFile_TR_vehicle(Spawnmenu_name_VEHICLE)
                        local ContentVEHICLE_Choosed = ContentVEHICLE[math.random(#ContentVEHICLE)]

                        local vehicle_pattern = "([^:]+):([^:]+)"
                        local vehicle_name, chance_vehicle_str = nil, nil
                        if ContentVEHICLE_Choosed != nil then
                            vehicle_name, chance_vehicle_str = string.match(ContentVEHICLE_Choosed, vehicle_pattern)
                        end
                        for key, value in pairs(allVEHICLE) do
                            if key == vehicle_name then
                                if value.Class then
                                    Class_VEHICLE = value.Class
                                end
                                if value.Name then
                                    Name_VEHICLE = value.Name
                                end
                                if value.Weapons and weapon_vehicle == "standart" then
                                    Weapons_VEHICLE = value.Weapons[math.random(#value.Weapons)]
                                end
                                    if value.KeyValues then
                                        for key, value in pairs(value.KeyValues) do
                                            keyValues_VEHICLE[key] = value
                                        end
                                    end
                                if value.Model then
                                    Model_VEHICLE = value.Model
                                end
                                if value.SpawnFlags then
                                    SpawnFlags_VEHICLE = value.SpawnFlags
                                end
                                if value.Offset then
                                    OffSet_VEHICLE = value.Offset
                                end
                                if value.Skin then
                                    Skin_VEHICLE = value.Skin
                                end
                                break
                            end
                        end

                        local RandVEHICLE = allVEHICLE[math.random(#allVEHICLE)]
                        local RandomFromAllVEHICLE = table.Random(allVEHICLE)

                        local chance_vehicle = 100
                        if chance_vehicle_str != nil then
                            chance_vehicle = tonumber(chance_vehicle_str)
                        end
                        -- ------------------- Шанс
                        local chance = math.random(1, 100)
                        if chance <= chance_vehicle then
                            local name_NW2_VEHICLE = ent:GetNW2String("Spawnmenu_name")
                            if Class_VEHICLE != "" and ent:GetNW2Bool("IsReplaced") != true and table.HasValue(vehicleList, ent:GetNW2String("Spawnmenu_name")) and GetConVar("tr_"..name_NW2_VEHICLE):GetBool() == true then
                                local newVEHICLE = ents.Create(Class_VEHICLE) -- Стандартная замена, если не было отфильтрованно
                                local owner = VEHICLEOwners_TR[ent]
                                newVEHICLE:SetPos(ent:GetPos() + Vector(0, 0, 25))
                                newVEHICLE:SetAngles(ent:GetAngles())
                                newVEHICLE:SetNW2Bool("IsReplaced", true)

                                if Name_VEHICLE != "" then
                                    newVEHICLE:SetName(Name_VEHICLE)
                                end
                                for key, value in pairs(keyValues_VEHICLE) do
                                    newVEHICLE:SetKeyValue(key, value)
                                end
                                if Skin_VEHICLE != "" then
                                    newVEHICLE:SetSkin(Skin_VEHICLE)
                                end
                                if SpawnFlags_VEHICLE != "" then
                                    newVEHICLE:SetKeyValue("spawnflags",bit.bor(SpawnFlags_VEHICLE))
                                end
                                if Model_VEHICLE != "" then
                                    newVEHICLE:SetModel(Model_VEHICLE)
                                end
                                newVEHICLE:Spawn()
                                newVEHICLE:Activate()
                                local nameEnts = newVEHICLE:GetClass() -- Преобразование в название энтити
                                local undoName = "Replaced VEHICLE: "..nameEnts -- Удаляемое имя и конкретное название энтити
                                undo.Create(undoName) -- Все для работы с Undo и соответсвенно с Z клавишей
                                undo.AddEntity(newVEHICLE) -- Все для работы с Undo и соответсвенно с Z клавишей
                                undo.SetPlayer(owner) -- Присваивание игроку предмет
                                undo.Finish() -- Наконец можно удалить этот энтити. Не зря ебался с этой хуйней
                                ent:Remove() -- удаляем энтити
                                break
                            else
                                break -- Это нужно для того чтобы в бесконечный цикл не ушел,
                                -- И тем самым не завис GMOD
                            end
                        end
                    end
                end
            end)
            
        end
    end
    ReplacingVEHICLE_TR(ent)
end)