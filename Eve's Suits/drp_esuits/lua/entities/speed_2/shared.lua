ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Upgraded Speed Suit" // name used by the suit
ENT.Author = "Eve Haddox"
ENT.Category = "Eve"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.action = function(ply) 
    ply:SetWalkSpeed(380) 
    ply:SetRunSpeed(500) 
    ply:SetMaxArmor(150) 
    ply:SetArmor(150)

    local model = est.playermodels["speed_2"]
    if not model then
        model = est.playermodels["default"]
    end

    ply:SetModel(model) 
end // effects on equiping