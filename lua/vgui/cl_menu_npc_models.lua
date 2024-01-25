local cur_table_tr_npc_model = ""
local npcModels = {
    "models/mossman.mdl",
    "models/alyx.mdl",
    "models/Barney.mdl",
    "models/breen.mdl",
    "models/gman_high.mdl",
    "models/Kleiner.mdl",
    "models/monk.mdl",
    "models/odessa.mdl",
    "models/vortigaunt.mdl",
    "models/dog.mdl",
    "models/Lamarr.mdl",
    "models/Humans/Group01/Female_01.mdl",
    "models/Humans/Group01/Female_02.mdl",
    "models/Humans/Group01/Female_03.mdl",
    "models/Humans/Group01/Female_04.mdl",
    "models/Humans/Group01/Female_06.mdl",
    "models/Humans/Group01/Female_07.mdl",
    "models/Humans/Group01/Male_01.mdl",
    "models/Humans/Group01/male_02.mdl",
    "models/Humans/Group01/male_03.mdl",
    "models/Humans/Group01/Male_04.mdl",
    "models/Humans/Group01/Male_05.mdl",
    "models/Humans/Group01/male_06.mdl",
    "models/Humans/Group01/male_07.mdl",
    "models/Humans/Group01/male_08.mdl",
    "models/Humans/Group01/male_09.mdl",
    "models/Humans/Group01/Male_Cheaple.mdl",
    "models/Humans/Group02/Female_01.mdl",
    "models/Humans/Group02/Female_02.mdl",
    "models/Humans/Group02/Female_03.mdl",
    "models/Humans/Group02/Female_04.mdl",
    "models/Humans/Group02/Female_06.mdl",
    "models/Humans/Group02/Female_07.mdl",
    "models/Humans/Group02/Male_01.mdl",
    "models/Humans/Group02/Male_02.mdl",
    "models/Humans/Group02/Male_03.mdl",
    "models/Humans/Group02/Male_04.mdl",
    "models/Humans/Group02/Male_05.mdl",
    "models/Humans/Group02/Male_06.mdl",
    "models/Humans/Group02/Male_07.mdl",
    "models/Humans/Group02/Male_08.mdl",
    "models/Humans/Group02/Male_09.mdl",
    "models/Humans/Group03/Female_01.mdl",
    "models/Humans/Group03/Female_02.mdl",
    "models/Humans/Group03/Female_03.mdl",
    "models/Humans/Group03/Female_04.mdl",
    "models/Humans/Group03/Female_06.mdl",
    "models/Humans/Group03/Female_07.mdl",
    "models/Humans/Group03/Female_08.mdl",
    "models/Humans/Group03/Male_01.mdl",
    "models/Humans/Group03/Male_02.mdl",
    "models/Humans/Group03/Male_03.mdl",
    "models/Humans/Group03/Male_04.mdl",
    "models/Humans/Group03/Male_05.mdl",
    "models/Humans/Group03/Male_06.mdl",
    "models/Humans/Group03/Male_07.mdl",
    "models/Humans/Group03/Male_08.mdl",
    "models/Humans/Group03/Male_09.mdl",
    "models/Humans/Group03m/Female_01.mdl",
    "models/Humans/Group03m/Female_02.mdl",
    "models/Humans/Group03m/Female_03.mdl",
    "models/Humans/Group03m/Female_04.mdl",
    "models/Humans/Group03m/Female_06.mdl",
    "models/Humans/Group03m/Female_07.mdl",
    "models/Humans/Group03m/Male_01.mdl",
    "models/Humans/Group03m/Male_02.mdl",
    "models/Humans/Group03m/Male_03.mdl",
    "models/Humans/Group03m/Male_04.mdl",
    "models/Humans/Group03m/Male_05.mdl",
    "models/Humans/Group03m/Male_06.mdl",
    "models/Humans/Group03m/Male_07.mdl",
    "models/Humans/Group03m/Male_08.mdl",
    "models/Humans/Group03m/Male_09.mdl",
    "models/Police.mdl",
    "models/Combine_Soldier.mdl",
    "models/Combine_Soldier_PrisonGuard.mdl",
    "models/Combine_Scanner.mdl",
    "models/Combine_Strider.mdl",
    "models/manhack.mdl",
    "models/AntLion.mdl",
    "models/antlion_guard.mdl",
    "models/Zombie/Classic.mdl",
    "models/headcrabclassic.mdl",
    "models/headcrab.mdl",
    "models/Zombie/Fast.mdl",
    "models/Zombie/Poison.mdl",
    "models/headcrabblack.mdl",
}

local function WriteItemsFileTR_NPCModels(ply, items)
    local name_txt_filter = string.Replace(cur_table_tr_npc_model, "/", "_")
    file.Write("total_npcmodels_replacer/" .. name_txt_filter .. ".txt", util.TableToJSON(items))
end

local function ReadItemsFileTR_NPCModels()
    local name_txt_filter = string.Replace(cur_table_tr_npc_model, "/", "_")
    local content = file.Read("total_npcmodels_replacer/" .. name_txt_filter .. ".txt", "DATA")
    if content then
        return util.JSONToTable(content) or {}
    else
        return {}
    end
    return content
end

local function TR_NPCModelsMenuOpen(name_model)
    local items_NPC_Models = ReadItemsFileTR_NPCModels()
    local selected_NPC_Model = ""

    local frame = vgui.Create("DFrame")
    frame:SetSize(1000, 768)
    frame:Center()
    frame:SetTitle("TR Prop: "..name_model)
    frame:MakePopup()

    local mainPanel = vgui.Create("DPanel", frame)
    mainPanel:Dock(TOP)
    mainPanel:SetHeight(250)

    local leftPanel = vgui.Create("DPanel", mainPanel)
    leftPanel:Dock(LEFT)
    leftPanel:SetWidth(500)


    local rightPanel = vgui.Create("DPanel", mainPanel)
    rightPanel:Dock(FILL)

    local modelList1 = vgui.Create("DListView", leftPanel)
    modelList1:Dock(FILL)
    modelList1:AddColumn("Prop")

    local modelList2 = vgui.Create("DListView", rightPanel)
    modelList2:Dock(FILL)
    modelList2:AddColumn("Added props")

    for _, model in pairs(npcModels) do
        modelList1:AddLine(model)
    end

    local searchEntry = vgui.Create("DTextEntry", frame)
    searchEntry:Dock(TOP)
    searchEntry:SetSize(0, 25)
    searchEntry:SetPlaceholderText("Search Prop")
    local customProp = vgui.Create("DTextEntry", frame)
    customProp:Dock(TOP)
    customProp:SetSize(0, 25)
    customProp:SetPlaceholderText("Set custom prop(Use Q-Menu to copy props)")

    local previewPanel = vgui.Create("DPanel", frame)
    previewPanel:Dock(FILL)
    previewPanel:SetSize(0, 100)

    local previewLabel = vgui.Create("DLabel", previewPanel)
    previewLabel:SetText("Preview Prop")
    previewLabel:Dock(TOP)

    local previewModel = vgui.Create("DModelPanel", previewPanel)
    previewModel:Dock(FILL)
    previewModel:SetModel(npcModels[1])
    previewModel:SetCamPos(Vector(200, 0, 100))
    previewModel:SetLookAt(Vector(-150, 0, 0))

    modelList1.OnClickLine = function(parent, line, isselected)
        local selectedModel = line:GetColumnText(1)
        previewModel:SetModel(selectedModel)
        selected_NPC_Model = selectedModel
    end

    for _, npc_models in pairs(items_NPC_Models) do -- Показывает имя в списке уже добавленных в замену
        modelList2:AddLine(npc_models)
    end

    searchEntry.OnEnter = function()
        local searchText = searchEntry:GetValue():lower()
        modelList1:Clear()

        for _, model in pairs(npcModels) do
            if model:lower():find(searchText, 1, true) then
                modelList1:AddLine(model)
            end
        end
    end

    local AddButton = vgui.Create("DButton", frame)
    AddButton:SetSize(200, 50)
    AddButton:SetPos(300, 718)
    AddButton:SetText("Add")
    AddButton.DoClick = function()
        local chance = 100
        local Skin = 0
        if not table.HasValue(items_NPC_Models, selected_NPC_Model.. ":"..chance..":"..Skin) and customProp:GetValue() != "" then
            modelList2:AddLine(customProp:GetValue().. ":"..chance..":"..Skin)
            table.insert(items_NPC_Models, customProp:GetValue().. ":"..chance..":"..Skin)
            WriteItemsFileTR_NPCModels(ply, items_NPC_Models)
        end
        if not table.HasValue(items_NPC_Models, selected_NPC_Model.. ":"..chance..":"..Skin) and customProp:GetValue() == "" then
            modelList2:AddLine(selected_NPC_Model.. ":"..chance..":"..Skin)
            table.insert(items_NPC_Models, selected_NPC_Model.. ":"..chance..":"..Skin)
            WriteItemsFileTR_NPCModels(ply, items_NPC_Models)
        end
    end

    local AddButtonAdditional = vgui.Create("DButton", frame)
    AddButtonAdditional:SetSize(200, 50)
    AddButtonAdditional:SetPos(600, 718)
    AddButtonAdditional:SetText("Add (Customizable)")
    AddButtonAdditional.DoClick = function()
    end

    -- Кнопка удаления
    local removeButton = vgui.Create("DButton", frame)
    removeButton:SetSize(280, 25)
    removeButton:SetPos(10, 625)
    removeButton:SetText("Delete selected Props")
    removeButton.DoClick = function()
        local selectedLine = modelList2:GetSelected()
        for _, line in pairs(selectedLine) do
            local lineID = line:GetID()
            table.remove(items_NPC_Models, lineID)
            WriteItemsFileTR_NPCModels(ply, items_NPC_Models)
        end
        modelList2:Clear()
        for _, npc_models in pairs(items_NPC_Models) do -- Показывает имя в списке уже добавленных в замену
            modelList2:AddLine(npc_models)
        end
    end

    -- Кнопка удаления Всех Записей
    local removeButtonAll = vgui.Create("DButton", frame)
    removeButtonAll:SetSize(100, 25)
    removeButtonAll:SetPos(10, 675)
    removeButtonAll:SetText("Delete ALL!")
    removeButtonAll.DoClick = function()
        local selectedLine = modelList2:GetSelectedLine()
        table.Empty(items_NPC_Models)
        modelList2:Clear()
        WriteItemsFileTR_NPCModels(ply, items_NPC_Models)
    end

    local openqmen = vgui.Create("DButton", frame)
    openqmen:SetSize(200, 50)
    openqmen:SetPos(0, 718)
    openqmen:SetText("Open Q-menu")
    openqmen.DoClick = function()
        LocalPlayer():ConCommand("+menu")
    end
end

concommand.Add("tr_npc_models_menu", function(ply, cmd, args)
    if not ply:IsPlayer() then return end
    local frame = vgui.Create("DFrame")
    frame:SetSize(800, 768)
    frame:Center()
    frame:SetTitle("Choose Prop")
    frame:MakePopup()

    local modelList = vgui.Create("DListView", frame)
    modelList:Dock(TOP)
    modelList:SetSize(0, 300)
    modelList:AddColumn("Model")

    for _, model in pairs(npcModels) do
        modelList:AddLine(model)
    end

    local searchEntry = vgui.Create("DTextEntry", frame)
    searchEntry:Dock(TOP)
    searchEntry:SetSize(0, 25)
    searchEntry:SetPlaceholderText("Search Prop")

    local customProp = vgui.Create("DTextEntry", frame)
    customProp:Dock(TOP)
    customProp:SetSize(0, 25)
    customProp:SetPlaceholderText("Or type in the location of Prop...(Use Q-Menu For Copy Props)")

    local previewPanel = vgui.Create("DPanel", frame)
    previewPanel:Dock(FILL)
    previewPanel:SetSize(0, 100)

    local previewLabel = vgui.Create("DLabel", previewPanel)
    previewLabel:SetText("Preview Prop")
    previewLabel:Dock(TOP)

    local previewModel = vgui.Create("DModelPanel", previewPanel)
    previewModel:Dock(FILL)
    previewModel:SetModel(npcModels[1])
    previewModel:SetCamPos(Vector(200, 0, 100))
    previewModel:SetLookAt(Vector(0, 0, 0))

    modelList.OnClickLine = function(parent, line, isselected)
        local selectedModel = line:GetColumnText(1)
        previewModel:SetModel(selectedModel)
        cur_table_tr_npc_model = selectedModel
    end

    searchEntry.OnEnter = function()
        local searchText = searchEntry:GetValue():lower()
        modelList:Clear()

        for _, model in pairs(npcModels) do
            if model:lower():find(searchText, 1, true) then
                modelList:AddLine(model)
            end
        end
    end

    local presetsButton = vgui.Create("DButton", frame)
    presetsButton:SetSize(200, 50)
    presetsButton:SetPos(600, 718)
    presetsButton:SetText("Presets")
    presetsButton.DoClick = function()
        RunConsoleCommand( "tr_presets_open_menu", "total_npcmodels_replacer" )
    end

    local openMenuButton = vgui.Create("DButton", frame)
    openMenuButton:SetSize(200, 50)
    openMenuButton:SetPos(300, 718)
    openMenuButton:SetText("Open Replacer")
    openMenuButton.DoClick = function()
        if customProp:GetValue() != "" then
            TR_NPCModelsMenuOpen(customProp:GetValue())
        else
            TR_NPCModelsMenuOpen(cur_table_tr_npc_model)
        end
    end

    local openqmen = vgui.Create("DButton", frame)
    openqmen:SetSize(200, 50)
    openqmen:SetPos(0, 718)
    openqmen:SetText("Open Q-menu")
    openqmen.DoClick = function()
        LocalPlayer():ConCommand("+menu")
    end

end)
-- local myTable = {} -- Основная таблица для данных

-- local function SaveToJson()
--     local jsonString = util.TableToJSON(myTable, true) -- true для красивого форматирования
--     local path = "total_npcmodels_replacer/myTable.json"
--     file.CreateDir("total_npcmodels_replacer")
--     file.Write(path, jsonString)
-- end

-- local function OpenMenu()
--     local frame = vgui.Create("DFrame")
--     frame:SetSize(400, 760)
--     frame:SetTitle("JSON Table Editor")
--     frame:Center()

--     local nameLabel = vgui.Create("DLabel", frame)
--     nameLabel:SetPos(10, 30)
--     nameLabel:SetText("Имя таблицы:")
--     nameLabel:SizeToContents()

--     local nameEntry = vgui.Create("DTextEntry", frame)
--     nameEntry:SetPos(10, 50)
--     nameEntry:SetSize(280, 20)

--     local addButton = vgui.Create("DButton", frame)
--     addButton:SetPos(10, 80)
--     addButton:SetSize(120, 30)
--     addButton:SetText("Добавить подтаблицу")

--     local editButton = vgui.Create("DButton", frame)
--     editButton:SetPos(140, 80)
--     editButton:SetSize(120, 30)
--     editButton:SetText("Редактировать подтаблицу")

--     local deleteButton = vgui.Create("DButton", frame)
--     deleteButton:SetPos(270, 80)
--     deleteButton:SetSize(120, 30)
--     deleteButton:SetText("Удалить подтаблицу")

--     local saveButton = vgui.Create("DButton", frame)
--     saveButton:SetPos(10, 730)
--     saveButton:SetSize(380, 30)
--     saveButton:SetText("Сохранить в JSON")

--     local subTableList = vgui.Create("DListView", frame)
--     subTableList:SetPos(10, 120)
--     subTableList:SetSize(380, 100)
--     subTableList:AddColumn("Подтаблицы")

--     addButton.DoClick = function()
--         local name = nameEntry:GetValue()
--         if name != "" then
--             myTable[name] = {}
--             subTableList:AddLine(name)
--         end
--     end

--     editButton.DoClick = function()
--         local selectedLine = subTableList:GetSelectedLine()
--         if selectedLine then
--             local name = subTableList:GetLine(selectedLine):GetValue(1)
--             local newName = nameEntry:GetValue()

--             if newName != "" and myTable[name] then
--                 myTable[newName] = table.Copy(myTable[name])
--                 myTable[name] = nil
--                 subTableList:Clear()
--                 for subTableName, _ in pairs(myTable) do
--                     subTableList:AddLine(subTableName)
--                 end
--             end
--         end
--     end

--     deleteButton.DoClick = function()
--         local selectedLine = subTableList:GetSelectedLine()
--         if selectedLine then
--             local name = subTableList:GetLine(selectedLine):GetValue(1)
--             myTable[name] = nil
--             subTableList:RemoveLine(selectedLine)
--         end
--     end

--     saveButton.DoClick = function()
--         SaveToJson()
--     end

--     frame:MakePopup()
-- end

-- concommand.Add("open_table_editor", OpenMenu)