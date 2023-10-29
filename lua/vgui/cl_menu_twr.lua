local function TWR_SettingsPanel(Panel)
    local openMenuButton = Panel:Button("Open TWR")
    openMenuButton.DoClick = function()
        RunConsoleCommand("twr_menu")
    end
    Panel:AddControl("CheckBox", {Label = "Enable TWR", Command = "twr_enable"})
    Panel:AddControl("CheckBox", {Label = "Enable Alternate replacement method (Experimental)", Command = "twr_alternative_replace"})
    Panel:ControlHelp("When enabled, weapons will change immediately after spawning, as well as after falling from NPCs. Be sure to fill all tables with weapons otherwise weapons will spawn in huge numbers in one point. I warned you. Be careful.")
    Panel:AddControl("CheckBox", {Label = "Enable TWR Pistol", Command = "twr_pistol"})
	Panel:AddControl("CheckBox", {Label = "Enable TWR SMG1", Command = "twr_smg1"})
	Panel:AddControl("CheckBox", {Label = "Enable TWR Shotgun", Command = "twr_shotgun"})
	Panel:AddControl("CheckBox", {Label = "Enable TWR Revolver", Command = "twr_revolver"})
    Panel:AddControl("CheckBox", {Label = "Enable TWR RPG", Command = "twr_rpg"})
    Panel:AddControl("CheckBox", {Label = "Enable TWR Crossbow", Command = "twr_crossbow"})
	Panel:AddControl("CheckBox", {Label = "Enable TWR Crowbar", Command = "twr_crowbar"})
	Panel:AddControl("CheckBox", {Label = "Enable TWR AR2", Command = "twr_ar2"})
	Panel:AddControl("CheckBox", {Label = "Enable TWR Frag Grenade", Command = "twr_frag"})
	Panel:AddControl("CheckBox", {Label = "Enable TWR SLAM", Command = "twr_slam"})
    Panel:AddControl("CheckBox", {Label = "Enable TWR Gravity Gun", Command = "twr_physcannon"})
    Panel:AddControl("CheckBox", {Label = "Enable TWR Stunstick", Command = "twr_stunstick"})
    Panel:AddControl("CheckBox", {Label = "Enable TWR Bug Bait", Command = "twr_stunstick"})

end

local function TWR_SettingsPaneladd()
	spawnmenu.AddToolMenuOption("Options", "Total Weapon Replacer", "TWR", "TWR menu", "", "", TWR_SettingsPanel)
end

hook.Add("PopulateToolMenu", "TWR_SettingsPanel", TWR_SettingsPaneladd)

local cur_table_twr_weapon = ""
local items = {}

concommand.Add("twr_menu", function(ply, cmd, args)
     -- Создание главного окна
    local frame = vgui.Create("DFrame")
    frame:SetSize(350, 850)    -- Устанавливаем размеры окна
    frame:Center()             -- Размещаем окно по центру экрана
    frame:SetTitle("Choose weapon..... and replace it!")  -- Заголовок окна
    frame:MakePopup()          -- Делаем окно активным и позволяем пользователю взаимодействовать с ним
    ------------------ Начало кода с кнопками оружия
    local buttonHeight = 50   -- Высота кнопки
    local padding = 10        -- Отступ между кнопками
    
    -- Список кнопок с названиями и действиями
    local buttons = {
        {name = "Pistol", action = function()
            cur_table_twr_weapon = "weapon_pistol"
            RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "SMG1", action = function()
            cur_table_twr_weapon = "weapon_smg1"
            RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "Shotgun", action = function()
            cur_table_twr_weapon = "weapon_shotgun"
             RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "Revolver", action = function() 
            cur_table_twr_weapon = "weapon_357"
            RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "RPG", action = function() 
            cur_table_twr_weapon = "weapon_rpg"
             RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "Crossbow", action = function() 
            cur_table_twr_weapon = "weapon_crossbow"
            RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "Crowbar", action = function()
            cur_table_twr_weapon = "weapon_crowbar"
            RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "AR2", action = function()
            cur_table_twr_weapon = "weapon_ar2"
            RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "Frag Grenade", action = function()
            cur_table_twr_weapon = "weapon_frag"
            RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "SLAM", action = function()
            cur_table_twr_weapon = "weapon_slam"
            RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "GravityGun", action = function()
            cur_table_twr_weapon = "weapon_physcannon"
            RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "Stunstick", action = function()
            cur_table_twr_weapon = "weapon_stunstick"
            RunConsoleCommand( "open_twr_menu_edit" )
        end},
        {name = "Bug Bait", action = function()
            cur_table_twr_weapon = "weapon_bugbait"
            RunConsoleCommand( "open_twr_menu_edit" )
        end}
    }

    for i, btnInfo in ipairs(buttons) do
        local btn = vgui.Create("DButton", frame)  -- Создаем кнопку
        btn:SetSize(250, buttonHeight)             -- Устанавливаем размер кнопки
        btn:SetPos(25, (i-1)*(buttonHeight + padding) + 25)  -- Позиционируем кнопку
        btn:SetText(btnInfo.name)                  -- Устанавливаем название кнопки
        btn.DoClick = btnInfo.action               -- Устанавливаем действие для кнопки
    end


    local buttonWidth = 125
    local buttonHeight = 30
    local padding = 30
    

    --------------------------------------------------------------------------------------------------------------------------- Начало кода для пресетов

    function LoadPresetTWR(name_preset)
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
            local files, _ = file.Find("total_replacer_weapon/presets/" .. name_preset .."/*.txt", "DATA")

            -- Пройдитесь по каждому файлу
            for _, filename in ipairs(files) do
                -- Прочитайте содержимое файла
                local content = file.Read("total_replacer_weapon/presets/".. name_preset .. "/" .. filename, "DATA")
    
                -- Если содержимое существует, записывайте его в новую папку
                file.Write("total_replacer_weapon/" .. filename, content)
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


    local function SavePresetTWR(name_preset)
        local files, _ = file.Find("total_replacer_weapon/*.txt", "DATA")

        -- Пройдитесь по каждому файлу
        for _, filename in ipairs(files) do
            -- Прочитайте содержимое файла
            local content = file.Read("total_replacer_weapon/".. filename, "DATA")

            -- Если содержимое существует, записывайте его в новую папку
            if content then
                file.Write("total_replacer_weapon/presets/".. name_preset .. "/" .. filename, content)
            end
        end
    end

    local function DeletePresetTWR(name_preset)
        -- Путь к папке, которую вы хотите удалить
        local folderPath = "total_replacer_weapon/presets/".. name_preset .. "/*"

        -- Получите список всех файлов и папок в указанной папке
        local files, folders = file.Find(folderPath, "DATA")

        -- Удаление всех файлов и самой папки
        for _, filename in ipairs(files) do
            file.Delete("total_replacer_weapon/presets/".. name_preset .. "/" .. filename)
            file.Delete("total_replacer_weapon/presets/".. name_preset)
        end
    end

    local function CreateFoldersTWR(name_preset)
        if not file.Exists("total_replacer_weapon", "DATA") then
            file.CreateDir("total_replacer_weapon")
        end
        if not file.Exists("total_replacer_weapon/presets/".. name_preset, "DATA") then
            file.CreateDir("total_replacer_weapon/presets/".. name_preset)
        end
    end

    function OpenPresetsMenuTWR()
        local presets_menu_twr = vgui.Create("DFrame")
        presets_menu_twr:SetSize(450, 500)    -- Устанавливаем размеры окна
        presets_menu_twr:Center()             -- Размещаем окно по центру экрана
        presets_menu_twr:SetTitle("TWR Presets Manager")  -- Заголовок окна
        presets_menu_twr:MakePopup()          -- Делаем окно активным и позволяем пользователю взаимодействовать с ним

        local presetsList = vgui.Create("DListView", presets_menu_twr)
        presetsList:SetSize(280, 450)
        presetsList:SetPos(0, 25)
        presetsList:AddColumn("Presets")
        selectedLine_presets = presetsList:GetSelected()
             
        local presetsButton_in_save = vgui.Create("DButton", presets_menu_twr)
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
                namePresetTWR = textentry:GetValue() -- Получаем введенное имя
                button:SetText("Saved!")
                CreateFoldersTWR(namePresetTWR)
                SavePresetTWR(namePresetTWR)
                presetsList:AddLine(namePresetTWR)
            end
        end
        
        local presetsButton_in_load = vgui.Create("DButton", presets_menu_twr)
        presetsButton_in_load:SetSize(100, 25)
        presetsButton_in_load:SetPos(175, 475)
        presetsButton_in_load:SetText("Load Presets")
        presetsButton_in_load.DoClick = function()
            local selectedLines = presetsList:GetSelected()
            if selectedLines[1] then -- Если есть выбранная строка
                local name_preset = selectedLines[1]:GetValue(1) -- Получить значение из первой колонки
                LoadPresetTWR(name_preset)
            end
        end
        
        
        -- Получение списка папок из папки data
        local _, folders_presets = file.Find("data/total_replacer_weapon/presets/*", "GAME")

        -- Добавление каждой папки
        for _, foldername in ipairs(folders_presets) do
            presetsList:AddLine(foldername)
        end
        
        local presetsButton_in_delete = vgui.Create("DButton", presets_menu_twr)
        presetsButton_in_delete:SetSize(150, 25)
        presetsButton_in_delete:SetPos(300, 475)
        presetsButton_in_delete:SetText("Delete Selected Preset")
        presetsButton_in_delete.DoClick = function()
            local selectedLine_presets = presetsList:GetSelected()
            if selectedLine_presets[1] then -- Если есть выбранная строка
                local lineID = selectedLine_presets[1]:GetID()
                presetsList:RemoveLine(lineID)
                local name_preset = selectedLine_presets[1]:GetValue(1) -- Получить значение из первой колонки
                DeletePresetTWR(name_preset)
                presetsButton_in_delete:SetText("Successfully deleted")
            end
        end


    end


    local presetsButton = vgui.Create("DButton", frame)
    presetsButton:SetSize(100, 50)
    presetsButton:SetPos(100, 800)
    presetsButton:SetText("Presets")
    presetsButton.DoClick = function()
        OpenPresetsMenuTWR()
    end
--------------------------------------------------------------------------------------------------------------------------- Конец кода для пресетов 
end)


-- Функции для чтения и записи индивидуальных файлов игроков
local function ReadItemsFileTWR(ply)
    table_weapon = cur_table_twr_weapon
    local content = file.Read("total_replacer_weapon/" .. table_weapon .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
    return content
end

local function WriteItemsFileTWR(ply, items)
    table_weapon = cur_table_twr_weapon
    if not file.Exists("total_replacer_weapon", "DATA") then
        -- Чтоб не ругался из-за отсутствия папок и файлов
        file.CreateDir("total_replacer_weapon")
        file.Write("total_replacer_weapon/weapon_pistol.txt", "[]")
        file.Write("total_replacer_weapon/weapon_ar2.txt", "[]")
        file.Write("total_replacer_weapon/weapon_crossbow.txt", "[]")
        file.Write("total_replacer_weapon/weapon_crowbar.txt", "[]")
        file.Write("total_replacer_weapon/weapon_frag.txt", "[]")
        file.Write("total_replacer_weapon/weapon_physcannon.txt", "[]")
        file.Write("total_replacer_weapon/weapon_rpg.txt", "[]")
        file.Write("total_replacer_weapon/weapon_shotgun.txt", "[]")
        file.Write("total_replacer_weapon/weapon_slam.txt", "[]")
        file.Write("total_replacer_weapon/weapon_smg1.txt", "[]")
        file.Write("total_replacer_weapon/weapon_stunstick.txt", "[]")
    end
    file.Write("total_replacer_weapon/" .. table_weapon .. ".txt", util.TableToJSON(items))
end



concommand.Add("open_twr_menu_edit", function(ply, cmd, args)


    if not ply:IsPlayer() then return end

    local items = ReadItemsFileTWR(ply)

    if IsValid(ply.WeaponMenu) then
        ply.WeaponMenu:Remove()
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

    ply.WeaponMenu = vgui.Create("DFrame")
    ply.WeaponMenu:SetSize(1000, 900)
    ply.WeaponMenu:SetTitle("Weapon replacer")
    ply.WeaponMenu:Center()
    ply.WeaponMenu:MakePopup()
    
    --------- Часть кода для панельки выбора оружия (Начало)
    local panel = vgui.Create("DPanel", ply.WeaponMenu)
    panel:Dock(FILL)    

    local tabs = vgui.Create("DPropertySheet", panel)
    tabs:Dock(FILL)

    local tab1 = vgui.Create("DPanel")
    tab1.Paint = function() end -- Оставить пустой метод рисования, чтобы вкладка была прозрачной
    tabs:AddSheet(cur_table_twr_weapon, tab1)
       

    -- Список текущего оружия игрока
    local weaponList = vgui.Create("DListView", tab1)
    weaponList:SetSize(280, 540)
    weaponList:SetPos(10, 10)
    weaponList:AddColumn("Weapons")
        
    
    -- SpawnIcon для выбора оружия
    local weaponSelect = vgui.Create("DPanelSelect", ply.WeaponMenu)
    weaponSelect:SetSize(500, 890)
    weaponSelect:SetPos(310, 30)

    for _, weapon in pairs(items) do
        weaponList:AddLine(weapon)
    end

    -------------------------------------------------------------------------------------------------------------------------




    local propscroll = vgui.Create("DScrollPanel", ply.WeaponMenu)
    propscroll:Dock(FILL)
    propscroll:DockMargin(300, 24, 16, 16)

    local proppanel = vgui.Create("DTileLayout", propscroll:GetCanvas())
    proppanel:Dock(FILL)

    local Categorised = {}

    for k, weapon in pairs(list.Get("Weapon")) do
        if not weapon.Spawnable then continue end
        local categ = weapon.Category or "Other"

        if not isstring(categ) then
            categ = tostring(categ)
        end

        Categorised[categ] = Categorised[categ] or {}
        table.insert(Categorised[categ], weapon)
    end
 
    for CategoryName, v in SortedPairs(Categorised) do
        local Header = vgui.Create("ContentHeader", proppanel)
        Header:SetText(CategoryName)
        proppanel:Add(Header)

        for k, WeaponTable in SortedPairsByMemberValue(v, "PrintName") do
            if WeaponTable.AdminOnly and not LocalPlayer():IsAdmin() then continue end
            local icon = vgui.Create("ContentIcon", proppanel)
            icon:SetMaterial(WeaponTable.IconOverride or "entities/" .. WeaponTable.ClassName .. ".png")
            icon:SetName(WeaponTable.PrintName or "#" .. WeaponTable.ClassName)
            icon:SetAdminOnly(WeaponTable.AdminOnly or false)

            icon.DoClick = function()
                if not table.HasValue(items, WeaponTable.ClassName) then
                    table.insert(items, WeaponTable.ClassName)
                    weaponList:AddLine(WeaponTable.ClassName)
                    WriteItemsFileTWR(ply, items, "weapon_pistol")
                end
            end


        end
    end
    -------------------------------------------------------------------------------------------------------------------------
    
    -- Кнопка удаления
    local removeButton = vgui.Create("DButton", ply.WeaponMenu)
    removeButton:SetSize(280, 25)
    removeButton:SetPos(10, 675)
    removeButton:SetText("Delete selected weapon")
    removeButton.DoClick = function()
        local selectedLine = weaponList:GetSelectedLine()
        if selectedLine then
            table.remove(items, selectedLine)
            weaponList:RemoveLine(selectedLine)
            WriteItemsFileTWR(ply, items)       
        end
    end

    -- Кнопка удаления Всех Записей
    local removeButtonAll = vgui.Create("DButton", ply.WeaponMenu)
    removeButtonAll:SetSize(100, 25)
    removeButtonAll:SetPos(10, 800)
    removeButtonAll:SetText("Delete ALL!")
    removeButtonAll.DoClick = function()
        local selectedLine = weaponList:GetSelectedLine()
        table.Empty(items)
        weaponList:Clear()
        WriteItemsFileTWR(ply, items)
    end
end)