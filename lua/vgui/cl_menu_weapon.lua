
local cur_table_tr_weapon = ""
local items_swep = {}

concommand.Add("tr_weapon_menu", function(ply, cmd, args)
    local spawnmenu_border = GetConVar("spawnmenu_border")
    local MarginX = math.Clamp((ScrW() - 1024) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
    local MarginY = math.Clamp((ScrH() - 768) * math.max(0.1, spawnmenu_border:GetFloat()), 25, 256)
    if ScrW() < 1024 or ScrH() < 768 then
        MarginX = 0
        MarginY = 0
    end
    local changed_lists = {}
    local dirty = false

    ply.WeaponMenu = vgui.Create("DFrame")
    ply.WeaponMenu:SetSize(1000, 768)
    ply.WeaponMenu:SetTitle("Total Replacer")
    ply.WeaponMenu:Center()
    ply.WeaponMenu:MakePopup()

    local propscroll = vgui.Create("DScrollPanel", ply.WeaponMenu)
    propscroll:Dock(FILL)
    propscroll:DockMargin(0, 0, 0, 0)

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
        if CategoryName == "Half-Life 2" or CategoryName == "Other" then
            local Header = vgui.Create("ContentHeader", proppanel)
            Header:SetText(CategoryName)
            proppanel:Add(Header)
        end
        for k, SpawnableEntities in SortedPairsByMemberValue(v, "PrintName") do
            if CategoryName != "Half-Life 2" and CategoryName != "Other" then continue end
            if SpawnableEntities.Spawnable == false then continue end
            if not LocalPlayer():IsAdmin() then continue end
            local icon = vgui.Create("ContentIcon", proppanel)
            icon:SetMaterial(SpawnableEntities.IconOverride or "entities/" .. SpawnableEntities.ClassName .. ".png")
            icon:SetName(SpawnableEntities.PrintName or "#" .. SpawnableEntities.ClassName)
            icon:SetAdminOnly(SpawnableEntities.AdminOnly or false)

            icon.DoClick = function()
                cur_table_tr_weapon = SpawnableEntities.ClassName
                RunConsoleCommand( "open_tr_menu_edit_weapon" )
            end
        end
    end


    local buttonWidth = 125
    local buttonHeight = 30
    local padding = 30
    

    --------------------------------------------------------------------------------------------------------------------------- Начало кода для пресетов

    local function LoadPresetTR(name_preset)
        local frame = vgui.Create("DFrame")
        frame:SetSize(300, 150)
        frame:Center()
        frame:SetTitle("Warning")
        frame:MakePopup() -- Это делает окно активным и позволяет игроку взаимодействовать с ним

        -- Создаем текстовое поле для предупреждения
        local label = vgui.Create("DLabel", frame)
        label:SetPos(10, 30) 
        label:SetSize(280, 60)
        label:SetText("Warning. Your unsaved preset will be replaced and lost forever.")

        -- Создаем кнопку подтверждения
        local confirmButton = vgui.Create("DButton", frame)
        confirmButton:SetText("Confirm!")
        confirmButton:SetPos(10, 100)
        confirmButton:SetSize(130, 30)
        confirmButton.DoClick = function()
            local files, _ = file.Find("total_weapon_replacer/presets/" .. name_preset .."/*.txt", "DATA")

            -- Пройдитесь по каждому файлу
            for _, filename in ipairs(files) do
                -- Прочитайте содержимое файла
                local content = file.Read("total_weapon_replacer/presets/".. name_preset .. "/" .. filename, "DATA")
    
                -- Если содержимое существует, записывайте его в новую папку
                file.Write("total_weapon_replacer/" .. filename, content)
            end
            frame:Close()
        end

        -- Создаем кнопку для закрытия
        local closeButton = vgui.Create("DButton", frame)
        closeButton:SetText("Cancel")
        closeButton:SetPos(160, 100)
        closeButton:SetSize(130, 30)
        closeButton.DoClick = function()
            frame:Close()
        end
    end

    local function SavePresetTR(name_preset)
        local files, _ = file.Find("total_weapon_replacer/*.txt", "DATA")

        -- Пройдитесь по каждому файлу
        for _, filename in ipairs(files) do
            -- Прочитайте содержимое файла
            local content = file.Read("total_weapon_replacer/".. filename, "DATA")

            -- Если содержимое существует, записывайте его в новую папку
            if content then
                file.Write("total_weapon_replacer/presets/".. name_preset .. "/" .. filename, content)
            end
        end
    end

    local function DeletePresetTR(name_preset)
        -- Путь к папке, которую вы хотите удалить
        local folderPath = "total_weapon_replacer/presets/".. name_preset .. "/*"

        -- Получите список всех файлов и папок в указанной папке
        local files, folders = file.Find(folderPath, "DATA")

        -- Удаление всех файлов и самой папки
        for _, filename in ipairs(files) do
            file.Delete("total_weapon_replacer/presets/".. name_preset .. "/" .. filename)
            file.Delete("total_weapon_replacer/presets/".. name_preset)
        end
    end

    local function CreateFoldersTR(name_preset)
        if not file.Exists("total_weapon_replacer", "DATA") then
            file.CreateDir("total_weapon_replacer")
        end
        if not file.Exists("total_weapon_replacer/presets/".. name_preset, "DATA") then
            file.CreateDir("total_weapon_replacer/presets/".. name_preset)
        end
    end

    local function OpenPresetsMenuTR()
        local presets_menu_tr = vgui.Create("DFrame")
        presets_menu_tr:SetSize(450, 500)    -- Устанавливаем размеры окна
        presets_menu_tr:Center()             -- Размещаем окно по центру экрана
        presets_menu_tr:SetTitle("TR Presets Manager")  -- Заголовок окна
        presets_menu_tr:MakePopup()          -- Делаем окно активным и позволяем пользователю взаимодействовать с ним

        local presetsList = vgui.Create("DListView", presets_menu_tr)
        presetsList:SetSize(280, 450)
        presetsList:SetPos(0, 25)
        presetsList:AddColumn("Presets")
        selectedLine_presets = presetsList:GetSelected()
             
        local presetsButton_in_save = vgui.Create("DButton", presets_menu_tr)
        presetsButton_in_save:SetSize(100, 25)
        presetsButton_in_save:SetPos(0, 475)
        presetsButton_in_save:SetText("Save Presets")
        presetsButton_in_save.DoClick = function()
            -- Создаем текстовое поле
            local frame = vgui.Create("DFrame")
            frame:SetSize(300, 150)
            frame:Center()
            frame:SetTitle("Save presets")
            frame:MakePopup()

            local textentry = vgui.Create("DTextEntry", frame)
            textentry:SetSize(280, 30)
            textentry:SetPos(10, 60) -- Размещаем текстовое поле посередине окна
            textentry:SetPlaceholderText("Save preset as...") -- Текст-подсказка

            -- Можно добавить кнопку, чтобы что-то сделать с введенным текстом, например:
            local button = vgui.Create("DButton", frame)
            button:SetSize(280, 30)
            button:SetPos(10, 100)
            button:SetText("Save")
            button.DoClick = function()
                namePresetTR = textentry:GetValue() -- Получаем введенное имя
                button:SetText("Saved!")
                CreateFoldersTR(namePresetTR)
                SavePresetTR(namePresetTR)
                presetsList:AddLine(namePresetTR)
            end
        end
        
        local presetsButton_in_load = vgui.Create("DButton", presets_menu_tr)
        presetsButton_in_load:SetSize(100, 25)
        presetsButton_in_load:SetPos(175, 475)
        presetsButton_in_load:SetText("Load Presets")
        presetsButton_in_load.DoClick = function()
            local selectedLines = presetsList:GetSelected()
            if selectedLines[1] then -- Если есть выбранная строка
                local name_preset = selectedLines[1]:GetValue(1) -- Получить значение из первой колонки
                LoadPresetTR(name_preset)
            end
        end
        
        
        -- Получение списка папок из папки data
        local _, folders_presets = file.Find("data/total_weapon_replacer/presets/*", "GAME")

        -- Добавление каждой папки
        for _, foldername in ipairs(folders_presets) do
            presetsList:AddLine(foldername)
        end
        
        local presetsButton_in_delete = vgui.Create("DButton", presets_menu_tr)
        presetsButton_in_delete:SetSize(150, 25)
        presetsButton_in_delete:SetPos(300, 475)
        presetsButton_in_delete:SetText("Delete Selected Preset")
        presetsButton_in_delete.DoClick = function()
            local selectedLine_presets = presetsList:GetSelected()
            if selectedLine_presets[1] then -- Если есть выбранная строка
                local lineID = selectedLine_presets[1]:GetID()
                presetsList:RemoveLine(lineID)
                local name_preset = selectedLine_presets[1]:GetValue(1) -- Получить значение из первой колонки
                DeletePresetTR(name_preset)
                presetsButton_in_delete:SetText("Successfully deleted")
            end
        end


    end

    local presetsButton = vgui.Create("DButton", ply.WeaponMenu)
    presetsButton:SetSize(300, 50)
    presetsButton:SetPos(350, 728)
    presetsButton:SetText("Presets")
    presetsButton.DoClick = function()
        OpenPresetsMenuTR()
    end
--------------------------------------------------------------------------------------------------------------------------- Конец кода для пресетов 
end)


-- Функции для чтения и записи индивидуальных файлов игроков
local function ReadItemsFileTR_Weapon(ply)
    local content = file.Read("total_weapon_replacer/" .. cur_table_tr_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
    return content
end

local function WriteItemsFileTR_Weapon(ply, items_swep)
    if not file.Exists("total_entity_replacer", "DATA") or not file.Exists("total_weapon_replacer", "DATA") then
        -- Чтоб не ругался из-за отсутствия папок и файлов
        file.CreateDir("total_entity_replacer")
        file.CreateDir("total_weapon_replacer")
        file.Write("total_entity_replacer/item_healthvial.txt", "[]")
        file.Write("total_weapon_replacer/weapon_pistol.txt", "[]")
    end
    file.Write("total_weapon_replacer/" .. cur_table_tr_weapon .. ".txt", util.TableToJSON(items_swep))
end

concommand.Add("open_tr_menu_edit_weapon", function(ply, cmd, args)

    if not ply:IsPlayer() then return end

    local items_swep = ReadItemsFileTR_Weapon(ply)

    if IsValid(ply.WeaponEditor) then
        ply.WeaponEditor:Remove()
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

    ply.WeaponEditor = vgui.Create("DFrame")
    ply.WeaponEditor:SetSize(1000, 768)
    ply.WeaponEditor:SetTitle("Weapon replacer")
    ply.WeaponEditor:Center()
    ply.WeaponEditor:MakePopup()
    
    --------- Часть кода для панельки выбора оружия (Начало)
    local panel = vgui.Create("DPanel", ply.WeaponEditor)
    panel:Dock(FILL)    

    local tabs = vgui.Create("DPropertySheet", panel)
    tabs:Dock(FILL)

    local tab1 = vgui.Create("DPanel")
    tab1.Paint = function() end -- Оставить пустой метод рисования, чтобы вкладка была прозрачной
    tabs:AddSheet(cur_table_tr_weapon, tab1)
       

    -- Список текущего оружия игрока
    local weaponList = vgui.Create("DListView", tab1)
    weaponList:SetSize(280, 540)
    weaponList:SetPos(10, 10)
    weaponList:AddColumn("Entities")
        
    
    -- SpawnIcon для выбора оружия
    local weaponSelect = vgui.Create("DPanelSelect", ply.WeaponEditor)
    weaponSelect:SetSize(500, 890)
    weaponSelect:SetPos(310, 30)

    for _, weapon in pairs(items_swep) do -- Показывает имя в списке уже добавленных в замену
        weaponList:AddLine(weapon)
    end

    -------------------------------------------------------------------------------------------------------------------------




    local propscroll = vgui.Create("DScrollPanel", ply.WeaponEditor)
    propscroll:Dock(FILL)
    propscroll:DockMargin(300, 24, 16, 16)

    local proppanel = vgui.Create("DTileLayout", propscroll:GetCanvas())
    proppanel:Dock(FILL)

    local Categorised = {}

    local spawnmenuWeapons = list.Get("Weapon")

    for k, v in pairs(spawnmenuWeapons) do
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
        for k, SpawnmenuWeapons in SortedPairsByMemberValue(v, "PrintName") do
            if not LocalPlayer():IsAdmin() then continue end
            if SpawnmenuWeapons.Spawnable == false then continue end
            local icon = vgui.Create("ContentIcon", proppanel)
            icon:SetMaterial(SpawnmenuWeapons.IconOverride or "entities/" .. SpawnmenuWeapons.ClassName .. ".png")
            icon:SetName(SpawnmenuWeapons.PrintName or "#" .. SpawnmenuWeapons.ClassName)
            icon:SetAdminOnly(SpawnmenuWeapons.AdminOnly or false)

            icon.DoClick = function()
                local chance = 100
                if not table.HasValue(items_swep, SpawnmenuWeapons.ClassName.. ":"..chance) then
                    table.insert(items_swep, SpawnmenuWeapons.ClassName.. ":"..chance)
                    weaponList:AddLine(SpawnmenuWeapons.ClassName.. ":"..chance)
                    WriteItemsFileTR_Weapon(ply, items_swep)
                end
            end
            icon.DoRightClick = function()
                local mouseX, mouseY = input.GetCursorPos()
                -- Создаем панель (окно) с кнопкой
                local myPanel = vgui.Create("DFrame")
                myPanel:SetSize(300, 150)
                myPanel:SetTitle("Add Weapon with chances")
                myPanel:SetPos(mouseX, mouseY)
                myPanel:MakePopup()

                local text_chance_NPC = vgui.Create("DLabel", myPanel)
                text_chance_NPC:SetPos(10, 25)
                text_chance_NPC:SetSize(200, 20)
                text_chance_NPC:SetText("Set Chance of Spawn Weapon")
                text_chance_NPC:SetColor(Color(255, 255, 255))

                local myButton = vgui.Create("DButton", myPanel)
                myButton:SetSize(100, 30)
                myButton:SetPos(100, 120)
                myButton:SetText("Set Chance")

                local textEntry = vgui.Create("DTextEntry", myPanel)
                textEntry:SetSize(280, 30)
                textEntry:SetText("100")
                textEntry:SetPos(10, 40)

                myButton.DoClick = function()
                    local chance = textEntry:GetValue()
                    if not table.HasValue(items_swep, SpawnmenuWeapons.ClassName.. ":"..chance) then
                        table.insert(items_swep, SpawnmenuWeapons.ClassName.. ":"..chance)
                        weaponList:AddLine(SpawnmenuWeapons.ClassName.. ":"..chance)
                        WriteItemsFileTR_Weapon(ply, items_swep)
                    end
                    myPanel:Close()
                end
            end


        end
    end
    -------------------------------------------------------------------------------------------------------------------------
    
    -- Кнопка удаления
    local removeButton = vgui.Create("DButton", ply.WeaponEditor)
    removeButton:SetSize(280, 25)
    removeButton:SetPos(10, 625)
    removeButton:SetText("Delete selected weapon")
    removeButton.DoClick = function()
        local selectedLine = weaponList:GetSelected()
        for _, line in pairs(selectedLine) do
            local lineID = line:GetID()
            table.remove(items_swep, lineID)
            WriteItemsFileTR_Weapon(ply, items_swep)
        end
        weaponList:Clear()
        for _, weapons_line in pairs(items_swep) do -- Показывает имя в списке уже добавленных в замену
            weaponList:AddLine(weapons_line)
        end
    end

    -- Кнопка удаления Всех Записей
    local removeButtonAll = vgui.Create("DButton", ply.WeaponEditor)
    removeButtonAll:SetSize(100, 25)
    removeButtonAll:SetPos(10, 675)
    removeButtonAll:SetText("Delete ALL!")
    removeButtonAll.DoClick = function()
        local selectedLine = weaponList:GetSelectedLine()
        table.Empty(items_swep)
        weaponList:Clear()
        WriteItemsFileTR_Weapon(ply, items_swep)
    end

    local changeSWEPStoEnts = vgui.Create("DButton", ply.WeaponEditor)
    changeSWEPStoEnts:SetSize(150, 25)
    changeSWEPStoEnts:SetPos(10, 725)
    changeSWEPStoEnts:SetText("Show Entities")
    changeSWEPStoEnts.DoClick = function()
        ply.WeaponEditor:Close()
        RunConsoleCommand( "open_tr_menu_edit_weapon_to_entity" )
    end
end)

concommand.Add("open_tr_menu_edit_weapon_to_entity", function(ply, cmd, args) -- Копия вызова менюшки для выбора оружия, только теперь выбирает энтити.

    if not ply:IsPlayer() then return end

    local items_swep = ReadItemsFileTR_Weapon(ply)

    if IsValid(ply.WeaponEditor) then
        ply.WeaponEditor:Remove()
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

    ply.WeaponEditor = vgui.Create("DFrame")
    ply.WeaponEditor:SetSize(1000, 768)
    ply.WeaponEditor:SetTitle("Weapon replacer")
    ply.WeaponEditor:Center()
    ply.WeaponEditor:MakePopup()
    
    --------- Часть кода для панельки выбора оружия (Начало)
    local panel = vgui.Create("DPanel", ply.WeaponEditor)
    panel:Dock(FILL)    

    local tabs = vgui.Create("DPropertySheet", panel)
    tabs:Dock(FILL)

    local tab1 = vgui.Create("DPanel")
    tab1.Paint = function() end -- Оставить пустой метод рисования, чтобы вкладка была прозрачной
    tabs:AddSheet(cur_table_tr_weapon, tab1)
       

    -- Список текущего оружия игрока
    local weaponList = vgui.Create("DListView", tab1)
    weaponList:SetSize(280, 540)
    weaponList:SetPos(10, 10)
    weaponList:AddColumn("Entities")
        
    
    -- SpawnIcon для выбора оружия
    local weaponSelect = vgui.Create("DPanelSelect", ply.WeaponEditor)
    weaponSelect:SetSize(500, 890)
    weaponSelect:SetPos(310, 30)

    for _, weapon in pairs(items_swep) do -- Показывает имя в списке уже добавленных в замену
        weaponList:AddLine(weapon)
    end

    -------------------------------------------------------------------------------------------------------------------------




    local propscroll = vgui.Create("DScrollPanel", ply.WeaponEditor)
    propscroll:Dock(FILL)
    propscroll:DockMargin(300, 24, 16, 16)

    local proppanel = vgui.Create("DTileLayout", propscroll:GetCanvas())
    proppanel:Dock(FILL)

    local Categorised = {}

    local spawnmenuWeapons = list.Get("SpawnableEntities")

    for k, v in pairs(spawnmenuWeapons) do
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
        for k, SpawnmenuWeapons in SortedPairsByMemberValue(v, "PrintName") do
            if not LocalPlayer():IsAdmin() then continue end
            if SpawnmenuWeapons.Spawnable == false then continue end
            local icon = vgui.Create("ContentIcon", proppanel)
            icon:SetMaterial(SpawnmenuWeapons.IconOverride or "entities/" .. SpawnmenuWeapons.ClassName .. ".png")
            icon:SetName(SpawnmenuWeapons.PrintName or "#" .. SpawnmenuWeapons.ClassName)
            icon:SetAdminOnly(SpawnmenuWeapons.AdminOnly or false)

            icon.DoClick = function()
                local chance = 100
                if not table.HasValue(items_swep, SpawnmenuWeapons.ClassName.. ":"..chance) then
                    table.insert(items_swep, SpawnmenuWeapons.ClassName.. ":"..chance)
                    weaponList:AddLine(SpawnmenuWeapons.ClassName.. ":"..chance)
                    WriteItemsFileTR_Weapon(ply, items_swep)
                end
            end
            icon.DoRightClick = function()
                local mouseX, mouseY = input.GetCursorPos()
                -- Создаем панель (окно) с кнопкой
                local myPanel = vgui.Create("DFrame")
                myPanel:SetSize(300, 150)
                myPanel:SetTitle("Add Weapon with chances")
                myPanel:SetPos(mouseX, mouseY)
                myPanel:MakePopup()

                local text_chance_NPC = vgui.Create("DLabel", myPanel)
                text_chance_NPC:SetPos(10, 25)
                text_chance_NPC:SetSize(200, 20)
                text_chance_NPC:SetText("Set Chance of Spawn Weapon")
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
                    if not table.HasValue(items_swep, SpawnmenuWeapons.ClassName.. ":"..chance) then
                        table.insert(items_swep, SpawnmenuWeapons.ClassName.. ":"..chance)
                        weaponList:AddLine(SpawnmenuWeapons.ClassName.. ":"..chance)
                        WriteItemsFileTR_Weapon(ply, items_swep)
                    end
                    myPanel:Close()
                end
            end


        end
    end
    -------------------------------------------------------------------------------------------------------------------------
    
    -- Кнопка удаления
    local removeButton = vgui.Create("DButton", ply.WeaponEditor)
    removeButton:SetSize(280, 25)
    removeButton:SetPos(10, 625)
    removeButton:SetText("Delete selected weapon")
    removeButton.DoClick = function()
        local selectedLine = weaponList:GetSelected()
        for _, line in pairs(selectedLine) do
            local lineID = line:GetID()
            table.remove(items_swep, lineID)
            WriteItemsFileTR_Weapon(ply, items_swep)
        end
        weaponList:Clear()
        for _, weapons_line in pairs(items_swep) do -- Показывает имя в списке уже добавленных в замену
            weaponList:AddLine(weapons_line)
        end
    end

    -- Кнопка удаления Всех Записей
    local removeButtonAll = vgui.Create("DButton", ply.WeaponEditor)
    removeButtonAll:SetSize(100, 25)
    removeButtonAll:SetPos(10, 675)
    removeButtonAll:SetText("Delete ALL!")
    removeButtonAll.DoClick = function()
        local selectedLine = weaponList:GetSelectedLine()
        table.Empty(items_swep)
        weaponList:Clear()
        WriteItemsFileTR_Weapon(ply, items_swep)
    end

    local changeEntstoSWEPS = vgui.Create("DButton", ply.WeaponEditor)
    changeEntstoSWEPS:SetSize(150, 25)
    changeEntstoSWEPS:SetPos(10, 725)
    changeEntstoSWEPS:SetText("Show SWEP")
    changeEntstoSWEPS.DoClick = function()
        ply.WeaponEditor:Close()
        RunConsoleCommand( "open_tr_menu_edit_weapon" )
    end
end)