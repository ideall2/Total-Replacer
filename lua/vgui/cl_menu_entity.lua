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
    "Jeep",
    "Airboat",
    "Pod"
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
}

local function ReadItemsAndCreateConVarsTR(folderPath)
    local fileList = {}

    -- Получаем список файлов в указанной папке
    local files, _ = file.Find(folderPath .. "/*", "DATA")

    -- Проходимся по списку файлов и добавляем их в таблицу
    for _, fileName in ipairs(files) do
        table.insert(fileList, fileName)
    end

    return fileList
end

concommand.Add("tr_menu", function(ply, cmd, args)
    -- Функция для создания меню
    local function CreateMenu()
        local frame = vgui.Create("DFrame")
        frame:SetSize(300, 250)
        frame:SetTitle("Welcome to the Total Replacer.")
        frame:Center()

        local button1 = vgui.Create("DButton", frame)
        button1:SetPos(10, 30)
        button1:SetSize(280, 30)
        button1:SetText("Replace Entities")
        button1.DoClick = function()
            -- Здесь вы можете указать консольную команду для кнопки 1
            LocalPlayer():ConCommand("tr_entity_menu")
            frame:Close()
        end

        local button2 = vgui.Create("DButton", frame)
        button2:SetPos(10, 70)
        button2:SetSize(280, 30)
        button2:SetText("Replace NPCs")
        button2.DoClick = function()
            -- Здесь вы можете указать консольную команду для кнопки 2
            LocalPlayer():ConCommand("tr_npc_menu")
            frame:Close()
        end
        
        local button3 = vgui.Create("DButton", frame)
        button3:SetPos(10, 110)
        button3:SetSize(280, 30)
        button3:SetText("Replace NPCs Weapons")
        button3.DoClick = function()
            -- Здесь вы можете указать консольную команду для кнопки 2
            LocalPlayer():ConCommand("tr_npc_weapons_menu")
            frame:Close()
        end

        local button4 = vgui.Create("DButton", frame)
        button4:SetPos(10, 150)
        button4:SetSize(280, 30)
        button4:SetText("Replace Weapons")
        button4.DoClick = function()
            -- Здесь вы можете указать консольную команду для кнопки 3
            LocalPlayer():ConCommand("tr_weapon_menu")
            frame:Close()
        end

        local button5 = vgui.Create("DButton", frame)
        button5:SetPos(10, 190)
        button5:SetSize(280, 30)
        button5:SetText("Replace Vehicle")
        button5.DoClick = function()
            -- Здесь вы можете указать консольную команду для кнопки 4
            LocalPlayer():ConCommand("tr_vehicle_menu")
            frame:Close()
        end
        frame:MakePopup()
    end
    CreateMenu()
end)

local function TR_SettingsPanel_base(Panel)
    local openMenuButton = Panel:Button("Open TR")
    openMenuButton.DoClick = function()
        RunConsoleCommand("tr_menu")
    end
    Panel:Help("These columns are responsible for generally turning the TR on or off.")
    Panel:AddControl("CheckBox", {Label = "Enable Total Replacer", Command = "tr_enable"})
    Panel:AddControl("CheckBox", {Label = "Enable Total Replacer for Entities", Command = "tr_entity_enable"})
    Panel:AddControl("CheckBox", {Label = "Enable Total Replacer for NPCs", Command = "tr_npc_enable"})
    Panel:AddControl("CheckBox", {Label = "Enable Total Replacer for Weapons", Command = "tr_weapon_enable"})
    Panel:AddControl("CheckBox", {Label = "Enable Total Replacer for NPC Weapons", Command = "tr_npc_weapons_enable"})
    Panel:AddControl("CheckBox", {Label = "Enable Total Replacer for Vehicles", Command = "tr_vehicle_enable"})
    Panel:Help( "These modes enable a randomizer for unfilled entities or weapons. Unfortunately, I couldn't make randomizer for transportation and NPCs, because of the problem with names. In general, if you need randomization, then turn it on, if not, then unfilled intiti or weapons will NOT be replaced if they are not filled.")
    Panel:AddControl("CheckBox", {Label = "Enable Randomizer for empty lists in Weapons", Command = "tr_enable_randomize_weapons"})
    Panel:AddControl("CheckBox", {Label = "Enable Randomizer for empty lists in NPC Weapons", Command = "tr_enable_randomize_npc_weapons"})
    Panel:AddControl("CheckBox", {Label = "Enable Randomizer for empty lists in Entities", Command = "tr_enable_randomize_entities"})
    Panel:Help("Authors: IDEALL")
end

local function TR_SettingsPanel_weapons(Panel)
    Panel:Help("How much ammo should be given to a weapon if you pick up a weapon that is already in your inventory?")
    Panel:AddControl("Slider", {type = "float", Label = "Mult Clip Ammo", Command = "tr_weapon_give_ammo_mult", max = 10})
    Panel:Help("Weapons Replacing")
    Panel:AddControl("CheckBox", {Label = "Enable Alternative Replacing?", Command = "tr_weapon_alternative_enable"})
    for key, value in pairs(weaponList) do
        Panel:AddControl("CheckBox", {Label = "Enable TR for Weapon: "..value, Command = "tr_"..value})
    end
    Panel:Help("Authors: IDEALL")
end
local function TR_SettingsPanel_presets(Panel)
    Panel:Help("Presets Settings")
    Panel:AddControl("CheckBox", {Label = "Enable Specific Map Presets ", Command = "tr_presets_specific_maps_enable"})
    Panel:AddControl("CheckBox", {Label = "Enable Specific Map Presets for NPCs", Command = "tr_presets_specific_maps_enable_npc"})
    Panel:AddControl("CheckBox", {Label = "Enable Specific Map Presets for Weapons", Command = "tr_presets_specific_maps_enable_weapon"})
    Panel:AddControl("CheckBox", {Label = "Enable Specific Map Presets for NPCs Weapons", Command = "tr_presets_specific_maps_enable_npc_weapon"})
    Panel:AddControl("CheckBox", {Label = "Enable Specific Map Presets for Entities", Command = "tr_presets_specific_maps_enable_entity"})
    Panel:AddControl("CheckBox", {Label = "Enable Specific Map Presets for Vehicles", Command = "tr_presets_specific_maps_enable_vehicle"})
    Panel:Help("These modes specifically load presets depending on the map. Ideal for campaigns where, for example, Metropolice appear first with normal skins. And then, on the next map they are painted in red colors. ATTENTION! BE SURE TO SAVE YOUR PRESET, OTHERWISE YOU WILL LOSE EVERYTHING THAT WAS IN IT!!!!")
    Panel:Help("Authors: IDEALL")
end
local function TR_SettingsPanel_npc(Panel)
    Panel:AddControl("CheckBox", {Label = "Disable collision for NPC after spawn", Command = "tr_npc_off_collision_enable"})
    Panel:AddControl("Slider", {type = "float", Label = "Time off collision", Command = "tr_npc_off_collision_time", max = 30})
    Panel:Help("NPCs Replacing")
    for key, value in pairs(npcList) do
        Panel:AddControl("CheckBox", {Label = "Enable TR for NPC: "..value, Command = "tr_"..value})
    end
    Panel:Help("Authors: IDEALL")
end
local function TR_SettingsPanel_weapons_npc(Panel)
    Panel:Help("NPC Weapons Replacing")
    for key, value in pairs(weaponList) do
        Panel:AddControl("CheckBox", {Label = "Enable TR for NPC Weapons: "..value, Command = "tr_npc_weapon_"..value})
    end
    Panel:Help("Authors: IDEALL")
end
local function TR_SettingsPanel_entity(Panel)
    Panel:Help("Entities Replacing")
    for key, value in pairs(entityList) do
        Panel:AddControl("CheckBox", {Label = "Enable TR for Entity: "..value, Command = "tr_"..value})
    end
    Panel:Help("Authors: IDEALL")
end
local function TR_SettingsPanel_vehicle(Panel)
    Panel:Help("Entities Replacing")
    for key, value in pairs(vehicleList) do
        Panel:AddControl("CheckBox", {Label = "Enable TR for Vehicle: "..value, Command = "tr_"..value})
    end
    Panel:Help("Authors: IDEALL")
end

local folderPath_npcmodels = "total_npcmodels_replacer"
local files = ReadItemsAndCreateConVarsTR(folderPath_npcmodels)

local function TR_SettingsPanel_models_npc(Panel)
    Panel:Help("Warning: This NPC model replacement may be unstable and buggy. Also, take into account the compatibility of animation (if you take a zombie model and replace it with Metropolice, Metropolice will break). It is better to download a package of models for the necessary NPCs and replace them.")
    for key, value in pairs(files) do
        CreateConVar("tr_npc_model_"..value, 1, FCVAR_ARCHIVE,"Enable replacer for NPC Model "..value, 0, 1 )
        Panel:AddControl("CheckBox", {Label = "Enable TR for NPC Models: "..value, Command = "tr_npc_model_"..value})
    end
    Panel:Help("Authors: IDEALL")
end


local function TR_SettingsPaneladd_base()
	spawnmenu.AddToolMenuOption("Options", "Total Replacer", "TR_base", "TR Base", "", "", TR_SettingsPanel_base)
    spawnmenu.AddToolMenuOption("Options", "Total Replacer", "TR_presets_maps", "TR Presets Maps", "", "", TR_SettingsPanel_presets)
    spawnmenu.AddToolMenuOption("Options", "Total Replacer", "TR_npcs", "TR NPCs", "", "", TR_SettingsPanel_npc)
    spawnmenu.AddToolMenuOption("Options", "Total Replacer", "TR_vehicles", "TR Vehicles", "", "", TR_SettingsPanel_vehicle)
    spawnmenu.AddToolMenuOption("Options", "Total Replacer", "TR_entities", "TR Entities", "", "", TR_SettingsPanel_entity)
    spawnmenu.AddToolMenuOption("Options", "Total Replacer", "TR_weapons", "TR Weapons", "", "", TR_SettingsPanel_weapons)
    spawnmenu.AddToolMenuOption("Options", "Total Replacer", "TR_weapons_npc", "TR NPCs Weapons", "", "", TR_SettingsPanel_weapons_npc)
    spawnmenu.AddToolMenuOption("Options", "Total Replacer", "TR_models_npc", "TR NPCs Models", "", "", TR_SettingsPanel_models_npc)
end

hook.Add("PopulateToolMenu", "TR_SettingsPanel_base", TR_SettingsPaneladd_base)

local cur_table_tr_entity = ""
local items = {}

concommand.Add("tr_entity_menu", function(ply, cmd, args)
    local spawnmenu_border = GetConVar("spawnmenu_border")
    local MarginX = math.Clamp((ScrW() - 1024) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
    local MarginY = math.Clamp((ScrH() - 768) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
    if ScrW() < 1024 or ScrH() < 768 then
        MarginX = 0
        MarginY = 0
    end
    local changed_lists = {}
    local dirty = false

    ply.EntityMenu = vgui.Create("DFrame")
    ply.EntityMenu:SetSize(1000, 768)
    ply.EntityMenu:SetTitle("Total Replacer")
    ply.EntityMenu:Center()
    ply.EntityMenu:MakePopup()

    local propscroll = vgui.Create("DScrollPanel", ply.EntityMenu)
    propscroll:Dock(FILL)
    propscroll:DockMargin(0, 0, 0, 0)

    local proppanel = vgui.Create("DTileLayout", propscroll:GetCanvas())
    proppanel:Dock(FILL)

    local Categorised = {}

    local spawnableEntities = list.Get("SpawnableEntities")


    for k, v in pairs(spawnableEntities) do
        local categ = v.Category or "Other"
        if not isstring(categ) then
            categ = tostring(categ)
        end

        Categorised[categ] = Categorised[categ] or {}
        table.insert(Categorised[categ], v)
    end
 
    for CategoryName, v in SortedPairs(Categorised) do
        if CategoryName == "Half-Life 2" or CategoryName == "Fun + Games" then
            local Header = vgui.Create("ContentHeader", proppanel)
            Header:SetText(CategoryName)
            proppanel:Add(Header)
        end
        for k, SpawnableEntities in SortedPairsByMemberValue(v, "PrintName") do
            if CategoryName != "Half-Life 2" and CategoryName != "Fun + Games" then continue end
            if SpawnableEntities.AdminOnly and not LocalPlayer():IsAdmin() then continue end
            local icon = vgui.Create("ContentIcon", proppanel)
            icon:SetMaterial(SpawnableEntities.IconOverride or "entities/" .. SpawnableEntities.ClassName .. ".png")
            icon:SetName(SpawnableEntities.PrintName or "#" .. SpawnableEntities.ClassName)
            icon:SetAdminOnly(SpawnableEntities.AdminOnly or false)

            icon.DoClick = function()
                cur_table_tr_entity = SpawnableEntities.ClassName
                RunConsoleCommand( "open_tr_menu_edit_entity" )
            end
        end
    end


    local buttonWidth = 125
    local buttonHeight = 30
    local padding = 30
    

    --------------------------------------------------------------------------------------------------------------------------- Начало кода для пресетов

    local presetsButton = vgui.Create("DButton", ply.EntityMenu)
    presetsButton:SetSize(300, 50)
    presetsButton:SetPos(350, 728)
    presetsButton:SetText("Presets")
    presetsButton.DoClick = function()
        RunConsoleCommand( "tr_presets_open_menu", "total_entity_replacer" )
    end
--------------------------------------------------------------------------------------------------------------------------- Конец кода для пресетов 
end)


-- Функции для чтения и записи индивидуальных файлов игроков
local function ReadItemsFileTR_Entity(ply)
    local content = file.Read("total_entity_replacer/" .. cur_table_tr_entity .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
    return content
end

local function WriteItemsFileTR_Entity(ply, items)
    if not file.Exists("total_entity_replacer", "DATA") or not file.Exists("total_weapon_replacer", "DATA") then
        -- Чтоб не ругался из-за отсутствия папок и файлов
        file.CreateDir("total_entity_replacer")
        file.CreateDir("total_weapon_replacer")
        file.Write("total_entity_replacer/item_healthvial.txt", "[]")
        file.Write("total_weapon_replacer/weapon_pistol.txt", "[]")
    end
    file.Write("total_entity_replacer/" .. cur_table_tr_entity .. ".txt", util.TableToJSON(items))
end

concommand.Add("open_tr_menu_edit_entity", function(ply, cmd, args)


    if not ply:IsPlayer() then return end

    local items = ReadItemsFileTR_Entity(ply)

    if IsValid(ply.EntityEditor) then
        ply.EntityEditor:Remove()
    end
    
    local spawnmenu_border = GetConVar("spawnmenu_border")
    local MarginX = math.Clamp((ScrW() - 1024) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
    local MarginY = math.Clamp((ScrH() - 768) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
    if ScrW() < 1024 or ScrH() < 768 then
        MarginX = 0
        MarginY = 0
    end
    local changed_lists = {}
    local dirty = false

    ply.EntityEditor = vgui.Create("DFrame")
    ply.EntityEditor:SetSize(1000, 768)
    ply.EntityEditor:SetTitle("Entity replacer")
    ply.EntityEditor:Center()
    ply.EntityEditor:MakePopup()
    
    --------- Часть кода для панельки выбора оружия (Начало)
    local panel = vgui.Create("DPanel", ply.EntityEditor)
    panel:Dock(FILL)    

    local tabs = vgui.Create("DPropertySheet", panel)
    tabs:Dock(FILL)

    local tab1 = vgui.Create("DPanel")
    tab1.Paint = function() end -- Оставить пустой метод рисования, чтобы вкладка была прозрачной
    tabs:AddSheet(cur_table_tr_entity, tab1)
       

    -- Список текущего оружия игрока
    local entityList = vgui.Create("DListView", tab1)
    entityList:SetSize(280, 540)
    entityList:SetPos(10, 10)
    entityList:AddColumn("Entities")
        
    
    -- SpawnIcon для выбора оружия
    local entitySelect = vgui.Create("DPanelSelect", ply.EntityEditor)
    entitySelect:SetSize(500, 890)
    entitySelect:SetPos(310, 30)

    for _, entity in pairs(items) do -- Показывает имя в списке уже добавленных в замену
        entityList:AddLine(entity)
    end

    -------------------------------------------------------------------------------------------------------------------------

    local propscroll = vgui.Create("DScrollPanel", ply.EntityEditor)
    propscroll:Dock(FILL)
    propscroll:DockMargin(300, 24, 16, 16)

    local proppanel = vgui.Create("DTileLayout", propscroll:GetCanvas())
    proppanel:Dock(FILL)

    local Categorised = {}

    local spawnableEntities = list.Get("SpawnableEntities")

    for k, v in pairs(spawnableEntities) do
        local categ = v.Category or "Other"

        if not isstring(categ) then
            categ = tostring(categ)
        end

        Categorised[categ] = Categorised[categ] or {}
        table.insert(Categorised[categ], v)
    end
 
    for CategoryName, v in SortedPairs(Categorised) do
        local Header = vgui.Create("ContentHeader", proppanel)
        Header:SetText(CategoryName)
        proppanel:Add(Header)

        for k, SpawnableEntities in SortedPairsByMemberValue(v, "PrintName") do
            if SpawnableEntities.AdminOnly and not LocalPlayer():IsAdmin() then continue end
            local icon = vgui.Create("ContentIcon", proppanel)
            icon:SetMaterial(SpawnableEntities.IconOverride or "entities/" .. SpawnableEntities.ClassName .. ".png")
            icon:SetName(SpawnableEntities.PrintName or "#" .. SpawnableEntities.ClassName)
            icon:SetAdminOnly(SpawnableEntities.AdminOnly or false)

            icon.DoClick = function()
                local chance = 100
                if not table.HasValue(items, SpawnableEntities.ClassName.. ":"..chance) then
                    table.insert(items, SpawnableEntities.ClassName.. ":"..chance)
                    entityList:AddLine(SpawnableEntities.ClassName.. ":"..chance)
                    WriteItemsFileTR_Entity(ply, items)
                end
            end
            icon.DoRightClick = function()
                local mouseX, mouseY = input.GetCursorPos()
                -- Создаем панель (окно) с кнопкой
                local myPanel = vgui.Create("DFrame")
                myPanel:SetSize(300, 150)
                myPanel:SetTitle("Add Entity with chances")
                myPanel:SetPos(mouseX, mouseY)
                myPanel:MakePopup()

                local text_chance_NPC = vgui.Create("DLabel", myPanel)
                text_chance_NPC:SetPos(10, 25)
                text_chance_NPC:SetSize(200, 20)
                text_chance_NPC:SetText("Set Chance of Spawn Entity")
                text_chance_NPC:SetColor(Color(255, 255, 255))

                local myButton = vgui.Create("DButton", myPanel)
                myButton:SetSize(100, 30)
                myButton:SetPos(100, 120)
                myButton:SetText("Set Chance")

                local textEntry = vgui.Create("DTextEntry", myPanel)
                textEntry:SetSize(280, 30)
                textEntry:SetPos(10, 40)

                myButton.DoClick = function()
                    local chance = textEntry:GetValue()
                    if not table.HasValue(items, SpawnableEntities.ClassName.. ":"..chance) then
                        table.insert(items, SpawnableEntities.ClassName.. ":"..chance)
                        entityList:AddLine(SpawnableEntities.ClassName.. ":"..chance)
                        WriteItemsFileTR_Entity(ply, items)
                    end
                    myPanel:Close()
                end
            end


        end
    end
    -------------------------------------------------------------------------------------------------------------------------
    
    -- Кнопка удаления
    local removeButton = vgui.Create("DButton", ply.EntityEditor)
    removeButton:SetSize(280, 25)
    removeButton:SetPos(10, 625)
    removeButton:SetText("Delete selected entity")
    removeButton.DoClick = function()
        local selectedLine = entityList:GetSelected()
        for _, line in pairs(selectedLine) do
            local lineID = line:GetID()
            table.remove(items, lineID)
            WriteItemsFileTR_Entity(ply, items)
        end
        entityList:Clear()
        for _, entity_line in pairs(items) do -- Показывает имя в списке уже добавленных в замену
            entityList:AddLine(entity_line)
        end
    end

    -- Кнопка удаления Всех Записей
    local removeButtonAll = vgui.Create("DButton", ply.EntityEditor)
    removeButtonAll:SetSize(100, 25)
    removeButtonAll:SetPos(10, 675)
    removeButtonAll:SetText("Delete ALL!")
    removeButtonAll.DoClick = function()
        local selectedLine = entityList:GetSelectedLine()
        table.Empty(items)
        entityList:Clear()
        WriteItemsFileTR_Entity(ply, items)
    end
    local changeSWEPstoEnts = vgui.Create("DButton", ply.EntityEditor)
    changeSWEPstoEnts:SetSize(150, 25)
    changeSWEPstoEnts:SetPos(10, 725)
    changeSWEPstoEnts:SetText("Show Entities")
    changeSWEPstoEnts.DoClick = function()
        ply.EntityEditor:Close()
        RunConsoleCommand( "open_tr_menu_edit_entity_to_weapon" )
    end
end)

concommand.Add("open_tr_menu_edit_entity_to_weapon", function(ply, cmd, args) -- Перевод энтити на оружия


    if not ply:IsPlayer() then return end

    local items = ReadItemsFileTR_Entity(ply)

    if IsValid(ply.EntityEditor) then
        ply.EntityEditor:Remove()
    end
    
    local spawnmenu_border = GetConVar("spawnmenu_border")
    local MarginX = math.Clamp((ScrW() - 1024) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
    local MarginY = math.Clamp((ScrH() - 768) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
    if ScrW() < 1024 or ScrH() < 768 then
        MarginX = 0
        MarginY = 0
    end
    local changed_lists = {}
    local dirty = false

    ply.EntityEditor = vgui.Create("DFrame")
    ply.EntityEditor:SetSize(1000, 768)
    ply.EntityEditor:SetTitle("Entity replacer")
    ply.EntityEditor:Center()
    ply.EntityEditor:MakePopup()
    
    --------- Часть кода для панельки выбора оружия (Начало)
    local panel = vgui.Create("DPanel", ply.EntityEditor)
    panel:Dock(FILL)    

    local tabs = vgui.Create("DPropertySheet", panel)
    tabs:Dock(FILL)

    local tab1 = vgui.Create("DPanel")
    tab1.Paint = function() end -- Оставить пустой метод рисования, чтобы вкладка была прозрачной
    tabs:AddSheet(cur_table_tr_entity, tab1)
       

    -- Список текущего оружия игрока
    local entityList = vgui.Create("DListView", tab1)
    entityList:SetSize(280, 540)
    entityList:SetPos(10, 10)
    entityList:AddColumn("Entities")
        
    
    -- SpawnIcon для выбора оружия
    local entitySelect = vgui.Create("DPanelSelect", ply.EntityEditor)
    entitySelect:SetSize(500, 890)
    entitySelect:SetPos(310, 30)

    for _, entity in pairs(items) do -- Показывает имя в списке уже добавленных в замену
        entityList:AddLine(entity)
    end

    -------------------------------------------------------------------------------------------------------------------------




    local propscroll = vgui.Create("DScrollPanel", ply.EntityEditor)
    propscroll:Dock(FILL)
    propscroll:DockMargin(300, 24, 16, 16)

    local proppanel = vgui.Create("DTileLayout", propscroll:GetCanvas())
    proppanel:Dock(FILL)

    local Categorised = {}

    local spawnableEntities = list.Get("Weapon")

    for k, v in pairs(spawnableEntities) do
        local categ = v.Category or "Other"

        if not isstring(categ) then
            categ = tostring(categ)
        end

        Categorised[categ] = Categorised[categ] or {}
        table.insert(Categorised[categ], v)
    end
 
    for CategoryName, v in SortedPairs(Categorised) do
        local Header = vgui.Create("ContentHeader", proppanel)
        Header:SetText(CategoryName)
        proppanel:Add(Header)

        for k, SpawnableEntities in SortedPairsByMemberValue(v, "PrintName") do
            if SpawnableEntities.AdminOnly and not LocalPlayer():IsAdmin() then continue end
            if SpawnableEntities.Spawnable == false then continue end
            local icon = vgui.Create("ContentIcon", proppanel)
            icon:SetMaterial(SpawnableEntities.IconOverride or "entities/" .. SpawnableEntities.ClassName .. ".png")
            icon:SetName(SpawnableEntities.PrintName or "#" .. SpawnableEntities.ClassName)
            icon:SetAdminOnly(SpawnableEntities.AdminOnly or false)

            icon.DoClick = function()
                local chance = 100
                if not table.HasValue(items, SpawnableEntities.ClassName.. ":"..chance) then
                    table.insert(items, SpawnableEntities.ClassName.. ":"..chance)
                    entityList:AddLine(SpawnableEntities.ClassName.. ":"..chance)
                    WriteItemsFileTR_Entity(ply, items)
                end
            end
            icon.DoRightClick = function()
                local mouseX, mouseY = input.GetCursorPos()
                -- Создаем панель (окно) с кнопкой
                local myPanel = vgui.Create("DFrame")
                myPanel:SetSize(300, 150)
                myPanel:SetTitle("Add Entity with chances")
                myPanel:SetPos(mouseX, mouseY)
                myPanel:MakePopup()

                local text_chance_NPC = vgui.Create("DLabel", myPanel)
                text_chance_NPC:SetPos(10, 25)
                text_chance_NPC:SetSize(200, 20)
                text_chance_NPC:SetText("Set Chance of Spawn Entity")
                text_chance_NPC:SetColor(Color(255, 255, 255))

                local myButton = vgui.Create("DButton", myPanel)
                myButton:SetSize(100, 30)
                myButton:SetPos(100, 120)
                myButton:SetText("Set Chance")

                local textEntry = vgui.Create("DTextEntry", myPanel)
                textEntry:SetSize(280, 30)
                textEntry:SetPos(10, 40)

                myButton.DoClick = function()
                    local chance = textEntry:GetValue()
                    if not table.HasValue(items, SpawnableEntities.ClassName.. ":"..chance) then
                        table.insert(items, SpawnableEntities.ClassName.. ":"..chance)
                        entityList:AddLine(SpawnableEntities.ClassName.. ":"..chance)
                        WriteItemsFileTR_Entity(ply, items)
                    end
                    myPanel:Close()
                end
            end


        end
    end
    -------------------------------------------------------------------------------------------------------------------------
    
    -- Кнопка удаления
    local removeButton = vgui.Create("DButton", ply.EntityEditor)
    removeButton:SetSize(280, 25)
    removeButton:SetPos(10, 625)
    removeButton:SetText("Delete selected entity")
    removeButton.DoClick = function()
        local selectedLine = entityList:GetSelected()
        for _, line in pairs(selectedLine) do
            local lineID = line:GetID()
            table.remove(items, lineID)
            WriteItemsFileTR_Entity(ply, items)
        end
        entityList:Clear()
        for _, entity_line in pairs(items) do -- Показывает имя в списке уже добавленных в замену
            entityList:AddLine(entity_line)
        end
    end

    -- Кнопка удаления Всех Записей
    local removeButtonAll = vgui.Create("DButton", ply.EntityEditor)
    removeButtonAll:SetSize(100, 25)
    removeButtonAll:SetPos(10, 675)
    removeButtonAll:SetText("Delete ALL!")
    removeButtonAll.DoClick = function()
        local selectedLine = entityList:GetSelectedLine()
        table.Empty(items)
        entityList:Clear()
        WriteItemsFileTR_Entity(ply, items)
    end
    local changeSWEPstoEnts = vgui.Create("DButton", ply.EntityEditor)
    changeSWEPstoEnts:SetSize(150, 25)
    changeSWEPstoEnts:SetPos(10, 725)
    changeSWEPstoEnts:SetText("Show SWEPs")
    changeSWEPstoEnts.DoClick = function()
        ply.EntityEditor:Close()
        RunConsoleCommand( "open_tr_menu_edit_entity" )
    end
end)
