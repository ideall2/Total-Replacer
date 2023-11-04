-- Функция для замены оружия у НПС
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

local WeaponizedNPC = {
    "npc_monk",
    "npc_combine_s",
    "npc_metropolice",
    "npc_alyx",
    "npc_barney",
    "npc_breen",
    "npc_citizen",
    "npc_eli",
    "npc_kleiner",
    "npc_mossman",
}

-- Функция для проверки наличия элемента в списке
local function CheckStringInTable(list, itemToCheck)
    for _, item in ipairs(list) do
        if item == itemToCheck then
            return true
        end
    end
    return false
end

local function ReplaceNPCWeapon(npc, newWeaponClass)
    timer.Simple(0.01, function()
        local GettingActiveWeapon = npc:GetActiveWeapon()
        local GettingClassActWeap = NULL
        if GettingActiveWeapon != NULL then
            GettingActiveWeapon = npc:GetActiveWeapon():GetClass()
        end
        local CheckedWeapon = CheckStringInTable(standartWeaponNPC, GettingActiveWeapon)
        -- print(CheckedWeapon)
        if IsValid(npc) and npc:IsNPC() and CheckedWeapon then
            local oldWeapon = npc:GetActiveWeapon()
            if IsValid(oldWeapon) then
                oldWeapon:Remove() -- Удаляем текущее оружие
            end
            
            local newWeapon = ents.Create(newWeaponClass) -- Создаем новое оружие
            timer.Simple(0.003, function()
                if IsValid(newWeapon) then
                    newWeapon:SetPos(npc:GetPos())
                    newWeapon:SetAngles(npc:GetAngles())
                    npc:Give(newWeapon:GetClass()) -- Даем НПС новое оружие
                end
            end)
        end
    end)
end

-- Пример использования
hook.Add("OnEntityCreated", "ReplaceNPCWeaponOnSpawn", function(ent)
    if IsValid(ent) and ent:IsNPC() and CheckStringInTable(WeaponizedNPC, ent:GetClass()) then
        local newWeaponClass = "weapon_shotgun" -- Замените на класс оружия, которое вы хотите дать НПС
        ReplaceNPCWeapon(ent, newWeaponClass)
    end
end)