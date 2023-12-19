local cur_table_tr_npc = ""
local cur_table_tr_npc_weapon = ""
local items = {}
local weapons_NPC = {}
local weapons_player = {}
local AllNPC_Weapons = list.Get("NPCUsableWeapons")
local All_Weapons = list.Get("Weapon")
timer.Simple(0.6, function()
    AllNPC_Weapons = list.Get("NPCUsableWeapons")
    All_Weapons = list.Get("Weapon")
    for k, v in pairs(AllNPC_Weapons) do
        local weaponClass = v.class
        table.insert(weapons_NPC, weaponClass)
    end
    for k, v in pairs(All_Weapons) do
        local weaponClass = v.ClassName
        if string.find(weaponClass, "arccw_") or string.find(weaponClass, "tfa_") then
            if v.Spawnable == true then
                table.insert(AllNPC_Weapons, v)
            end
        end
    end
    -- Проходим по каждому элементу исходной таблицы


    for k, v in pairs(All_Weapons) do
        if v.Spawnable == true then
            table.insert(weapons_player, v.ClassName)
        end
    end
end)


concommand.Add("tr_npc_menu", function(ply, cmd, args)
    local spawnmenu_border = GetConVar("spawnmenu_border")
    local MarginX = math.Clamp((ScrW() - 1024) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
    local MarginY = math.Clamp((ScrH() - 768) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
    if ScrW() < 1024 or ScrH() < 768 then
        MarginX = 0
        MarginY = 0
    end
    local changed_lists = {}
    local dirty = false

    ply.NPCMenu = vgui.Create("DFrame")
    ply.NPCMenu:SetSize(1000, 768)
    ply.NPCMenu:SetTitle("Total Replacer")
    ply.NPCMenu:Center()
    ply.NPCMenu:MakePopup()

    local propscroll = vgui.Create("DScrollPanel", ply.NPCMenu)
    propscroll:Dock(FILL)
    propscroll:DockMargin(0, 0, 0, 0)

    local proppanel = vgui.Create("DTileLayout", propscroll:GetCanvas())
    proppanel:Dock(FILL)

    local Categorised = {}

    local allNPC = list.Get("NPC")



    for k, v in pairs(allNPC) do
        local categ = v.Category or "Other"
        if not isstring(categ) then
            categ = tostring(categ)
        end

        Categorised[categ] = Categorised[categ] or {}
        table.insert(Categorised[categ], v)
        v.NameKey = k
    end
 
    for CategoryName, v in SortedPairs(Categorised) do
        if CategoryName == "Combine" or CategoryName == "Humans + Resistance" or CategoryName == "Animals" or CategoryName == "Zombies + Enemy Aliens" then
            local Header = vgui.Create("ContentHeader", proppanel)
            Header:SetText(CategoryName)
            proppanel:Add(Header)
        end
        for k, AllNPC in SortedPairsByMemberValue(v, "PrintName") do
            if CategoryName != "Combine" and CategoryName != "Humans + Resistance" and CategoryName != "Animals" and CategoryName != "Zombies + Enemy Aliens" then continue end
            if AllNPC.AdminOnly and not LocalPlayer():IsAdmin() then continue end
            local icon = vgui.Create("ContentIcon", proppanel)
            icon:SetMaterial(AllNPC.IconOverride or "entities/" .. AllNPC.NameKey .. ".png")
            icon:SetName(AllNPC.PrintName or "#" .. AllNPC.Name)
            icon:SetAdminOnly(AllNPC.AdminOnly or false)
            -- print(allNPC.NameKey)
            icon.DoClick = function()
                cur_table_tr_npc = AllNPC.NameKey
                RunConsoleCommand( "open_tr_menu_edit_npc" )
            end
        end
    end

    --------------------------------------------------------------------------------------------------------------------------- Начало кода для пресетов
    
    local presetsButton = vgui.Create("DButton", ply.NPCMenu)
    presetsButton:SetSize(300, 50)
    presetsButton:SetPos(350, 718)
    presetsButton:SetText("Presets")
    presetsButton.DoClick = function()
        RunConsoleCommand( "tr_presets_open_menu", "total_npc_replacer" )
    end
--------------------------------------------------------------------------------------------------------------------------- Конец кода для пресетов 
end)


-- Функции для чтения и записи индивидуальных файлов игроков
local function ReadItemsFileTR_NPC(ply)
    local content = file.Read("total_npc_replacer/" .. cur_table_tr_npc .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
    return content
end

local function ReadItemsFileTR_NPCweapons(ply)
    local content = file.Read("total_npcweapons_replacer/" .. cur_table_tr_npc_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
    return content
end

local function WriteItemsFileTR_NPC(ply, items)
    file.Write("total_npc_replacer/" .. cur_table_tr_npc .. ".txt", util.TableToJSON(items))
end

local function WriteItemsFileTR_NPCweapons(ply, items)
    file.Write("total_npcweapons_replacer/" .. cur_table_tr_npc_weapon .. ".txt", util.TableToJSON(items))
end

concommand.Add("open_tr_menu_edit_npc", function(ply, cmd, args)
    if not ply:IsPlayer() then return end

    local items = ReadItemsFileTR_NPC(ply)

    if IsValid(ply.NPCEditor) then
        ply.NPCEditor:Remove()
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

    ply.NPCEditor = vgui.Create("DFrame")
    ply.NPCEditor:SetSize(1000, 768)
    ply.NPCEditor:SetTitle("NPC replacer")
    ply.NPCEditor:Center()
    ply.NPCEditor:MakePopup()
    
    --------- Часть кода для панельки выбора оружия (Начало)
    local panel = vgui.Create("DPanel", ply.NPCEditor)
    panel:Dock(FILL)    

    local tabs = vgui.Create("DPropertySheet", panel)
    tabs:Dock(FILL)

    local tab1 = vgui.Create("DPanel")
    tab1.Paint = function() end -- Оставить пустой метод рисования, чтобы вкладка была прозрачной
    tabs:AddSheet(cur_table_tr_npc, tab1)
       

    -- Список текущего оружия игрока
    local npcList = vgui.Create("DListView", tab1)
    npcList:SetSize(280, 540)
    npcList:SetPos(10, 10)
    npcList:AddColumn("NPC")
        
    
    -- SpawnIcon для выбора оружия
    local npcSelect = vgui.Create("DPanelSelect", ply.NPCEditor)
    npcSelect:SetSize(500, 890)
    npcSelect:SetPos(310, 30)

    for _, npc in pairs(items) do -- Показывает имя в списке уже добавленных в замену
        npcList:AddLine(npc)
    end

    -------------------------------------------------------------------------------------------------------------------------




    local propscroll = vgui.Create("DScrollPanel", ply.NPCEditor)
    propscroll:Dock(FILL)
    propscroll:DockMargin(300, 24, 16, 16)

    local proppanel = vgui.Create("DTileLayout", propscroll:GetCanvas())
    proppanel:Dock(FILL)

    local Categorised = {}

    local allNPC = list.Get("NPC")

    for k, v in pairs(allNPC) do
        local categ = v.Category or "Other"

        if not isstring(categ) then
            categ = tostring(categ)
        end

        Categorised[categ] = Categorised[categ] or {}
        table.insert(Categorised[categ], v)
        v.NameKey = k
    end
 
    for CategoryName, v in SortedPairs(Categorised) do
        local Header = vgui.Create("ContentHeader", proppanel)
        Header:SetText(CategoryName)
        proppanel:Add(Header)

        for k, AllNPC in SortedPairsByMemberValue(v, "PrintName") do
            if AllNPC.AdminOnly and not LocalPlayer():IsAdmin() then continue end
            local icon = vgui.Create("ContentIcon", proppanel)
            icon:SetMaterial(AllNPC.IconOverride or "entities/" .. AllNPC.NameKey .. ".png")
            icon:SetName(AllNPC.PrintName or "#" .. AllNPC.NameKey)
            icon:SetAdminOnly(AllNPC.AdminOnly or false)

            icon.DoClick = function()
                local chance = 100
                if not table.HasValue(items, AllNPC.NameKey.. ":"..chance) then
                    table.insert(items, AllNPC.NameKey.. ":"..chance..":".."standart")
                    npcList:AddLine(AllNPC.NameKey.. ":"..chance..":".."standart")
                    WriteItemsFileTR_NPC(ply, items)
                end
            end
            icon.DoRightClick = function()
                -- Создаем панель (окно) с кнопкой
                local Additional_Settings = vgui.Create("DFrame")
                Additional_Settings:SetSize(500, 350)
                Additional_Settings:SetTitle("Add NPC with chances and weapons")
                Additional_Settings:Center()
                Additional_Settings:MakePopup()

                local SetSettings = vgui.Create("DButton", Additional_Settings)
                SetSettings:SetSize(100, 30)
                SetSettings:SetPos(100, 320)
                SetSettings:SetText("Set Chance")

                local chance_NPC = vgui.Create("DTextEntry", Additional_Settings)
                chance_NPC:SetSize(280, 30)
                chance_NPC:SetPos(10, 80)
                chance_NPC:SetText("100")
                local text_chance_NPC = vgui.Create("DLabel", Additional_Settings)
                text_chance_NPC:SetPos(50, 60)
                text_chance_NPC:SetSize(200, 20)
                text_chance_NPC:SetText("Set Chance for NPCs")
                text_chance_NPC:SetColor(Color(255, 255, 255))

                local weapon_list_npc = vgui.Create("DComboBox", Additional_Settings)
                weapon_list_npc:SetPos(10, 150)
                weapon_list_npc:SetSize(200, 25)
                weapon_list_npc:AddChoice("standart", index)
                weapon_list_npc:AddChoice("none", index)
                weapon_list_npc:SetText("standart")
                local text_weapon_NPC = vgui.Create("DLabel", Additional_Settings)
                text_weapon_NPC:SetPos(50, 125)
                text_weapon_NPC:SetSize(200, 20)
                text_weapon_NPC:SetText("Set Weapon from NPCs SWEP")
                text_weapon_NPC:SetColor(Color(255, 255, 255))

                local weapon_list_player = vgui.Create("DComboBox", Additional_Settings)
                weapon_list_player:SetPos(250, 150)
                weapon_list_player:SetSize(200, 25)
                weapon_list_player:AddChoice("standart", index)
                weapon_list_player:AddChoice("none", index)
                weapon_list_player:SetText("standart")
                local text_weapon_player = vgui.Create("DLabel", Additional_Settings)
                text_weapon_player:SetPos(250, 125)
                text_weapon_player:SetSize(200, 20)
                text_weapon_player:SetText("Set Weapon from players SWEP")
                text_weapon_player:SetColor(Color(255, 255, 255))

                local manual_add_weapon = vgui.Create("DTextEntry", Additional_Settings)
                manual_add_weapon:SetPos(100, 250)
                manual_add_weapon:SetSize(200, 25)
                local text_weapon_NPC_manual = vgui.Create("DLabel", Additional_Settings)
                text_weapon_NPC_manual:SetPos(100, 225)
                text_weapon_NPC_manual:SetSize(200, 20)
                text_weapon_NPC_manual:SetText("or you can manually set NPCs weapon")
                text_weapon_NPC_manual:SetColor(Color(255, 255, 255))

                for index, value in ipairs(weapons_NPC) do
                    weapon_list_npc:AddChoice(value, index) -- Добавляем значение в падающий список с указанием индекса
                end

                for index, value in ipairs(weapons_player) do
                    weapon_list_player:AddChoice(value, index) -- Добавляем значение в падающий список с указанием индекса
                end

                SetSettings.DoClick = function()
                    local chance = chance_NPC:GetValue()
                    local weapon_NPC = weapon_list_npc:GetValue()
                    local weapon_NPC_manual = manual_add_weapon:GetValue()
                    local weapon_player = weapon_list_player:GetValue()
                    if not table.HasValue(items, AllNPC.NameKey.. ":"..chance) then
                        if weapon_NPC_manual != "" then
                            table.insert(items, AllNPC.NameKey.. ":"..chance..":"..weapon_NPC_manual)
                            npcList:AddLine(AllNPC.NameKey.. ":"..chance..":"..weapon_NPC_manual)
                            WriteItemsFileTR_NPC(ply, items)
                        elseif weapon_player != "standart" and weapon_NPC == "standart" then
                            table.insert(items, AllNPC.NameKey.. ":"..chance..":"..weapon_player)
                            npcList:AddLine(AllNPC.NameKey.. ":"..chance..":"..weapon_player)
                            WriteItemsFileTR_NPC(ply, items)
                        elseif weapon_player == "standart" and weapon_NPC != "standart" then
                            table.insert(items, AllNPC.NameKey.. ":"..chance..":"..weapon_NPC)
                            npcList:AddLine(AllNPC.NameKey.. ":"..chance..":"..weapon_NPC)
                            WriteItemsFileTR_NPC(ply, items)
                        else
                            table.insert(items, AllNPC.NameKey.. ":"..chance..":"..weapon_NPC)
                            npcList:AddLine(AllNPC.NameKey.. ":"..chance..":"..weapon_NPC)
                            WriteItemsFileTR_NPC(ply, items)
                        end

                    end
                    Additional_Settings:Close()
                end
            end
        end
    end
    -------------------------------------------------------------------------------------------------------------------------
    
    -- Кнопка удаления
    local removeButton = vgui.Create("DButton", ply.NPCEditor)
    removeButton:SetSize(280, 25)
    removeButton:SetPos(10, 625)
    removeButton:SetText("Delete selected npc")
    removeButton.DoClick = function()
        local selectedLine = npcList:GetSelected()
        for _, line in pairs(selectedLine) do
            local lineID = line:GetID()
            table.remove(items, lineID)
            WriteItemsFileTR_NPC(ply, items)
        end
        npcList:Clear()
        for _, npc in pairs(items) do -- Показывает имя в списке уже добавленных в замену
            npcList:AddLine(npc)
        end
        -- file.Write("total_npc_replacer/" .. cur_table_tr_npc .. ".txt", util.TableToJSON(items))
    end

    -- Кнопка удаления Всех Записей
    local removeButtonAll = vgui.Create("DButton", ply.NPCEditor)
    removeButtonAll:SetSize(100, 25)
    removeButtonAll:SetPos(10, 675)
    removeButtonAll:SetText("Delete ALL!")
    removeButtonAll.DoClick = function()
        local selectedLine = npcList:GetSelectedLine()
        table.Empty(items)
        npcList:Clear()
        WriteItemsFileTR_NPC(ply, items)
    end
end)

concommand.Add("tr_npc_weapons_menu", function(ply, cmd, args)
    local NPC_menu_weapons = vgui.Create("DFrame")
        NPC_menu_weapons:SetSize(1000, 768)
        NPC_menu_weapons:SetTitle("NPCs Weapons Replacement")
        NPC_menu_weapons:Center()
        NPC_menu_weapons:MakePopup()

        local spawnmenu_border = GetConVar("spawnmenu_border")
        local MarginX = math.Clamp((ScrW() - 1024) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
        local MarginY = math.Clamp((ScrH() - 768) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
        if ScrW() < 1024 or ScrH() < 768 then
            MarginX = 0
            MarginY = 0
        end
        local changed_lists = {}
        local dirty = false
    
        local propscroll = vgui.Create("DScrollPanel", NPC_menu_weapons)
        propscroll:Dock(FILL)
        propscroll:DockMargin(0, 0, 0, 0)
    
        local proppanel = vgui.Create("DTileLayout", propscroll:GetCanvas())
        proppanel:Dock(FILL)
    
        local Categorised = {}
    
        local NPC_Weapons = list.Get("Weapon")
        local weapon_alyxgun = {
            Category = "Half-Life 2",
            ClassName = "weapon_alyxgun",
            PrintName = "Alyx Gun",
            Spawnable = true
        }
        NPC_Weapons.weapon_alyxgun = weapon_alyxgun
        local weapon_annabelle = {
            Category = "Half-Life 2",
            ClassName = "weapon_annabelle",
            PrintName = "Annabelle",
            Spawnable = true
        }
        NPC_Weapons.weapon_annabelle = weapon_annabelle
        
        for k, v in pairs(NPC_Weapons) do
            local categ = v.Category or "Other"
            if not isstring(categ) then
                categ = tostring(categ)
            end
    
            Categorised[categ] = Categorised[categ] or {}
            table.insert(Categorised[categ], v)
            v.NameKey = k
        end
     
        for CategoryName, v in SortedPairs(Categorised) do
            if CategoryName == "Half-Life 2" then
                local Header = vgui.Create("ContentHeader", proppanel)
                Header:SetText(CategoryName)
                proppanel:Add(Header)
            end
            for k, NPC_Weapons in SortedPairsByMemberValue(v, "PrintName") do
                if CategoryName != "Half-Life 2" then continue end
                if NPC_Weapons.AdminOnly and not LocalPlayer():IsAdmin() then continue end
                local icon = vgui.Create("ContentIcon", proppanel)
                icon:SetMaterial(NPC_Weapons.IconOverride or "entities/" .. NPC_Weapons.NameKey .. ".png")
                icon:SetName(NPC_Weapons.PrintName or "#" .. NPC_Weapons.Name)
                icon:SetAdminOnly(NPC_Weapons.AdminOnly or false)
                -- print(NPC_Weapons.NameKey)
                icon.DoClick = function()
                    cur_table_tr_npc_weapon = NPC_Weapons.NameKey
                    RunConsoleCommand( "open_tr_menu_edit_npc_weapons" )
                end
            end
        end
    
        local presetsButton = vgui.Create("DButton", NPC_menu_weapons)
        presetsButton:SetSize(300, 50)
        presetsButton:SetPos(350, 718)
        presetsButton:SetText("Presets")
        presetsButton.DoClick = function()
            RunConsoleCommand( "tr_presets_open_menu", "total_npcweapons_replacer" )
        end
    end)

concommand.Add("open_tr_menu_edit_npc_weapons", function(ply, cmd, args)
    if not ply:IsPlayer() then return end

    local items = ReadItemsFileTR_NPCweapons(ply)

    if IsValid(ply.NPC_WEAPONS_Editor) then
        ply.NPC_WEAPONS_Editor:Remove()
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

    ply.NPC_WEAPONS_Editor = vgui.Create("DFrame")
    ply.NPC_WEAPONS_Editor:SetSize(1000, 768)
    ply.NPC_WEAPONS_Editor:SetTitle("NPC replacer")
    ply.NPC_WEAPONS_Editor:Center()
    ply.NPC_WEAPONS_Editor:MakePopup()
    
    --------- Часть кода для панельки выбора оружия (Начало)
    local panel = vgui.Create("DPanel", ply.NPC_WEAPONS_Editor)
    panel:Dock(FILL)    

    local tabs = vgui.Create("DPropertySheet", panel)
    tabs:Dock(FILL)

    local tab1 = vgui.Create("DPanel")
    tab1.Paint = function() end -- Оставить пустой метод рисования, чтобы вкладка была прозрачной
    tabs:AddSheet(cur_table_tr_npc_weapon, tab1)
       

    -- Список текущего оружия игрока
    local npc_weapons_List = vgui.Create("DListView", tab1)
    npc_weapons_List:SetSize(280, 540)
    npc_weapons_List:SetPos(10, 10)
    npc_weapons_List:AddColumn("NPC Weapons")
        
    
    -- SpawnIcon для выбора оружия
    local npc_weapons_Select = vgui.Create("DPanelSelect", ply.NPC_WEAPONS_Editor)
    npc_weapons_Select:SetSize(500, 890)
    npc_weapons_Select:SetPos(310, 30)

    for _, npc_weapons_ in pairs(items) do -- Показывает имя в списке уже добавленных в замену
        npc_weapons_List:AddLine(npc_weapons_)
    end

    -------------------------------------------------------------------------------------------------------------------------




    local propscroll = vgui.Create("DScrollPanel", ply.NPC_WEAPONS_Editor)
    propscroll:Dock(FILL)
    propscroll:DockMargin(300, 24, 16, 16)

    local proppanel = vgui.Create("DTileLayout", propscroll:GetCanvas())
    proppanel:Dock(FILL)

    local Categorised = {}

    local all_weapons_player = list.Get("Weapon")

    local function get_spawnmenu_weapons(nametable)    
        for k, v in pairs(nametable) do
            local categ = v.Category or "Other"
            if not isstring(categ) then
                categ = tostring(categ)
            end
            Categorised[categ] = Categorised[categ] or {}
            table.insert(Categorised[categ], v)
            v.NameKey = v.class or v.ClassName
        end
    end
    get_spawnmenu_weapons(AllNPC_Weapons)
 
    for CategoryName, v in SortedPairs(Categorised) do
        local Header = vgui.Create("ContentHeader", proppanel)
        Header:SetText(CategoryName)
        proppanel:Add(Header)

        for k, npc_weapons in SortedPairsByMemberValue(v, "PrintName") do
            if npc_weapons.AdminOnly and not LocalPlayer():IsAdmin() then continue end
            local icon = vgui.Create("ContentIcon", proppanel)
            icon:SetMaterial(npc_weapons.IconOverride or "entities/" .. npc_weapons.NameKey .. ".png")
            icon:SetName(npc_weapons.PrintName or "#" .. npc_weapons.NameKey)
            icon:SetAdminOnly(npc_weapons.AdminOnly or false)

            icon.DoClick = function()
                local chance = 100
                if not table.HasValue(items, npc_weapons.NameKey.. ":"..chance) then
                    table.insert(items, npc_weapons.NameKey.. ":"..chance)
                    npc_weapons_List:AddLine(npc_weapons.NameKey.. ":"..chance)
                    WriteItemsFileTR_NPCweapons(ply, items)
                end
            end
            icon.DoRightClick = function()
                -- Создаем панель (окно) с кнопкой
                local Additional_Settings = vgui.Create("DFrame")
                Additional_Settings:SetSize(500, 350)
                Additional_Settings:SetTitle("Add NPC with chances and weapons")
                Additional_Settings:Center()
                Additional_Settings:MakePopup()

                local SetSettings = vgui.Create("DButton", Additional_Settings)
                SetSettings:SetSize(100, 30)
                SetSettings:SetPos(100, 320)
                SetSettings:SetText("Set Chance")

                local chance_NPC = vgui.Create("DTextEntry", Additional_Settings)
                chance_NPC:SetSize(280, 30)
                chance_NPC:SetPos(10, 80)
                chance_NPC:SetText("100")
                local text_chance_NPC = vgui.Create("DLabel", Additional_Settings)
                text_chance_NPC:SetPos(50, 60)
                text_chance_NPC:SetSize(200, 20)
                text_chance_NPC:SetText("Set Chance for NPCs weapon")
                text_chance_NPC:SetColor(Color(255, 255, 255))

                local weapon_list_npc = vgui.Create("DComboBox", Additional_Settings)
                weapon_list_npc:SetPos(10, 150)
                weapon_list_npc:SetSize(200, 25)
                weapon_list_npc:AddChoice("standart", index)
                weapon_list_npc:AddChoice("none", index)
                weapon_list_npc:SetText("standart")
                local text_weapon_NPC = vgui.Create("DLabel", Additional_Settings)
                text_weapon_NPC:SetPos(50, 125)
                text_weapon_NPC:SetSize(200, 20)
                text_weapon_NPC:SetText("Set Weapon from NPCs SWEPs")
                text_weapon_NPC:SetColor(Color(255, 255, 255))

                local weapon_list_player = vgui.Create("DComboBox", Additional_Settings)
                weapon_list_player:SetPos(250, 150)
                weapon_list_player:SetSize(200, 25)
                weapon_list_player:AddChoice("standart", index)
                weapon_list_player:AddChoice("none", index)
                weapon_list_player:SetText("standart")
                local text_weapon_player = vgui.Create("DLabel", Additional_Settings)
                text_weapon_player:SetPos(250, 125)
                text_weapon_player:SetSize(200, 20)
                text_weapon_player:SetText("Set Weapon from players SWEPs")
                text_weapon_player:SetColor(Color(255, 255, 255))

                local manual_add_weapon = vgui.Create("DTextEntry", Additional_Settings)
                manual_add_weapon:SetPos(100, 250)
                manual_add_weapon:SetSize(200, 25)
                local text_weapon_NPC_manual = vgui.Create("DLabel", Additional_Settings)
                text_weapon_NPC_manual:SetPos(100, 225)
                text_weapon_NPC_manual:SetSize(200, 20)
                text_weapon_NPC_manual:SetText("or you can manually set NPCs weapon")
                text_weapon_NPC_manual:SetColor(Color(255, 255, 255))

                for index, value in ipairs(weapons_NPC) do
                    weapon_list_npc:AddChoice(value, index) -- Добавляем значение в падающий список с указанием индекса
                end

                for index, value in ipairs(weapons_player) do
                    weapon_list_player:AddChoice(value, index) -- Добавляем значение в падающий список с указанием индекса
                end

                SetSettings.DoClick = function()
                    local chance = chance_NPC:GetValue()
                    local weapon_NPC = weapon_list_npc:GetValue()
                    local weapon_NPC_manual = manual_add_weapon:GetValue()
                    local weapon_player = weapon_list_player:GetValue()
                    if not table.HasValue(items, npc_weapons.NameKey.. ":"..chance) then
                        if weapon_NPC_manual != "" then
                            table.insert(items, weapon_NPC_manual.. ":"..chance)
                            npc_weapons_List:AddLine(weapon_NPC_manual.. ":"..chance)
                            WriteItemsFileTR_NPCweapons(ply, items)
                        elseif weapon_player != "standart" and weapon_NPC == "standart" then
                            table.insert(items, weapon_player.. ":"..chance)
                            npc_weapons_List:AddLine(weapon_player.. ":"..chance)
                            WriteItemsFileTR_NPCweapons(ply, items)
                        elseif weapon_player == "standart" and weapon_NPC != "standart" then
                            table.insert(items, weapon_NPC.. ":"..chance)
                            npc_weapons_List:AddLine(weapon_NPC.. ":"..chance)
                            WriteItemsFileTR_NPCweapons(ply, items)
                        else
                            table.insert(items, weapon_NPC.. ":"..chance)
                            npc_weapons_List:AddLine(weapon_NPC.. ":"..chance)
                            WriteItemsFileTR_NPCweapons(ply, items)
                        end
                    end
                    Additional_Settings:Close()
                end
            end
        end
    end
    -------------------------------------------------------------------------------------------------------------------------
    
    -- Кнопка удаления
    local removeButton = vgui.Create("DButton", ply.NPC_WEAPONS_Editor)
    removeButton:SetSize(280, 25)
    removeButton:SetPos(10, 625)
    removeButton:SetText("Delete selected weapons")
    removeButton.DoClick = function()
        local selectedLine = npc_weapons_List:GetSelected()
        for _, line in pairs(selectedLine) do
            local lineID = line:GetID()
            table.remove(items, lineID)
            WriteItemsFileTR_NPCweapons(ply, items)
        end
        npc_weapons_List:Clear()
        for _, npc in pairs(items) do -- Показывает имя в списке уже добавленных в замену
            npc_weapons_List:AddLine(npc)
        end
    end

    -- Кнопка удаления Всех Записей
    local removeButtonAll = vgui.Create("DButton", ply.NPC_WEAPONS_Editor)
    removeButtonAll:SetSize(100, 25)
    removeButtonAll:SetPos(10, 675)
    removeButtonAll:SetText("Delete ALL!")
    removeButtonAll.DoClick = function()
        table.Empty(items)
        npc_weapons_List:Clear()
        WriteItemsFileTR_NPCweapons(ply, items)
    end
end)
