ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Heavy Armor" // name used by the suit
ENT.Author = "Eve Haddox"
ENT.Category = "Eve"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.action = function(ply) 
    ply:SetMaxArmor(1000) 
    ply:SetArmor(1000) 
    local model = est.playermodels["heavy_armor"]
    if not model then
        model = est.playermodels["default"]
    end

    ply:SetModel(model) 
    
end // effects on equiping