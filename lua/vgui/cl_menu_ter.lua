local function TER_SettingsPanel(Panel)
    local openMenuButton = Panel:Button("Open TER")
    openMenuButton.DoClick = function()
        RunConsoleCommand("ter_menu")
    end
    Panel:AddControl("CheckBox", {Label = "Enable ter", Command = "ter_enable"})
    Panel:AddControl("CheckBox", {Label = "Enable Alternate replacement method (Experimental)", Command = "ter_alternative_replace"})
    Panel:ControlHelp("When enabled, Entity will change immediately after spawning, as well as after falling from NPCs. Be sure to fill all tables with Entitys otherwise Entitys will spawn in huge numbers in one point. I warned you. Be careful.")
    Panel:AddControl("CheckBox", {Label = "Enable ter Pistol", Command = "ter_pistol"})

end

local function TER_SettingsPaneladd()
	spawnmenu.AddToolMenuOption("Options", "Total Entity Replacer", "TER", "TER menu", "", "", TER_SettingsPanel)
end

hook.Add("PopulateToolMenu", "TER_SettingsPanel", TER_SettingsPaneladd)

local cur_table_ter_entity = ""
local items = {}

concommand.Add("tets", function(ply, cmd, args)
        -- Ваша строка данных
    local dataString = "название_вашего_энтити, 100"

    -- Разбиваем строку по запятой и удаляем начальные и конечные пробелы
    local parts = string.Explode(",", dataString)
    local name_entity = string.Trim(parts[1])
    local chance_entity = string.Trim(parts[2])

    -- Выводим название энтити
    print("Название энтити:", name_entity)
    print("Шанс энтити:", chance_entity)
end)

concommand.Add("ter_menu", function(ply, cmd, args)
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
    ply.EntityMenu:SetSize(1000, 1000)
    ply.EntityMenu:SetTitle("Entity replacer")
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
                cur_table_ter_entity = SpawnableEntities.ClassName
                RunConsoleCommand( "open_ter_menu_edit" )
            end
        end
    end


    local buttonWidth = 125
    local buttonHeight = 30
    local padding = 30
    

    --------------------------------------------------------------------------------------------------------------------------- Начало кода для пресетов

    function LoadPresetTER(name_preset)
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
            local files, _ = file.Find("total_entity_replacer/presets/" .. name_preset .."/*.txt", "DATA")

            -- Пройдитесь по каждому файлу
            for _, filename in ipairs(files) do
                -- Прочитайте содержимое файла
                local content = file.Read("total_entity_replacer/presets/".. name_preset .. "/" .. filename, "DATA")
    
                -- Если содержимое существует, записывайте его в новую папку
                file.Write("total_entity_replacer/" .. filename, content)
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


    local function SavePresetTER(name_preset)
        local files, _ = file.Find("total_entity_replacer/*.txt", "DATA")

        -- Пройдитесь по каждому файлу
        for _, filename in ipairs(files) do
            -- Прочитайте содержимое файла
            local content = file.Read("total_entity_replacer/".. filename, "DATA")

            -- Если содержимое существует, записывайте его в новую папку
            if content then
                file.Write("total_entity_replacer/presets/".. name_preset .. "/" .. filename, content)
            end
        end
    end

    local function DeletePresetTER(name_preset)
        -- Путь к папке, которую вы хотите удалить
        local folderPath = "total_entity_replacer/presets/".. name_preset .. "/*"

        -- Получите список всех файлов и папок в указанной папке
        local files, folders = file.Find(folderPath, "DATA")

        -- Удаление всех файлов и самой папки
        for _, filename in ipairs(files) do
            file.Delete("total_entity_replacer/presets/".. name_preset .. "/" .. filename)
            file.Delete("total_entity_replacer/presets/".. name_preset)
        end
    end

    local function CreateFoldersTER(name_preset)
        if not file.Exists("total_entity_replacer", "DATA") then
            file.CreateDir("total_entity_replacer")
        end
        if not file.Exists("total_entity_replacer/presets/".. name_preset, "DATA") then
            file.CreateDir("total_entity_replacer/presets/".. name_preset)
        end
    end

    function OpenPresetsMenuTER()
        local presets_menu_ter = vgui.Create("DFrame")
        presets_menu_ter:SetSize(450, 500)    -- Устанавливаем размеры окна
        presets_menu_ter:Center()             -- Размещаем окно по центру экрана
        presets_menu_ter:SetTitle("TER Presets Manager")  -- Заголовок окна
        presets_menu_ter:MakePopup()          -- Делаем окно активным и позволяем пользователю взаимодействовать с ним

        local presetsList = vgui.Create("DListView", presets_menu_ter)
        presetsList:SetSize(280, 450)
        presetsList:SetPos(0, 25)
        presetsList:AddColumn("Presets")
        selectedLine_presets = presetsList:GetSelected()
             
        local presetsButton_in_save = vgui.Create("DButton", presets_menu_ter)
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
                namePresetTER = textentry:GetValue() -- Получаем введенное имя
                button:SetText("Saved!")
                CreateFoldersTER(namePresetTER)
                SavePresetTER(namePresetTER)
                presetsList:AddLine(namePresetTER)
            end
        end
        
        local presetsButton_in_load = vgui.Create("DButton", presets_menu_ter)
        presetsButton_in_load:SetSize(100, 25)
        presetsButton_in_load:SetPos(175, 475)
        presetsButton_in_load:SetText("Load Presets")
        presetsButton_in_load.DoClick = function()
            local selectedLines = presetsList:GetSelected()
            if selectedLines[1] then -- Если есть выбранная строка
                local name_preset = selectedLines[1]:GetValue(1) -- Получить значение из первой колонки
                LoadPresetTER(name_preset)
            end
        end
        
        
        -- Получение списка папок из папки data
        local _, folders_presets = file.Find("data/total_entity_replacer/presets/*", "GAME")

        -- Добавление каждой папки
        for _, foldername in ipairs(folders_presets) do
            presetsList:AddLine(foldername)
        end
        
        local presetsButton_in_delete = vgui.Create("DButton", presets_menu_ter)
        presetsButton_in_delete:SetSize(150, 25)
        presetsButton_in_delete:SetPos(300, 475)
        presetsButton_in_delete:SetText("Delete Selected Preset")
        presetsButton_in_delete.DoClick = function()
            local selectedLine_presets = presetsList:GetSelected()
            if selectedLine_presets[1] then -- Если есть выбранная строка
                local lineID = selectedLine_presets[1]:GetID()
                presetsList:RemoveLine(lineID)
                local name_preset = selectedLine_presets[1]:GetValue(1) -- Получить значение из первой колонки
                DeletePresetTER(name_preset)
                presetsButton_in_delete:SetText("Successfully deleted")
            end
        end


    end


    local presetsButton = vgui.Create("DButton", ply.EntityMenu)
    presetsButton:SetSize(300, 100)
    presetsButton:SetPos(350, 900)
    presetsButton:SetText("Presets")
    presetsButton.DoClick = function()
        OpenPresetsMenuTER()
    end
--------------------------------------------------------------------------------------------------------------------------- Конец кода для пресетов 
end)


-- Функции для чтения и записи индивидуальных файлов игроков
local function ReadItemsFileTER(ply)
    local content = file.Read("total_entity_replacer/" .. cur_table_ter_entity .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
    return content
end

local function WriteItemsFileTER(ply, items)
    if not file.Exists("total_entity_replacer", "DATA") then
        -- Чтоб не ругался из-за отсутствия папок и файлов
        file.CreateDir("total_entity_replacer")
        file.Write("total_entity_replacer/item_healthvial.txt", "[]")
    end
    file.Write("total_entity_replacer/" .. cur_table_ter_entity .. ".txt", util.TableToJSON(items))
end

concommand.Add("open_ter_menu_edit", function(ply, cmd, args)


    if not ply:IsPlayer() then return end

    local items = ReadItemsFileTER(ply)

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
    ply.EntityEditor:SetSize(1000, 900)
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
    tabs:AddSheet(cur_table_ter_entity, tab1)
       

    -- Список текущего оружия игрока
    local weaponList = vgui.Create("DListView", tab1)
    weaponList:SetSize(280, 540)
    weaponList:SetPos(10, 10)
    weaponList:AddColumn("Weapons")
        
    
    -- SpawnIcon для выбора оружия
    local weaponSelect = vgui.Create("DPanelSelect", ply.EntityEditor)
    weaponSelect:SetSize(500, 890)
    weaponSelect:SetPos(310, 30)

    for _, weapon in pairs(items) do -- Показывает имя в списке уже добавленных в замену
        weaponList:AddLine(weapon)
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
                if not table.HasValue(items, SpawnableEntities.ClassName) then
                    table.insert(items, SpawnableEntities.ClassName.. ":"..chance)
                    weaponList:AddLine(SpawnableEntities.ClassName.. ":"..chance)
                    WriteItemsFileTER(ply, items)
                end
            end


        end
    end
    -------------------------------------------------------------------------------------------------------------------------
    
    -- Кнопка удаления
    local removeButton = vgui.Create("DButton", ply.EntityEditor)
    removeButton:SetSize(280, 25)
    removeButton:SetPos(10, 675)
    removeButton:SetText("Delete selected entity")
    removeButton.DoClick = function()
        local selectedLine = weaponList:GetSelectedLine()
        if selectedLine then
            table.remove(items, selectedLine)
            weaponList:RemoveLine(selectedLine)
            WriteItemsFileTER(ply, items)       
        end
    end

    -- Кнопка удаления Всех Записей
    local removeButtonAll = vgui.Create("DButton", ply.EntityEditor)
    removeButtonAll:SetSize(100, 25)
    removeButtonAll:SetPos(10, 800)
    removeButtonAll:SetText("Delete ALL!")
    removeButtonAll.DoClick = function()
        local selectedLine = weaponList:GetSelectedLine()
        table.Empty(items)
        weaponList:Clear()
        WriteItemsFileTER(ply, items)
    end
end)
