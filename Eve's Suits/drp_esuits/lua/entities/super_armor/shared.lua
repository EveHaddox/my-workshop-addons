ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Super Armor" // name used by the suit
ENT.Author = "Eve Haddox"
ENT.Category = "Eve"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.action = function(ply)

    ply:SetMaxArmor(1500)
    ply:SetArmor(1500)

    local model = est.playermodels["super_armor"]
    if not model then
        model = est.playermodels["default"]
    end

    ply:SetModel(model) 

end // effects on equiping