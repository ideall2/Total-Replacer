local cur_table_tr_npc = ""
local items = {}

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
    ply.NPCMenu:SetSize(1000, 1000)
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
            icon:SetMaterial(AllNPC.IconOverride or "entities/" .. AllNPC.Name .. ".png")
            icon:SetName(AllNPC.PrintName or "#" .. AllNPC.Name)
            icon:SetAdminOnly(AllNPC.AdminOnly or false)
            -- print(allNPC.NameKey)
            icon.DoClick = function()
                cur_table_tr_npc = AllNPC.NameKey
                RunConsoleCommand( "open_tr_menu_edit_npc" )
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
            local files, _ = file.Find("total_npc_replacer/presets/" .. name_preset .."/*.txt", "DATA")

            -- Пройдитесь по каждому файлу
            for _, filename in ipairs(files) do
                -- Прочитайте содержимое файла
                local content = file.Read("total_npc_replacer/presets/".. name_preset .. "/" .. filename, "DATA")
    
                -- Если содержимое существует, записывайте его в новую папку
                file.Write("total_npc_replacer/" .. filename, content)
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
        local files, _ = file.Find("total_npc_replacer/*.txt", "DATA")

        -- Пройдитесь по каждому файлу
        for _, filename in ipairs(files) do
            -- Прочитайте содержимое файла
            local content = file.Read("total_npc_replacer/".. filename, "DATA")

            -- Если содержимое существует, записывайте его в новую папку
            if content then
                file.Write("total_npc_replacer/presets/".. name_preset .. "/" .. filename, content)
            end
        end
    end

    local function DeletePresetTR(name_preset)
        -- Путь к папке, которую вы хотите удалить
        local folderPath = "total_npc_replacer/presets/".. name_preset .. "/*"

        -- Получите список всех файлов и папок в указанной папке
        local files, folders = file.Find(folderPath, "DATA")

        -- Удаление всех файлов и самой папки
        for _, filename in ipairs(files) do
            file.Delete("total_npc_replacer/presets/".. name_preset .. "/" .. filename)
            file.Delete("total_npc_replacer/presets/".. name_preset)
        end
    end

    local function CreateFoldersTR(name_preset)
        if not file.Exists("total_npc_replacer", "DATA") then
            file.CreateDir("total_npc_replacer")
        end
        if not file.Exists("total_npc_replacer/presets/".. name_preset, "DATA") then
            file.CreateDir("total_npc_replacer/presets/".. name_preset)
        end
    end

    function OpenPresetsMenuTR()
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
        local _, folders_presets = file.Find("data/total_npc_replacer/presets/*", "GAME")

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


    local presetsButton = vgui.Create("DButton", ply.NPCMenu)
    presetsButton:SetSize(300, 100)
    presetsButton:SetPos(350, 900)
    presetsButton:SetText("Presets")
    presetsButton.DoClick = function()
        OpenPresetsMenuTR()
    end
--------------------------------------------------------------------------------------------------------------------------- Конец кода для пресетов 
end)


-- Функции для чтения и записи индивидуальных файлов игроков
local function ReadItemsFileTR_Entity(ply)
    local content = file.Read("total_npc_replacer/" .. cur_table_tr_npc .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
    return content
end

local function WriteItemsFileTR_Entity(ply, items)
    if not file.Exists("total_npc_replacer", "DATA") or not file.Exists("total_weapon_replacer", "DATA") then
        -- Чтоб не ругался из-за отсутствия папок и файлов
        file.CreateDir("total_npc_replacer")
        file.CreateDir("total_weapon_replacer")
        file.Write("total_npc_replacer/item_healthvial.txt", "[]")
        file.Write("total_weapon_replacer/weapon_pistol.txt", "[]")
    end
    file.Write("total_npc_replacer/" .. cur_table_tr_npc .. ".txt", util.TableToJSON(items))
end

concommand.Add("open_tr_menu_edit_npc", function(ply, cmd, args)


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
    tabs:AddSheet(cur_table_tr_npc, tab1)
       

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

    local allNPC = list.Get("NPC")

    for k, v in pairs(allNPC) do
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

        for k, AllNPC in SortedPairsByMemberValue(v, "PrintName") do
            if AllNPC.AdminOnly and not LocalPlayer():IsAdmin() then continue end
            local icon = vgui.Create("ContentIcon", proppanel)
            icon:SetMaterial(AllNPC.IconOverride or "entities/" .. AllNPC.ClassName .. ".png")
            icon:SetName(AllNPC.PrintName or "#" .. AllNPC.ClassName)
            icon:SetAdminOnly(AllNPC.AdminOnly or false)

            icon.DoClick = function()
                local chance = 100
                if not table.HasValue(items, AllNPC.ClassName.. ":"..chance) then
                    table.insert(items, AllNPC.ClassName.. ":"..chance)
                    entityList:AddLine(AllNPC.ClassName.. ":"..chance)
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

                local myButton = vgui.Create("DButton", myPanel)
                myButton:SetSize(100, 30)
                myButton:SetPos(100, 120)
                myButton:SetText("Set Chance")

                local textEntry = vgui.Create("DTextEntry", myPanel)
                textEntry:SetSize(280, 30)
                textEntry:SetPos(10, 40)

                myButton.DoClick = function()
                    local chance = textEntry:GetValue()
                    if not table.HasValue(items, AllNPC.ClassName.. ":"..chance) then
                        table.insert(items, AllNPC.ClassName.. ":"..chance)
                        entityList:AddLine(AllNPC.ClassName.. ":"..chance)
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
    removeButton:SetPos(10, 675)
    removeButton:SetText("Delete selected entity")
    removeButton.DoClick = function()
        local selectedLine = entityList:GetSelectedLine()
        if selectedLine then
            table.remove(items, selectedLine)
            WriteItemsFileTR_Entity(ply, items)   
            entityList:RemoveLine(selectedLine)    
        end
    end

    -- Кнопка удаления Всех Записей
    local removeButtonAll = vgui.Create("DButton", ply.EntityEditor)
    removeButtonAll:SetSize(100, 25)
    removeButtonAll:SetPos(10, 800)
    removeButtonAll:SetText("Delete ALL!")
    removeButtonAll.DoClick = function()
        local selectedLine = entityList:GetSelectedLine()
        table.Empty(items)
        entityList:Clear()
        WriteItemsFileTR_Entity(ply, items)
    end
end)
