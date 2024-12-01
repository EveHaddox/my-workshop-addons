ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Light Armor" // name used by the suit
ENT.Author = "Eve Haddox"
ENT.Category = "Eve"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.action = function(ply) 
    ply:SetMaxArmor(200) 
    ply:SetArmor(200)
    
    local model = est.playermodels["light_armor"]
    if not model then
        model = est.playermodels["default"]
    end

    ply:SetModel(model) 
end // effects on equiping